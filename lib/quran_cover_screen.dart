import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/quran_dashboard/home/parah_reading_screen.dart';
import 'package:holy_quran/quran_dashboard/home/surah_reading_screen.dart';
import 'package:sizer/sizer.dart';

class QuranCoverScreen extends StatefulWidget {
  final int number;
  final String name;
  final bool isSurah;

  const QuranCoverScreen(
      {super.key,
      required this.number,
      this.isSurah = true,
      required this.name});

  @override
  State<QuranCoverScreen> createState() => _QuranCoverScreenState();
}

class _QuranCoverScreenState extends State<QuranCoverScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (widget.isSurah == true) {
        Get.off(
          () => ReadSurahScreen(
            surahNumber: widget.number,
          ),
        );
      } else {
        Get.off(
          () => ReadParahScreen(
            parahNumber: widget.number,
            name: widget.name,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B0E0E),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: SvgPicture.asset(
                AppImagesPath.frame, // Replace with your cover SVG
                fit: BoxFit.fill,
              ),
            ),
            Center(
              child: CircularProgressIndicator(
                color: Colors.white, // Golden color
                strokeWidth: 0.5.h,
              ),
            )
          ],
        ),
      ),
    );
  }
}
