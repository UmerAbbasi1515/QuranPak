import 'package:flutter/material.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/core/theme/app_theme.dart';
import 'package:quran/quran.dart' as quran;
import 'package:easy_localization/easy_localization.dart' as easy;

/// The ornamented plate that opens every surah in the reader.
class SurahHeaderCard extends StatelessWidget {
  const SurahHeaderCard({
    super.key,
    required this.surah,
    required this.arabicFontSize,
  });

  final SurahInfo surah;
  final double arabicFontSize;

  /// Every surah opens with the basmala except At-Tawbah (9); in Al-Fatihah (1)
  /// it is verse 1 and therefore already part of the verse list.
  bool get _showBasmala => surah.number != 1 && surah.number != 9;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            gradient: palette.heroGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Text(
                surah.arabicName,
                style: AppTextStyles.arabicDisplay(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                surah.englishName,
                style: const TextStyle(
                  fontFamily: 'InterSemibold',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                surah.meaning,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'InterRegular',
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${surah.isMakki ? easy.tr('makkah') : easy.tr('madinah')}  ·  ${surah.verseCount} ${easy.tr('verses')}   ·  ${easy.tr('page')}  ${surah.startPage}',
                  style: TextStyle(
                    fontFamily: 'InterMedium',
                    fontSize: 11.5,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showBasmala) ...[
          const SizedBox(height: 18),
          Text(
            quran.basmala,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: AppTextStyles.arabic(
              color: palette.text,
              fontSize: arabicFontSize * 0.95,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 6),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
