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
          constraints: BoxConstraints(minHeight: 100.h),
          child: Container(
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundColor),
            child: Column(
              children: [
                SizedBox(height: 5
                .h),
                Padding(
                  padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 4.w),
                  child: Row(
                    children: [
                      Column(
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
                      const Spacer(),
                      SvgPicture.asset(
                        AppImagesPath.king,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: 3.h,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5.h,
                    left: 2.w,
                    right: 1.w,
                  ),
                  child: TopMosqueWidget(
                    top: 0.h,
                    left: 2.w,
                    right: 1.w,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
