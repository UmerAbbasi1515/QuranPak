import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:sizer/sizer.dart';

class TopMosqueWidget extends StatelessWidget {
  final double top;
  final double left;
  final double right;
  const TopMosqueWidget({
    super.key,
    required this.top,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: SvgPicture.asset(
        AppImagesPath.bismillahMosque,
        fit: BoxFit.contain,
        width: 100.w,
      ),
    );
  }
}
