import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_theme.dart';
import 'package:holy_quran/features/root/root_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Preferences and the surah/juz tables are needed before the first frame.
  await Get.putAsync(() => AppPrefs().init());
  await QuranRepository.instance.init();

  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString('app_locale');
  final supportedLocales = <Locale>[
    const Locale('en'),
    const Locale('ar'),
    const Locale('ur'),
    const Locale('fa'),
    const Locale('ps'),
    const Locale('id'),
    const Locale('bn'),
    const Locale('tr'),
    const Locale('ha'),
    const Locale('so'),
    const Locale('fr'),
    const Locale('sw'),
  ];
  final startLocale = savedLocaleCode != null &&
          supportedLocales.any((locale) => locale.languageCode == savedLocaleCode)
      ? Locale(savedLocaleCode)
      : null;

  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    maxAdContentRating: MaxAdContentRating.g,
    tagForChildDirectedTreatment:
        TagForChildDirectedTreatment.yes, // if relevant
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(
    EasyLocalization(
      startLocale: startLocale,
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      saveLocale: true,
      child: const HolyQuranApp(),
    ),
  );
}

class HolyQuranApp extends StatelessWidget {
  const HolyQuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sizer stays mounted for the legacy screens that still use `.h` / `.w`.
    return Builder(
      builder: (easyContext) {
        return Sizer(
          builder: (context, orientation, deviceType) => Obx(
            () => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Holy Quran',
              localizationsDelegates: easyContext.localizationDelegates,
              supportedLocales: easyContext.supportedLocales,
              locale: easyContext.locale,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: AppPrefs.to.themeMode.value,
              home: const RootShell(),
            ),
          ),
        );
      },
    );
  }
}
