import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class WidgetOfProject extends StatefulWidget {
  const WidgetOfProject({super.key});

  @override
  State<WidgetOfProject> createState() => _WidgetOfProjectState();
}

class _WidgetOfProjectState extends State<WidgetOfProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DashboardGridWidget(
                height: 13.h,
                width: 10.h,
                radius: 2.h,
                gradient: AppColors.brownGradient,
                borderColor: AppColors.goldTan,
                image: AppImagesPath.quranPak,
                title: AppLabels.appName,
                subTitle: AppLabels.appName,
              ),
              SizedBox(
                height: 0.5.h,
              ),
              SearchBarWidget(
                onPressed: () {
                  if (kDebugMode) {
                    print('Voice');
                  }
                },
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Container(
                  width: 90.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.brownGradient,
                    border: Border.all(
                      color: AppColors.goldTan,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      1.h,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 3.w,
                      ),
                      SizedBox(
                        width: 10.w,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              AppImagesPath.stars,
                              height: 6.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 1.6.h,left: 5.3.w),
                              child: Text(
                                "1",
                                style: TextStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 16.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 1.h, bottom: 2.5.h, left: 3.w),
                        child: Column(
                          spacing: 0.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              easy.tr(AppLabels.para),
                              style: TextStyle(
                                fontFamily: AppFonts.interRegular,
                                fontSize: 18.sp,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              easy.tr(AppLabels.para),
                              style: TextStyle(
                                fontFamily: AppFonts.interRegular,
                                fontSize: 14.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.h, left: 3.w),
                        child: Text(
                          easy.tr(SurahNames.arabic.first),
                          style: TextStyle(
                            fontFamily: AppFonts.interBold,
                            fontSize: 20.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.goldTan,
                        size: 2.h,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final Function()? onPressed;
  const SearchBarWidget({
    super.key,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 5.h,
      decoration: BoxDecoration(
        gradient: AppColors.brownGradient,
        border: Border.all(
          color: AppColors.goldTan,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: TextField(
        cursorColor: AppColors.white,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.interRegular,
              fontSize: 14.sp),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.goldTan,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.mic,
              color: AppColors.goldTan,
            ),
            onPressed: onPressed,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class DashboardGridWidget extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Gradient gradient;
  final Color borderColor;
  final String image;
  final String title;
  final String subTitle;
  const DashboardGridWidget({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
    required this.gradient,
    required this.borderColor,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: gradient,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: 4.h,
          ),
          Text(
            easy.tr(title),
            style: TextStyle(
              fontFamily: AppFonts.interBold,
              fontSize: 14.sp,
              color: AppColors.white,
            ),
          ),
          Text(
            easy.tr(subTitle),
            style: TextStyle(
              fontFamily: AppFonts.interRegular,
              fontSize: 12.sp,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
