import 'package:flutter/material.dart';

class ColorButtonWidget extends StatelessWidget {
  final double btnheight;
  final double btnWidth;
  final String btnText;
  final double fontSize;
  final Color fontColor;
  final String fontFamily;
  final Gradient gradient;
  const ColorButtonWidget({
    super.key,
    required this.btnText,
    required this.btnheight,
    required this.btnWidth,
    required this.fontSize,
    required this.fontColor,
    required this.fontFamily,
    required this.gradient,
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
    );
  }
}
