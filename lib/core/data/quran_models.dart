import 'package:quran/quran.dart' as quran;

/// One chapter of the Quran, with everything the list rows need up front.
class SurahInfo {
  const SurahInfo({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.meaning,
    required this.verseCount,
    required this.revelationPlace,
    required this.startPage,
  });

  final int number;

  /// e.g. الفاتحة
  final String arabicName;

  /// Transliteration, e.g. "Al-Fatihah".
  final String englishName;

  /// Translated name, e.g. "The Opening".
  final String meaning;

  final int verseCount;

  /// "Makkah" or "Madinah".
  final String revelationPlace;
  final int startPage;

  bool get isMakki => revelationPlace.toLowerCase().startsWith('mak');
}

/// One of the 30 parts the Quran is traditionally divided into.
class JuzInfo {
  const JuzInfo({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.startSurah,
    required this.startVerse,
    required this.surahNumbers,
  });

  final int number;
  final String arabicName;
  final String englishName;
  final int startSurah;
  final int startVerse;
  final List<int> surahNumbers;
}

/// A single verse plus its translation in the currently selected language.
class Ayah {
  const Ayah({
    required this.surahNumber,
    required this.verseNumber,
    required this.arabic,
    required this.translation,
    required this.isSajdah,
  });

  final int surahNumber;
  final int verseNumber;
  final String arabic;
  final String translation;
  final bool isSajdah;

  /// Stable id used for bookmarks, e.g. "2:255".
  String get key => '$surahNumber:$verseNumber';

  int get page => quran.getPageNumber(surahNumber, verseNumber);
  int get juz => quran.getJuzNumber(surahNumber, verseNumber);
}

/// A translation the reader can be switched to, as offered by the `quran`
/// package.
class TranslationOption {
  const TranslationOption({
    required this.id,
    required this.label,
    required this.nativeLabel,
    required this.value,
    this.isRtl = false,
  });

  /// Persisted in preferences — keep these strings stable.
  final String id;

  /// English name of the language.
  final String label;

  /// How the language names itself.
  final String nativeLabel;

  final quran.Translation value;
  final bool isRtl;
}

class QuranTranslations {
  QuranTranslations._();

  static const List<TranslationOption> all = [
    TranslationOption(
      id: 'en_saheeh',
      label: 'English — Saheeh International',
      nativeLabel: 'English',
      value: quran.Translation.enSaheeh,
    ),
    TranslationOption(
      id: 'en_clear',
      label: 'English — The Clear Quran',
      nativeLabel: 'English',
      value: quran.Translation.enClearQuran,
    ),
    TranslationOption(
      id: 'ur',
      label: 'Urdu',
      nativeLabel: 'اردو',
      value: quran.Translation.urdu,
      isRtl: true,
    ),
    TranslationOption(
      id: 'fa',
      label: 'Persian / Dari',
      nativeLabel: 'فارسی',
      value: quran.Translation.faHusseinDari,
      isRtl: true,
    ),
    TranslationOption(
      id: 'bn',
      label: 'Bengali',
      nativeLabel: 'বাংলা',
      value: quran.Translation.bengali,
    ),
    TranslationOption(
      id: 'id',
      label: 'Indonesian',
      nativeLabel: 'Bahasa Indonesia',
      value: quran.Translation.indonesian,
    ),
    TranslationOption(
      id: 'tr',
      label: 'Turkish',
      nativeLabel: 'Türkçe',
      value: quran.Translation.trSaheeh,
    ),
    TranslationOption(
      id: 'fr',
      label: 'French',
      nativeLabel: 'Français',
      value: quran.Translation.frHamidullah,
    ),
    TranslationOption(
      id: 'es',
      label: 'Spanish',
      nativeLabel: 'Español',
      value: quran.Translation.spanish,
    ),
    TranslationOption(
      id: 'ru',
      label: 'Russian',
      nativeLabel: 'Русский',
      value: quran.Translation.ruKuliev,
    ),
    TranslationOption(
      id: 'ml',
      label: 'Malayalam',
      nativeLabel: 'മലയാളം',
      value: quran.Translation.mlAbdulHameed,
    ),
    TranslationOption(
      id: 'nl',
      label: 'Dutch',
      nativeLabel: 'Nederlands',
      value: quran.Translation.nlSiregar,
    ),
    TranslationOption(
      id: 'it',
      label: 'Italian',
      nativeLabel: 'Italiano',
      value: quran.Translation.itPiccardo,
    ),
    TranslationOption(
      id: 'pt',
      label: 'Portuguese',
      nativeLabel: 'Português',
      value: quran.Translation.portuguese,
    ),
    TranslationOption(
      id: 'sv',
      label: 'Swedish',
      nativeLabel: 'Svenska',
      value: quran.Translation.swedish,
    ),
    TranslationOption(
      id: 'zh',
      label: 'Chinese',
      nativeLabel: '中文',
      value: quran.Translation.chinese,
    ),
  ];

  static TranslationOption byId(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => all.first);
}

/// Where the reader was last left off, so "Continue reading" can resume.
class LastRead {
  const LastRead({
    required this.surahNumber,
    required this.verseNumber,
    required this.savedAt,
  });

  final int surahNumber;
  final int verseNumber;
  final DateTime savedAt;

  String encode() =>
      '$surahNumber:$verseNumber:${savedAt.millisecondsSinceEpoch}';

  static LastRead? decode(String? raw) {
    if (raw == null) return null;
    final parts = raw.split(':');
    if (parts.length < 3) return null;
    final surah = int.tryParse(parts[0]);
    final verse = int.tryParse(parts[1]);
    final millis = int.tryParse(parts[2]);
    if (surah == null || verse == null || millis == null) return null;
    return LastRead(
      surahNumber: surah,
      verseNumber: verse,
      savedAt: DateTime.fromMillisecondsSinceEpoch(millis),
    );
  }
}
