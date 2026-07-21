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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1.0.h,
            spreadRadius: 0.1.h,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items!,
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
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 10.h,
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
                          fit: BoxFit.fill,
                          width: double.infinity,
                          height: 10.h,
                        ),
                      ),
                    )
                  : SvgPicture.asset(
                      AppImagesPath.home,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: 2.h,
                    ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            title??"",
            style: TextStyle(
              fontFamily: AppFonts.interRegular,
              fontSize: 12.sp,
            ),
          )
        ],
      ),
    );
  }
}
