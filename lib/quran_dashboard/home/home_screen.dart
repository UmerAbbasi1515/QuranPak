import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/widgets/top_mosque_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 90.h),
          child: Container(
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundColor),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 2.h),
                      child: SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 0.0,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    easy.tr(AppLabels.welcome),
                                    style: TextStyle(
                                      fontFamily: AppFonts.interRegular,
                                      fontSize: 13.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    easy.tr(AppLabels.appName),
                                    style: TextStyle(
                                      fontFamily: AppFonts.interRegular,
                                      fontSize: 17.sp,
                                      color: AppColors.goldTan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 10.w,
                              child: SvgPicture.asset(
                                AppImagesPath.king,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 3.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 5.h),
                      child: const TopMosqueWidget(),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 1.w, right: 1.w, top: 22.h),
                      child: SvgPicture.asset(
                        AppImagesPath.masgids,
                        fit: BoxFit.contain,
                        width: 100.w,
                      ),
                    )
                  ],
                ),
                Container(
                  height: 20.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.brownGradient,
                    border: Border.all(
                      color: AppColors.goldTan,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              easy.tr(AppLabels.addNewBookmark),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 14.sp,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              easy.tr(AppLabels.welcome),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.interRegular,
                                fontSize: 12.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform(
                              transform:
                                  Matrix4.translationValues(0, -8.h, 0),
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 12.h,
                                width: 12.h,
                                child: SvgPicture.asset(
                                  AppImagesPath.quranPak,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              easy.tr(AppLabels.welcome),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.interRegular,
                                fontSize: 12.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
