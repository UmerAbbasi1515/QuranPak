import 'package:flutter_test/flutter_test.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:quran/quran.dart' as quran;

/// The repository slices the `quran` package's verse tables by offset instead
/// of calling its per-verse lookups, so these tests check the two agree.
void main() {
  final repository = QuranRepository.instance;
  final english = QuranTranslations.byId('en_saheeh');

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await repository.init();
  });

  test('builds all 114 surahs and 30 juz', () {
    expect(repository.surahs.length, 114);
    expect(repository.juzs.length, 30);
    expect(repository.surah(1).englishName, 'Al-Fatihah');
    expect(repository.surah(1).meaning, 'The Opening');
    expect(repository.surah(2).verseCount, 286);
    expect(repository.juz(1).startSurah, 1);
    expect(repository.juz(1).startVerse, 1);
  });

  test('verse text matches the package for a sample across the Quran', () {
    for (final surahNumber in [1, 2, 18, 55, 78, 114]) {
      final verses = repository.versesOfSurah(surahNumber, english);
      expect(verses.length, quran.getVerseCount(surahNumber));

      for (final verseNumber in [1, verses.length]) {
        final ayah = verses[verseNumber - 1];
        expect(ayah.arabic, quran.getVerse(surahNumber, verseNumber));
        expect(
          ayah.translation,
          quran.getVerseTranslation(
            surahNumber,
            verseNumber,
            translation: quran.Translation.enSaheeh,
          ),
        );
      }
    }
  });

  test('every translation returns text for Al-Fatihah', () {
    for (final option in QuranTranslations.all) {
      final verses = repository.versesOfSurah(1, option);
      expect(verses.length, 7, reason: option.id);
      expect(verses.first.translation.trim(), isNotEmpty, reason: option.id);
    }
  });

  test('surah search handles numbers, transliterations and meanings', () {
    expect(repository.searchSurahs('36').single.number, 36);
    expect(
      repository.searchSurahs('bakara').first.number,
      2,
    );
    expect(repository.searchSurahs('The Opening').first.number, 1);
    expect(repository.searchSurahs('zzzz'), isEmpty);
  });

  test('translation search finds verses containing a word', () {
    final hits = repository.searchTranslation('mercy', english, limit: 5);
    expect(hits, isNotEmpty);
    expect(hits.first.translation.toLowerCase(), contains('mercy'));
  });

  test('verse of the day is stable within a day', () {
    final first = repository.verseOfTheDay(english);
    final second = repository.verseOfTheDay(english);
    expect(first.key, second.key);
  });
}
