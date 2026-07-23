import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/splash_language/splash_screen.dart';
import 'package:holy_quran/widgets/top_mosque_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  // All languages currently enabled in EasyLocalization
  final List<Map<String, String>> _languages = const [
    {'code': 'en', 'label': 'English'},
    {'code': 'ar', 'label': 'العربية'},
    {'code': 'ur', 'label': 'اردو'},
    {'code': 'fa', 'label': 'فارسی'},
    {'code': 'ps', 'label': 'پښتو'},
    {'code': 'id', 'label': 'Bahasa Indonesia'},
    {'code': 'bn', 'label': 'বাংলা'},
    {'code': 'tr', 'label': 'Türkçe'},
    {'code': 'ha', 'label': 'Hausa'},
    {'code': 'so', 'label': 'Soomaali'},
    {'code': 'fr', 'label': 'Français'},
    {'code': 'sw', 'label': 'Kiswahili'},
  ];

  String? _selectedCode;

  @override
  void initState() {
    super.initState();
    language();
  }

  language() async {
    final prefs = await SharedPreferences.getInstance();
    var code = prefs.getString('language_code');
    setState(() {
      _selectedCode = code ?? 'en';
    });
  }

  void _onLanguageSelected(String? code) async {
    if (code == null) return;

    setState(() {
      _selectedCode = code;
    });

    await context.setLocale(Locale(code));
    getx.Get.updateLocale(Locale(code));
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
    await prefs.setBool('language_selected', true);

    if (!mounted) return;

    getx.Get.offAll(() => const SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundColor),
          height: 100.h,
          width: 100.w,
          child: Stack(
            children: [
              // Top image
              Padding(
                padding: EdgeInsets.only(top: 5.h, left: 0.5.h, right: 0.5.h),
                child: const TopMosqueWidget(),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        easy.tr(AppLabels.selectLanguage),
                        style: TextStyle(
                          fontFamily: AppFonts.interBold,
                          fontSize: 18.sp,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: 80.w,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            child: DropdownButton<String>(
                              value: _selectedCode,
                              isExpanded: true,
                              dropdownColor: Colors.white, // <-- Add this
                              iconEnabledColor: Colors.black,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              hint: Text(
                                easy.tr(AppLabels.selectLanguage),
                                style: const TextStyle(color: Colors.black),
                              ),
                              items: _languages.map((lang) {
                                return DropdownMenuItem<String>(
                                  value: lang['code'],
                                  child: Text(
                                    lang['label']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: _onLanguageSelected,
                            )),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom footer image
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  AppImagesPath.footer,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 10.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
