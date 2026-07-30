import 'package:quran/quran.dart' as quran;
import 'package:quran/quran_text.dart' show quranText;
import 'package:quran/translations/bengali.dart' show bengali;
import 'package:quran/translations/chinese.dart' show chinese;
import 'package:quran/translations/en_clearquran.dart' show enClearQuran;
import 'package:quran/translations/en_saheeh.dart' show enSaheeh;
import 'package:quran/translations/fa_husseindari.dart' show faHusseinDari;
import 'package:quran/translations/fr_hamidullah.dart' show frHamidullah;
import 'package:quran/translations/indonesian.dart' show indonesian;
import 'package:quran/translations/it_piccardo.dart' show itPiccardo;
import 'package:quran/translations/ml_abdulhameed.dart' show mlAbdulHameed;
import 'package:quran/translations/nl_siregar.dart' show nlSiregar;
import 'package:quran/translations/portuguese.dart' show portuguese;
import 'package:quran/translations/ru_kuliev.dart' show ruKuliev;
import 'package:quran/translations/spanish.dart' show spanish;
import 'package:quran/translations/swedish.dart' show swedish;
import 'package:quran/translations/tr_saheeh.dart' show trSaheeh;
import 'package:quran/translations/urdu.dart' show urdu;

/// Direct access to the `quran` package's verse tables.
///
/// The package's public `getVerse` / `getVerseTranslation` helpers scan all
/// 6,236 verses on every single call, which is far too slow to build a whole
/// surah (Al-Baqarah alone would mean ~3.5M comparisons). These tables are
/// ordered by surah then verse, so one cumulative offset per surah lets us
/// slice a surah out in one step.
///
/// This is the only place that reaches into the package's internals — if the
/// dependency ever restructures its files, this file is what needs updating.
class QuranSource {
  QuranSource._();

  static final List<int> _surahOffsets = _buildOffsets();

  static List<int> _buildOffsets() {
    final offsets = <int>[0];
    var running = 0;
    for (var surah = 1; surah <= 114; surah++) {
      running += quran.getVerseCount(surah);
      offsets.add(running);
    }
    return offsets;
  }

  static List<dynamic> _tableFor(quran.Translation translation) {
    switch (translation) {
      case quran.Translation.enSaheeh:
        return enSaheeh;
      case quran.Translation.enClearQuran:
        return enClearQuran;
      case quran.Translation.trSaheeh:
        return trSaheeh;
      case quran.Translation.mlAbdulHameed:
        return mlAbdulHameed;
      case quran.Translation.faHusseinDari:
        return faHusseinDari;
      case quran.Translation.frHamidullah:
        return frHamidullah;
      case quran.Translation.itPiccardo:
        return itPiccardo;
      case quran.Translation.nlSiregar:
        return nlSiregar;
      case quran.Translation.portuguese:
        return portuguese;
      case quran.Translation.ruKuliev:
        return ruKuliev;
      case quran.Translation.urdu:
        return urdu;
      case quran.Translation.bengali:
        return bengali;
      case quran.Translation.chinese:
        return chinese;
      case quran.Translation.indonesian:
        return indonesian;
      case quran.Translation.spanish:
        return spanish;
      case quran.Translation.swedish:
        return swedish;
    }
  }

  /// Arabic text of every verse in [surahNumber], in order.
  static List<String> arabicVerses(int surahNumber) =>
      _slice(quranText, surahNumber);

  /// Translated text of every verse in [surahNumber], in order.
  static List<String> translatedVerses(
    int surahNumber,
    quran.Translation translation,
  ) =>
      _slice(_tableFor(translation), surahNumber);

  static List<String> _slice(List<dynamic> table, int surahNumber) {
    final start = _surahOffsets[surahNumber - 1];
    final end = _surahOffsets[surahNumber];

    if (end <= table.length) {
      final first = table[start] as Map;
      if (first['surah_number'] == surahNumber && first['verse_number'] == 1) {
        return [
          for (var i = start; i < end; i++)
            (table[i] as Map)['content'].toString(),
        ];
      }
    }

    // The table isn't laid out as expected — fall back to filtering it.
    return [
      for (final row in table)
        if ((row as Map)['surah_number'] == surahNumber)
          row['content'].toString(),
    ];
  }
}
