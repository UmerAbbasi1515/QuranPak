import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/widgets/listview_builder_item_widget.dart';
import 'package:holy_quran/widgets/search_bar_widget.dart';
import 'package:holy_quran/widgets/top_mosque_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:quran/quran.dart' as quran;
import 'package:speech_to_text/speech_to_text.dart';

class SurahsScreen extends StatefulWidget {
  const SurahsScreen({super.key});

  @override
  State<SurahsScreen> createState() => _SurahsScreenState();
}

class _SurahsScreenState extends State<SurahsScreen> {
  final SpeechToText _speech = SpeechToText();
  final TextEditingController _searchController = TextEditingController();
  bool _isListening = false;
  Future<void> _initSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) => debugPrint('Status: $status'),
      onError: (error) => debugPrint('Error: $error'),
    );

    debugPrint('Available: $available');
  }

  Future<void> startListening() async {
    bool available = await _speech.initialize();

    if (!available) return;

    setState(() {
      _isListening = true;
    });

    _speech.listen(
      onResult: (result) {
        String text = result.recognizedWords;

        searchSurah(text); // Your search function

        if (result.finalResult) {
          setState(() {
            _isListening = false;
          });

          _speech.stop();
        }
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();

    setState(() {
      _isListening = false;
    });
  }

  List<SurahModel> allSurahs = [];
  List<SurahModel> filteredSurahs = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    allSurahs = List.generate(114, (index) {
      final number = index + 1;

      return SurahModel(
        number: number,
        englishName: quran.getSurahName(number),
        arabicName: quran.getSurahNameArabic(number),
      );
    });

    filteredSurahs = List.from(allSurahs);
  }

  void searchSurah(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        filteredSurahs = List.from(allSurahs);
      } else {
        filteredSurahs = allSurahs.where((surah) {
          return surah.englishName
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              surah.arabicName.contains(value);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundColor,
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                child: Row(
                  children: [
                    SizedBox(width: 2.w),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.goldTan,
                        size: 2.h,
                      ),
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      AppImagesPath.king,
                      width: 5.w,
                      height: 2.h,
                    ),
                  ],
                ),
              ),

              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 2.w,
                      right: 2.w,
                    ),
                    child: const TopMosqueWidget(
                      image: AppImagesPath.bismillahMosque,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 14.h),
                    child: SvgPicture.asset(
                      AppImagesPath.masgids,
                      fit: BoxFit.contain,
                      width: 100.w,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 25.h),
                    child: Center(
                      child: SearchBarWidget(
                        onChanged: (value) {
                          searchSurah(value);
                        },
                        onVoice: () {
                          if (_isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        },
                        controller: _searchController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7.h),
                    child: Center(
                      child: Column(
                        spacing: 0.0,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            easy.tr("Surrah"),
                            style: TextStyle(
                              fontFamily: AppFonts.interRegular,
                              fontSize: 18.sp,
                              color: AppColors.goldTan,
                            ),
                          ),
                          Text(
                            easy.tr(AppLabels.readyByParas),
                            style: TextStyle(
                              fontFamily: AppFonts.interRegular,
                              fontSize: 14.sp,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              Expanded(
                  child: SizedBox(
                width: 92.w,
                child: ListView.builder(
                  itemCount: filteredSurahs.length,
                  itemBuilder: (context, index) {
                    final surah = filteredSurahs[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: ListViewBuilderItemWidget(
                        index: surah.number,
                        number: surah.number,
                        engName: surah.englishName,
                        arabicName: surah.arabicName,
                      ),
                    );
                  },
                ),
              )),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SurahModel {
  final int number;
  final String englishName;
  final String arabicName;

  SurahModel({
    required this.number,
    required this.englishName,
    required this.arabicName,
  });
}
