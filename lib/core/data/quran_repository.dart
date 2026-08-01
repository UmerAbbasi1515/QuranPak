import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/data/quran_source.dart';
import 'package:quran/quran.dart' as quran;

/// Single access point for Quran content.
///
/// Text, translations and page/juz metadata come from the `quran` package
/// (fully offline); the English surah meanings come from the bundled
/// `assets/translations/en.json`, which already ships a 114-entry table.
class QuranRepository {
  QuranRepository._();

  static final QuranRepository instance = QuranRepository._();

  static const int surahCount = 114;
  static const int juzCount = 30;

  final List<SurahInfo> _surahs = [];
  final List<JuzInfo> _juzs = [];

  /// Built surahs keyed by `translationId#surahNumber`.
  final Map<String, List<Ayah>> _surahCache = {};

  /// Holds a single entry: the current day's verse in the current translation.
  final Map<String, Ayah> _verseOfTheDayCache = {};

  /// Widely-recited verses, cycled through one per day.
  static const List<List<int>> _dailyVerses = [
    [2, 255], // Ayat al-Kursi
    [2, 286],
    [2, 152],
    [2, 186],
    [3, 139],
    [3, 159],
    [3, 185],
    [4, 103],
    [6, 162],
    [8, 46],
    [13, 28],
    [14, 7],
    [16, 128],
    [17, 80],
    [18, 10],
    [20, 114],
    [24, 35],
    [29, 69],
    [39, 53],
    [41, 33],
    [49, 13],
    [55, 13],
    [64, 11],
    [65, 3],
    [94, 6],
    [103, 3],
  ];

  List<SurahInfo> get surahs => List.unmodifiable(_surahs);
  List<JuzInfo> get juzs => List.unmodifiable(_juzs);

  Future<void> init() async {
    if (_surahs.isNotEmpty) return;

    final names = await _loadSurahNames();

    for (var number = 1; number <= surahCount; number++) {
      final name = names[number];
      _surahs.add(
        SurahInfo(
          number: number,
          arabicName: quran.getSurahNameArabic(number),
          englishName: name?.transliteration ?? quran.getSurahName(number),
          meaning: name?.meaning ?? quran.getSurahNameEnglish(number),
          verseCount: quran.getVerseCount(number),
          revelationPlace: quran.getPlaceOfRevelation(number),
          startPage: quran.getSurahPages(number).first,
        ),
      );
    }

    for (var number = 1; number <= juzCount; number++) {
      final contents = quran.getSurahAndVersesFromJuz(number);
      final firstSurah = contents.keys.first;
      _juzs.add(
        JuzInfo(
          number: number,
          arabicName: _juzArabicNames[number - 1],
          englishName: _juzEnglishNames[number - 1],
          startSurah: firstSurah,
          startVerse: contents[firstSurah]!.first,
          surahNumbers: contents.keys.toList(),
        ),
      );
    }
  }

  SurahInfo surah(int number) => _surahs[number - 1];

  JuzInfo juz(int number) => _juzs[number - 1];

  /// Every verse of [surahNumber] with the translation from [option].
  ///
  /// Cached, because the reader rebuilds this list on every settings change.
  List<Ayah> versesOfSurah(int surahNumber, TranslationOption option) {
    final cacheKey = '${option.id}#$surahNumber';
    final cached = _surahCache[cacheKey];
    if (cached != null) return cached;

    final arabic = QuranSource.arabicVerses(surahNumber);
    final translated = QuranSource.translatedVerses(surahNumber, option.value);

    final verses = List<Ayah>.generate(arabic.length, (index) {
      final verseNumber = index + 1;
      return Ayah(
        surahNumber: surahNumber,
        verseNumber: verseNumber,
        arabic: arabic[index],
        translation: index < translated.length ? translated[index] : '',
        isSajdah: quran.isSajdahVerse(surahNumber, verseNumber),
      );
    });

    // Only a couple of surahs are ever open at once; keep the cache small.
    if (_surahCache.length > 6) _surahCache.clear();
    _surahCache[cacheKey] = verses;

    return verses;
  }

  Ayah verse(int surahNumber, int verseNumber, TranslationOption option) {
    return Ayah(
      surahNumber: surahNumber,
      verseNumber: verseNumber,
      arabic: quran.getVerse(surahNumber, verseNumber),
      translation: quran.getVerseTranslation(
        surahNumber,
        verseNumber,
        translation: option.value,
      ),
      isSajdah: quran.isSajdahVerse(surahNumber, verseNumber),
    );
  }

  int verseJuz(int surahNumber, int verseNumber) =>
      quran.getJuzNumber(surahNumber, verseNumber);

  int versePage(int surahNumber, int verseNumber) =>
      quran.getPageNumber(surahNumber, verseNumber);

  /// A well-known verse that stays the same for the whole calendar day.
  Ayah verseOfTheDay(TranslationOption option) {
    final today = DateTime.now();
    final dayNumber =
        DateTime(today.year, today.month, today.day).millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
    final cacheKey = '${option.id}#$dayNumber';

    final cached = _verseOfTheDayCache[cacheKey];
    if (cached != null) return cached;

    final reference = _dailyVerses[dayNumber % _dailyVerses.length];
    final ayah = verse(reference[0], reference[1], option);

    _verseOfTheDayCache
      ..clear()
      ..[cacheKey] = ayah;

    return ayah;
  }

