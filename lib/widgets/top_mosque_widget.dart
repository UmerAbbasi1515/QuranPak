import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:sizer/sizer.dart';

class TopMosqueWidget extends StatelessWidget {
  const TopMosqueWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImagesPath.bismillahMosque,
      fit: BoxFit.contain,
      width: 100.w,
    );
  }
}
