import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class ListViewBuilderItemWidget extends StatelessWidget {
  final int index;
  final int number;
  final String engName;
  final String arabicName;
  final Function()? onTap;
  final bool isSurah;
  const ListViewBuilderItemWidget({
    super.key,
    required this.index,
    required this.number,
    required this.engName,
    required this.arabicName,
    this.isSurah = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(1.h), // match the Container's radius
      onTap: onTap,
      child: Container(
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
                      padding: EdgeInsets.only(
                          top: index < 10
                              ? 1.6.h
                              : index < 100
                                  ? 1.8.h
                                  : 2.h,
                          left: index < 10
                              ? 4.w
                              : index < 100
                                  ? 3.w
                                  : 2.8.w),
                      child: Text(
                        index.toString(),
                        style: TextStyle(
                          fontFamily: AppFonts.interBold,
                          fontSize: index < 100 ? 14.sp : 13.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.h, bottom: 2.5.h, left: 3.w),
                child: Column(
                  spacing: 0.0,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSurah
                          ? "Suarh No ${easy.tr(number.toString())}"
                          : "Parah No ${easy.tr(number.toString())}",
                      style: TextStyle(
                        fontFamily: AppFonts.interRegular,
                        fontSize: 14.sp,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      easy.tr(engName),
                      style: TextStyle(
                        fontFamily: AppFonts.interBold,
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
                  easy.tr(arabicName),
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
          )),
    );
  }
}
