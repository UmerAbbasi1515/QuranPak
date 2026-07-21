import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' as getx;
import 'package:holy_quran/quran_navgationbar/quran_navbar_screen.dart';
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/splash_language/select_language.dart';
import 'package:holy_quran/widgets/button_widget.dart';
import 'package:holy_quran/widgets/top_mosque_widget.dart';
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
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.backgroundColor,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 100.h,
                      child: Stack(
                        children: [
                          TopMosqueWidget(
                            top: 5.h,
                            left: 0,
                            right: 0,
                          ),
                          Positioned(
                            top: 25.h,
                            left: 0,
                            right: 0,
                            child: RotationTransition(
                              turns: _rotationController,
                              child: SvgPicture.asset(
                                AppImagesPath.group,
                                height: 30.h,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 32.4.h,
                            left: 0,
                            right: 0,
                            child: SvgPicture.asset(
                              AppImagesPath.quranKareem,
                              height: 15.h,
                            ),
                          ),
                          Positioned(
                            top: 60.h,
                            left: 0,
                            right: 0,
                            child: Center(
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
                          Positioned(
                            top: 67.h,
                            left: 0,
                            right: 0,
                            child: Center(
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
                          Positioned(
                            top: 82.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  if (kDebugMode) {
                                    print("Let's Start");
                                  }
                                  getx.Get.offAll(
                                      () => const QuransDashboardTabs());
                                },
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
            Positioned(
              top: 2.h,
              right: 2.h,
              child: InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print("Language");
                  }
                  getx.Get.offAll(() => const LanguageScreen());
                },
                child: Padding(
                  padding: EdgeInsets.all(2.h),
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

