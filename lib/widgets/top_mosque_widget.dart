import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class TopMosqueWidget extends StatelessWidget {
  final String image;
  const TopMosqueWidget({
    super.key, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: BoxFit.contain,
      width: 100.w,
    );
  }
}
