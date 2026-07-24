
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

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
