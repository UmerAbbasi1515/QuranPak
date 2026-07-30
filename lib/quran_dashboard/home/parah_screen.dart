import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/quran_cover_screen.dart';
import 'package:holy_quran/widgets/listview_builder_item_widget.dart';
import 'package:holy_quran/widgets/search_bar_widget.dart';
import 'package:holy_quran/widgets/top_mosque_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:speech_to_text/speech_to_text.dart';

class ParahsScreen extends StatefulWidget {
  const ParahsScreen({super.key});

  @override
  State<ParahsScreen> createState() => _ParahsScreenState();
}

class _ParahsScreenState extends State<ParahsScreen> {
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

  void startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _searchController.text = result.recognizedWords;
            _searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: _searchController.text.length),
            );
          });
          searchParah(result.recognizedWords);
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  List<ParahModel> allParahs = [];
  List<ParahModel> filteredParahs = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    allParahs = AppLabels.parahList;
    filteredParahs = List.from(allParahs);
  }

  String normalizeArabicTransliteration(String input) {
    String s = input.toLowerCase();
    // common interchangeable transliteration pairs
    s = s.replaceAll('q', 'k'); // falaq -> falak, baqarah -> bakarah
    s = s.replaceAll('th', 's'); // fatih... / thaqib etc
    s = s.replaceAll('dh', 'z');
    s = s.replaceAll('gh', 'g');
    s = s.replaceAll('kh', 'k');
    s = s.replaceAll('aa', 'a');
    s = s.replaceAll('ee', 'i');
    s = s.replaceAll('oo', 'u');
    s = s.replaceAll('-', ' ');
    s = s.replaceAll(RegExp(r'[^a-z0-9\s]'), ''); // strip stray punctuation

    return s;
  }

  void searchParah(String value) {
    setState(() {
      final query = normalizeArabicTransliteration(value.trim());

      if (query.isEmpty) {
        filteredParahs = List.from(allParahs);
        return;
      }

      final words =
          query.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

      filteredParahs = allParahs.where((surah) {
        final engName = normalizeArabicTransliteration(surah.englishName);
        final arabicName = surah.arabicName;

        return words
            .any((word) => engName.contains(word) || arabicName.contains(word));
      }).toList();

      filteredParahs.sort((a, b) {
        final aName = normalizeArabicTransliteration(a.englishName);
        final bName = normalizeArabicTransliteration(b.englishName);
        final aAllMatch = words.every((w) => aName.contains(w));
        final bAllMatch = words.every((w) => bName.contains(w));
        if (aAllMatch == bAllMatch) return 0;
        return aAllMatch ? -1 : 1;
      });
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
                          searchParah(value);
                        },
                        onVoice: () {
                          if (_isListening) {
                            stopListening();
                          } else {
                            startListening();
                          }
                        },
                        cancel: () {
                          if (_isListening) {
                            _speech
                                .stop(); // or your existing stopListening() logic minus the setState duplication
                          }
                          setState(() {
                            _isListening = false;
                          });
                        },
                        controller: _searchController,
                        isListening: _isListening, // <-- pass this through
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
                            easy.tr("Parahs"),
                            style: TextStyle(
                              fontFamily: AppFonts.interRegular,
                              fontSize: 18.sp,
                              color: AppColors.goldTan,
                            ),
                          ),
                          Text(
                            easy.tr('Read By Parahs'),
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
                  itemCount: filteredParahs.length,
                  itemBuilder: (context, index) {
                    final parah = filteredParahs[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: ListViewBuilderItemWidget(
                          index: parah.number,
                          number: parah.number,
                          engName: parah.englishName,
                          arabicName: parah.arabicName,
                          isSurah: false,
                          onTap: () {
                            Get.to(() => QuranCoverScreen(
                                  number: index + 1,
                                  isSurah: false,
                                  name: parah.englishName,
                                ));
                          }),
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

class ParahModel {
  final int number;
  final String englishName;
  final String arabicName;

  const ParahModel({
    required this.number,
    required this.englishName,
    required this.arabicName,
  });
}
