import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:sizer/sizer.dart';

class CustomNavBar extends StatelessWidget {
  final List<Widget>? items;
  const CustomNavBar({
    super.key,
    @required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.only(top: 1.0.h, bottom: 1.0.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(1.5.h)),
        color: AppColors.maroon,
        boxShadow: const [AppShadows.topBlackShadow],
      ),
      child: SizedBox(
        width: 100.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items!,
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final Function(int)? onTap;
  final int? position;
  final String? title;
  final String? icon;
  const NavBarItem({
    super.key,
    @required this.onTap,
    @required this.position,
    @required this.title,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!(position!);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == "IconBlue"
              ? SizedBox(
                  height: 2.h,
                  width: 5.h,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.maroon,
                    child: SvgPicture.asset(
                      AppImagesPath.home,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : icon == "IconGrey"
                  ? SizedBox(
                      height: 2.h,
                      width: 5.h,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: SvgPicture.asset(
                          AppImagesPath.home,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 2.h,
                      width: 5.h,
                      child: SvgPicture.asset(
                        AppImagesPath.home,
                        fit: BoxFit.contain,
                      ),
                    ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            title ?? "",
            style: TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.interRegular,
              fontSize: 13.sp,
            ),
          )
        ],
      ),
    );
  }
}