  /// Filters surahs by number, transliteration, meaning or Arabic name.
  List<SurahInfo> searchSurahs(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return surahs;

    final asNumber = int.tryParse(trimmed);
    if (asNumber != null && asNumber >= 1 && asNumber <= surahCount) {
      return [surah(asNumber)];
    }

    final needle = _normalize(trimmed);
    final words = needle.split(' ').where((w) => w.isNotEmpty).toList();

    final matches = _surahs.where((s) {
      final haystack =
          '${_normalize(s.englishName)} ${_normalize(s.meaning)} ${s.arabicName}';
      return words.any(
        (w) => haystack.contains(w) || s.arabicName.contains(trimmed),
      );
    }).toList();

    // Surahs matching every word first, then the looser matches.
    matches.sort((a, b) {
      bool matchesAll(SurahInfo s) {
        final haystack = '${_normalize(s.englishName)} ${_normalize(s.meaning)}';
        return words.every(haystack.contains);
      }

      final aAll = matchesAll(a);
      final bAll = matchesAll(b);
      if (aAll == bAll) return a.number.compareTo(b.number);
      return aAll ? -1 : 1;
    });

    return matches;
  }

  /// Full-text search over the selected translation.
  ///
  /// The `quran` package scans all 6,236 verses, so callers should debounce
  /// and keep [limit] small.
  List<Ayah> searchTranslation(
    String query,
    TranslationOption option, {
    int limit = 60,
  }) {
    final trimmed = query.trim();
    if (trimmed.length < 3) return const [];

    final result = quran.searchWordsInTranslation(
      [trimmed],
      translation: option.value,
    );

    final hits = (result['result'] as List).take(limit);
    return hits
        .map(
          (hit) => verse(
            (hit as Map)['surah'] as int,
            hit['verse'] as int,
            option,
          ),
        )
        .toList();
  }

  /// Loose transliteration matching: "baqarah", "bakara" and "Al-Baqara" should
  /// all find the same surah.
  String _normalize(String input) {
    var s = input.toLowerCase();
    s = s.replaceAll('q', 'k');
    s = s.replaceAll('th', 's');
    s = s.replaceAll('dh', 'z');
    s = s.replaceAll('gh', 'g');
    s = s.replaceAll('kh', 'k');
    s = s.replaceAll('aa', 'a');
    s = s.replaceAll('ee', 'i');
    s = s.replaceAll('oo', 'u');
    s = s.replaceAll('-', ' ');
    s = s.replaceAll(RegExp(r'[^a-z0-9\s]'), '');
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s;
  }

  /// Transliterated names and English meanings from the bundled locale file —
  /// nicer than the package's own spellings ("Al-Fatihah" vs "Al Fatiha").
  Future<Map<int, _SurahName>> _loadSurahNames() async {
    try {
      final raw = await rootBundle.loadString('assets/translations/en.json');
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final entries = decoded['surahs'] as List<dynamic>? ?? const [];

      return {
        for (final entry in entries.cast<Map<String, dynamic>>())
          if (entry['number'] is int &&
              (entry['transliteration'] as String?)?.isNotEmpty == true)
            entry['number'] as int: _SurahName(
              transliteration: entry['transliteration'] as String,
              meaning: (entry['meaning_en'] as String?) ?? '',
            ),
      };
    } catch (_) {
      // Falls back to the package's names.
      return const {};
    }
  }

  static const List<String> _juzArabicNames = [
    'الم',
    'سيقول',
    'تلك الرسل',
    'لن تنالوا',
    'والمحصنات',
    'لا يحب الله',
    'وإذا سمعوا',
    'ولو أننا',
    'قال الملأ',
    'واعلموا',
    'يعتذرون',
    'وما من دابة',
    'وما أبرئ',
    'ربما',
    'سبحان الذي',
    'قال ألم',
    'اقترب للناس',
    'قد أفلح',
    'وقال الذين',
    'أمن خلق',
    'اتل ما أوحي',
    'ومن يقنت',
    'وما لي',
    'فمن أظلم',
    'إليه يرد',
    'حم',
    'قال فما خطبكم',
    'قد سمع الله',
    'تبارك الذي',
    'عم يتساءلون',
  ];

  static const List<String> _juzEnglishNames = [
    'Alif Lam Meem',
    'Sayaqul',
    'Tilkal Rusul',
    'Lan Tanaloo',
    'Wal Mohsanat',
    'La Yuhibbullah',
    'Wa Iza Samiu',
    'Wa Lau Annana',
    'Qalal Malau',
    'Wa Alamu',
    'Yatazeroon',
    'Wa Mamin Dabbatin',
    'Wa Ma Ubarriu',
    'Rubama',
    'Subhanallazi',
    'Qal Alam',
    'Iqtarabalinnas',
    'Qad Aflaha',
    'Wa Qalallazina',
    'Amman Khalaqa',
    'Utlu Ma Oohiya',
    'Wa Manyaqnut',
    'Wa Mali',
    'Faman Azlam',
    'Elahe Yuraddu',
    'Ha Meem',
    'Qala Fama Khatbukum',
    'Qad Sami Allah',
    'Tabarakallazi',
    'Amma Yatasa aloon',
  ];
}

class _SurahName {
  const _SurahName({required this.transliteration, required this.meaning});

  final String transliteration;
  final String meaning;
}
