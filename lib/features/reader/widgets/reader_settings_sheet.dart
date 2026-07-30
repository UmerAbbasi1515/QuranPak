import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/core/theme/app_theme.dart';
import 'package:holy_quran/features/settings/translation_picker.dart';
import 'package:holy_quran/ui/widgets/list_tiles.dart';

/// Quick reading controls: translation, text sizes and theme — all live, with
/// a preview so the effect of a slider is visible while dragging.
Future<void> showReaderSettingsSheet(BuildContext context) {
  final palette = context.palette;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: palette.surface,
    builder: (context) {
      final prefs = AppPrefs.to;

      return SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: SheetHandle()),
                  Text(
                    'Reading settings',
                    style: TextStyle(
                      fontFamily: 'InterSemibold',
                      fontSize: 17,
                      color: palette.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _preview(context, prefs),
                  const SizedBox(height: 18),
                  _rowLabel(context, 'Translation'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => showTranslationPicker(context),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surfaceAlt,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              prefs.translation.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'InterMedium',
                                fontSize: 14,
                                color: palette.text,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.expand_more_rounded,
                            color: palette.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: prefs.showTranslation.value,
                    onChanged: prefs.setShowTranslation,
                    activeColor: palette.onPrimary,
                    activeTrackColor: palette.primary,
                    title: Text(
                      'Show translation',
                      style: TextStyle(
                        fontFamily: 'InterMedium',
                        fontSize: 14,
                        color: palette.text,
                      ),
                    ),
                  ),
                  _slider(
                    context,
                    label: 'Arabic size',
                    value: prefs.arabicFontSize.value,
                    min: AppPrefs.minArabicFontSize,
                    max: AppPrefs.maxArabicFontSize,
                    onChanged: prefs.setArabicFontSize,
                  ),
                  _slider(
                    context,
                    label: 'Translation size',
                    value: prefs.translationFontSize.value,
                    min: AppPrefs.minTranslationFontSize,
                    max: AppPrefs.maxTranslationFontSize,
                    onChanged: prefs.setTranslationFontSize,
                  ),
                  const SizedBox(height: 12),
                  _rowLabel(context, 'Appearance'),
                  const SizedBox(height: 8),
                  SegmentedTabs(
                    labels: const ['System', 'Light', 'Dark'],
                    selectedIndex: ThemeMode.values
                        .indexOf(prefs.themeMode.value)
                        .clamp(0, 2),
                    onChanged: (index) =>
                        prefs.setThemeMode(ThemeMode.values[index]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _preview(BuildContext context, AppPrefs prefs) {
  final palette = context.palette;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: palette.surfaceAlt,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: AppTextStyles.arabic(
            color: palette.text,
            fontSize: prefs.arabicFontSize.value,
          ),
        ),
        if (prefs.showTranslation.value) ...[
          const SizedBox(height: 8),
          Text(
            '[All] praise is [due] to Allah, Lord of the worlds.',
            style: TextStyle(
              fontFamily: 'InterRegular',
              fontSize: prefs.translationFontSize.value,
              height: 1.6,
              color: palette.textMuted,
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _rowLabel(BuildContext context, String label) => Text(
      label,
      style: TextStyle(
        fontFamily: 'InterMedium',
        fontSize: 13,
        color: context.palette.textMuted,
      ),
    );

Widget _slider(
  BuildContext context, {
  required String label,
  required double value,
  required double min,
  required double max,
  required ValueChanged<double> onChanged,
}) {
  final palette = context.palette;

  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'InterMedium',
              fontSize: 13.5,
              color: palette.text,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(
            value.round().toString(),
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'InterMedium',
              fontSize: 13,
              color: palette.textMuted,
            ),
          ),
        ),
      ],
    ),
  );
}
