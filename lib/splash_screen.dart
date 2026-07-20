import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/select_language.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundColor,
              ),
              padding: EdgeInsets.only(top: 5.h),
              height: 100.h,
              width: 100.h,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 100.h,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 1.w, right: 1.w),
                            child: SizedBox(
                              child: SvgPicture.asset(
                                AppImagesPath.bismillahMosque,
                                fit: BoxFit.contain,
                                width: 100.w,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                child: SvgPicture.asset(
                                  AppImagesPath.group,
                                  fit: BoxFit.contain,
                                  height: 30.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              context.locale.languageCode,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 60.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'app_name'.tr(),
                                style: TextStyle(
                                  fontFamily: AppFonts.interRegular,
                                  fontSize: 22.sp,
                                  color: AppColors.goldTan,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 67.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'welcome_subtitle'.tr(),
                                style: TextStyle(
                                  fontFamily: AppFonts.interRegular,
                                  fontSize: 13.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 82.h),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: AppColors.goldGradient),
                                height: 3.h,
                                width: 70.w,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'lets_start'.tr(),
                                    style: TextStyle(
                                      fontFamily: AppFonts.interBold,
                                      fontSize: 12.sp,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
            InkWell(
              onTap: () {
                // Get.offAll(() => const LanguageScreen());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.language,
                        color: AppColors.white, size: 3.h)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:holy_quran/constant/style/app_colors.dart';
// import 'package:sizer/sizer.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateNext();
//   }

//   Future<void> _navigateNext() async {
//     await Future.delayed(const Duration(seconds: 3));
//     if (!mounted) return;
//     // replace with your actual screen
//   }

//   // All languages currently enabled in EasyLocalization
//   final List<Map<String, String>> _languages = const [
//     {'code': 'en', 'label': 'English'},
//     {'code': 'ar', 'label': 'العربية'},
//     {'code': 'ur', 'label': 'اردو'},
//     {'code': 'fa', 'label': 'فارسی'},
//     {'code': 'ps', 'label': 'پښتو'},
//     {'code': 'id', 'label': 'Bahasa Indonesia'},
//     {'code': 'bn', 'label': 'বাংলা'},
//     {'code': 'tr', 'label': 'Türkçe'},
//     {'code': 'ha', 'label': 'Hausa'},
//     {'code': 'so', 'label': 'Soomaali'},
//     {'code': 'fr', 'label': 'Français'},
//     {'code': 'sw', 'label': 'Kiswahili'},
//   ];

//   void _showLanguageSheet() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 2.h,),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'select_language'.tr()(),
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 1.h),
//                 ConstrainedBox(
//                   constraints: BoxConstraints(maxHeight: 50.h),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: _languages.length,
//                     itemBuilder: (context, index) {
//                       final lang = _languages[index];
//                       final isSelected =
//                           context.locale.languageCode == lang['code'];
//                       return ListTile(
//                         title: Text(lang['label']!),
//                         trailing: isSelected
//                             ? const Icon(Icons.check, color: Colors.green)
//                             : null,
//                         onTap: () {
//                           context.setLocale(Locale(lang['code']!));
//                           Navigator.pop(context);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 100.h,
//         width: 100.w,
//         decoration: const BoxDecoration(gradient: AppColors.backgroundColor),
//         child: Stack(
//           children: [
//             // Language change icon - top left
//             Positioned(
//               top: 5.h,
//               left: 4.w,
//               child: SafeArea(
//                 child: IconButton(
//                   onPressed: _showLanguageSheet,
//                   icon: const Icon(Icons.language, color: Colors.white),
//                 ),
//               ),
//             ),

//             // Test labels
//             Padding(
//               padding: EdgeInsets.all(8.h),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 // crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'welcome'.tr()(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 1.h),
//                   Text(
//                     'app_name'.tr()(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16.sp,
//                     ),
//                   ),
//                   SizedBox(height: 1.h),
//                   Text(
//                     'para'.tr()(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                   SizedBox(height: 1.h),
//                   Text(
//                     'continue_reading'.tr()(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
