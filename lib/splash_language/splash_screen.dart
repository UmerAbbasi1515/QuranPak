import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/select_language.dart';
import 'package:holy_quran/widgets/button_widget.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25), // slower = more elegant
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

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
                              child: RotationTransition(
                                turns: _rotationController,
                                child: SizedBox(
                                  child: SvgPicture.asset(
                                    AppImagesPath.group,
                                    fit: BoxFit.contain,
                                    height: 30.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 32.4.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                child: SvgPicture.asset(
                                  AppImagesPath.quranKareem,
                                  fit: BoxFit.contain,
                                  height: 15.h,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 60.h),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                easy.tr(AppLabels.appName),
                                style: TextStyle(
                                  fontFamily: AppFonts.interRegular,
                                  fontSize: 25.sp,
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
                                easy.tr(AppLabels.welcomeSubtitle),
                                style: TextStyle(
                                  fontFamily: AppFonts.interRegular,
                                  fontSize: 15.sp,
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
                              child: ColorButtonWidget(
                                btnText: easy.tr(AppLabels.letsStart),
                                btnheight: 3.5.h,
                                btnWidth: 70.w,
                                fontSize: 13.sp,
                                fontFamily: AppFonts.interBold,
                                fontColor: AppColors.black,
                                gradient: AppColors.goldGradient,
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
                getx.Get.offAll(() => const LanguageScreen());
              },
              child: Padding(
                padding: EdgeInsets.all(2.h),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.language,
                    color: AppColors.white,
                    size: 3.h,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:easy_localization/easy_localization.dart' as easy;
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart' as getx;
// import 'package:holy_quran/constant/app_labels.dart';
// import 'package:holy_quran/constant/assets_path.dart';
// import 'package:holy_quran/constant/style/app_colors.dart';
// import 'package:holy_quran/constant/style/app_styles.dart';
// import 'package:holy_quran/select_language.dart';
// import 'package:holy_quran/widgets/button_widget.dart';
// import 'package:sizer/sizer.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 gradient: AppColors.backgroundColor,
//               ),
//               padding: EdgeInsets.only(top: 5.h),
//               height: 100.h,
//               width: 100.h,
//               child: Stack(
//                 children: [
//                   SingleChildScrollView(
//                     child: SizedBox(
//                       height: 100.h,
//                       child: Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(left: 1.w, right: 1.w),
//                             child: SizedBox(
//                               child: SvgPicture.asset(
//                                 AppImagesPath.bismillahMosque,
//                                 fit: BoxFit.contain,
//                                 width: 100.w,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 25.h),
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               child: SizedBox(
//                                 child: SvgPicture.asset(
//                                   AppImagesPath.group,
//                                   fit: BoxFit.contain,
//                                   height: 30.h,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 2.h,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 60.h),
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               child: Text(
//                                 easy.tr(AppLabels.appName),
//                                 style: TextStyle(
//                                   fontFamily: AppFonts.interRegular,
//                                   fontSize: 25.sp,
//                                   color: AppColors.goldTan,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 1.h,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(top: 67.h),
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               child: Text(
//                                 easy.tr(AppLabels.welcomeSubtitle),
//                                 style: TextStyle(
//                                   fontFamily: AppFonts.interRegular,
//                                   fontSize: 15.sp,
//                                   color: AppColors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5.h,
//                           ),
//                           Align(
//                             alignment: Alignment.topCenter,
//                             child: Padding(
//                               padding: EdgeInsets.only(top: 82.h),
//                               child: ColorButtonWidget(
//                                 btnText: easy.tr(AppLabels.letsStart),
//                                 btnheight: 3.5.h,
//                                 btnWidth: 70.w,
//                                 fontSize: 13.sp,
//                                 fontFamily: AppFonts.interBold,
//                                 fontColor: AppColors.black,
//                                 gradient: AppColors.goldGradient,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: SvgPicture.asset(
//                       AppImagesPath.footer,
//                       fit: BoxFit.fill,
//                       width: double.infinity,
//                       height: 10.h,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 getx.Get.offAll(() => const LanguageScreen());
//               },
//               child: Padding(
//                 padding: EdgeInsets.all(2.h),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Icon(
//                     Icons.language,
//                     color: AppColors.white,
//                     size: 3.h,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
