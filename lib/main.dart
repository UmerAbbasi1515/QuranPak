import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_theme.dart';
import 'package:holy_quran/features/root/root_shell.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Preferences and the surah/juz tables are needed before the first frame.
  await Get.putAsync(() => AppPrefs().init());
  await QuranRepository.instance.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('ur'),
        Locale('fa'),
        Locale('ps'),
        Locale('id'),
        Locale('bn'),
        Locale('tr'),
        Locale('ha'),
        Locale('so'),
        Locale('fr'),
        Locale('sw'),
      ],
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
    return Sizer(
      builder: (context, orientation, deviceType) => Obx(
        () => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holy Quran',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: AppPrefs.to.themeMode.value,
          home: const RootShell(),
        ),
      ),
    );
  }
}
