import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ColorButtonWidget extends StatelessWidget {
  final double btnheight;
  final double btnWidth;
  final String btnText;
  final double fontSize;
  final Color fontColor;
  final String fontFamily;
  final Gradient gradient;
  final bool? isIcons;
  const ColorButtonWidget({
    super.key,
    required this.btnText,
    required this.btnheight,
    required this.btnWidth,
    required this.fontSize,
    required this.fontColor,
    required this.fontFamily,
    required this.gradient,
    this.isIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: gradient,
      ),
      height: btnheight,
      width: btnWidth,
      child: isIcons == false
          ? Align(
              alignment: Alignment.center,
              child: Text(
                btnText,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  color: fontColor,
                ),
              ),
            )
          : Row(
              children: [
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      btnText,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: fontSize,
                        color: fontColor,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 2.h,
                ),
                const Spacer(),
              ],
            ),
    );
  }
}
