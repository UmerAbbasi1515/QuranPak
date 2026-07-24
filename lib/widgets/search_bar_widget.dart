import 'package:flutter/material.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:sizer/sizer.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoice;
  const SearchBarWidget({
    super.key,
    @required this.onChanged,
    @required this.onVoice,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92.w,
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
        controller: controller,
        style: TextStyle(
          color: AppColors.white,
          fontFamily: AppFonts.interRegular,
          fontSize: 14.sp,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: AppColors.white,
            fontFamily: AppFonts.interRegular,
            fontSize: 14.sp,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.goldTan,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.mic,
              color: AppColors.goldTan,
            ),
            onPressed: onVoice,
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
