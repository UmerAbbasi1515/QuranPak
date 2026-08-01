import 'package:flutter/material.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/core/theme/app_theme.dart';
import 'package:holy_quran/ui/widgets/app_card.dart';
import 'package:holy_quran/ui/widgets/star_badge.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

/// Row in the surah list: number star, transliteration + meta, Arabic name.
class SurahTile extends StatelessWidget {
  const SurahTile({
    super.key,
    required this.surah,
    this.onTap,
  });

  final SurahInfo surah;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          StarBadge(label: '${surah.number}', size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.englishName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'InterSemibold',
                    fontSize: 15,
                    color: palette.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${surah.isMakki ? easy.tr('makkah') : easy.tr('madinah')}  ·  ${surah.verseCount} ${easy.tr('verses')}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 12,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            surah.arabicName,
            style: AppTextStyles.arabicDisplay(
              color: palette.primary,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}

/// Row in the juz list.
class JuzTile extends StatelessWidget {
  const JuzTile({
    super.key,
    required this.juz,
    required this.startSurahName,
    this.onTap,
  });

  final JuzInfo juz;
  final String startSurahName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          StarBadge(
            label: '${juz.number}',
            size: 42,
            fill: palette.goldSoft,
            foreground: palette.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${easy.tr('para')} ${juz.number} · ${juz.englishName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'InterSemibold',
                    fontSize: 15,
                    color: palette.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${easy.tr('startsAt')}  $startSurahName ${juz.startSurah}:${juz.startVerse}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 12,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            juz.arabicName,
            textAlign: TextAlign.right,
            style: AppTextStyles.arabicDisplay(
              color: palette.gold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact search field used on the surah list and search screen.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontFamily: 'InterRegular',
        fontSize: 14,
        color: palette.text,
      ),
      cursorColor: palette.primary,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'InterRegular',
          fontSize: 14,
          color: palette.textFaint,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: palette.textFaint),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: Icon(Icons.close_rounded, color: palette.textMuted),
              onPressed: () {
                controller.clear();
                onChanged?.call('');
              },
            );
          },
        ),
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: palette.primary, width: 1.4),
        ),
      ),
    );
  }
}

/// Segmented control used for the Surah / Juz switch.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == selectedIndex ? palette.surface : null,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: i == selectedIndex ? palette.cardShadow : null,
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          i == selectedIndex ? 'InterSemibold' : 'InterMedium',
                      fontSize: 13.5,
                      color:
                          i == selectedIndex ? palette.text : palette.textMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
