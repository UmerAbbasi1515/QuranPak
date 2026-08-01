import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/features/settings/translation_picker.dart';
import 'package:holy_quran/ui/widgets/app_card.dart';
import 'package:holy_quran/ui/widgets/list_tiles.dart';

/// App-wide preferences: reading, appearance and interface language.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  /// Interface languages that have a file in `assets/translations`.
  static const Map<String, String> _appLanguages = {
    'en': 'English',
    'ar': 'العربية',
    'ur': 'اردو',
    'fa': 'فارسی',
    'ps': 'پښتو',
    'id': 'Bahasa Indonesia',
    'bn': 'বাংলা',
    'tr': 'Türkçe',
    'ha': 'Hausa',
    'so': 'Soomaali',
    'fr': 'Français',
    'sw': 'Kiswahili',
  };

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

  static String _currentLanguage(BuildContext context) =>
      easy.EasyLocalization.of(context)?.locale.languageCode ?? 'en';
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final prefs = AppPrefs.to;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Text(
                easy.tr('settings'),
                style: TextStyle(
                  fontFamily: 'InterBold',
                  fontSize: 24,
                  color: palette.text,
                ),
              ),
              const SizedBox(height: 18),
              SectionHeader(title: easy.tr('reading')),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Column(
                  children: [
                    _Row(
                      icon: Icons.translate_rounded,
                      title: easy.tr('translation'),
                      subtitle: prefs.translation.label,
                      onTap: () async {
                        await showTranslationPicker(context);
                        Get.forceAppUpdate();
                        setState(() {});
                      },
                    ),
                    _Divider(),
                    _Row(
                      icon: Icons.subtitles_rounded,
                      title: easy.tr('showTranslation'),
                      subtitle: easy.tr('displayMeaningUnderVerse'),
                      trailing: Switch.adaptive(
                        value: prefs.showTranslation.value,
                        onChanged: prefs.setShowTranslation,
                        // Cupertino switches ignore SwitchTheme.
                        activeTrackColor: palette.primary,
                      ),
                    ),
                    _Divider(),
                    _SliderRow(
                      title: easy.tr('arabicTextSize'),
                      value: prefs.arabicFontSize.value,
                      min: AppPrefs.minArabicFontSize,
                      max: AppPrefs.maxArabicFontSize,
                      onChanged: prefs.setArabicFontSize,
                    ),
                    _Divider(),
                    _SliderRow(
                      title: easy.tr('translationTextSize'),
                      value: prefs.translationFontSize.value,
                      min: AppPrefs.minTranslationFontSize,
                      max: AppPrefs.maxTranslationFontSize,
                      onChanged: prefs.setTranslationFontSize,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(title: easy.tr('appearance')),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      easy.tr('theme'),
                      style: TextStyle(
                        fontFamily: 'InterMedium',
                        fontSize: 14,
                        color: palette.text,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SegmentedTabs(
                      labels: [
                        easy.tr('system'),
                        easy.tr('light'),
                        easy.tr('dark')
                      ],
                      selectedIndex: ThemeMode.values
                          .indexOf(prefs.themeMode.value)
                          .clamp(0, 2),
                      onChanged: (index) =>
                          prefs.setThemeMode(ThemeMode.values[index]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(title: easy.tr('appLanguage')),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: _Row(
                  icon: Icons.language_rounded,
                  title: easy.tr('interfaceLanguage'),
                  subtitle: SettingsScreen._appLanguages[
                          SettingsScreen._currentLanguage(context)] ??
                      SettingsScreen._currentLanguage(context),
                  onTap: () => _pickAppLanguage(context),
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(title: easy.tr('about')),
              const SizedBox(height: 10),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      easy.tr('app_name'),
                      style: TextStyle(
                        fontFamily: 'InterSemibold',
                        fontSize: 15,
                        color: palette.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      easy.tr('offlineDataNote'),
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 13,
                        height: 1.55,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAppLanguage(BuildContext context) async {
    final palette = context.palette;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (sheetContext, scrollController) => Column(
          children: [
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  easy.tr('select_lang'),
                  style: TextStyle(
                    fontFamily: 'InterSemibold',
                    fontSize: 17,
                    color: palette.text,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  for (final entry in SettingsScreen._appLanguages.entries)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: palette.surfaceAlt,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          entry.value,
                          style: TextStyle(
                            fontFamily: 'InterMedium',
                            fontSize: 14,
                            color: palette.text,
                          ),
                        ),
                        trailing: SettingsScreen._currentLanguage(context) ==
                                entry.key
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: palette.primary,
                                size: 21,
                              )
                            : null,
                        onTap: () async {
                          await easy.EasyLocalization.of(context)!
                              .setLocale(Locale(entry.key));
                          if (sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: palette.primarySoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 18, color: palette.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'InterMedium',
                      fontSize: 14,
                      color: palette.text,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 12.5,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (onTap == null
                    ? const SizedBox.shrink()
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: palette.textFaint,
                      )),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String title;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'InterMedium',
                  fontSize: 14,
                  color: palette.text,
                ),
              ),
              const Spacer(),
              Text(
                value.round().toString(),
                style: TextStyle(
                  fontFamily: 'InterMedium',
                  fontSize: 13,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: context.palette.border);
}
