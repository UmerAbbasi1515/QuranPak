import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/quran_dashboard/quran_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  if (kDebugMode) {
    print('Bismillah');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final languageSelected = prefs.getBool('language_selected') ?? false;

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
      saveLocale: true,
      child: MyApp(
        languageSelected: languageSelected,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool languageSelected;
  const MyApp({
    super.key,
    required this.languageSelected,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              );
              return MediaQuery(data: data, child: child!);
            },
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
              scaffoldBackgroundColor: Colors.grey,
              canvasColor: Colors.transparent,
              snackBarTheme:
                  const SnackBarThemeData(backgroundColor: Colors.white54),
            ),
            home: const QuransDashboardTabs()
            // home: widget.languageSelected
            //     ? const SplashScreen()
            //     : const LanguageScreen()
            // home: const LanguageScreen(),
            );
      },
    );
  }
}
