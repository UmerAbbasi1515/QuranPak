import 'package:flutter/foundation.dart';
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

class ParahsScreen extends StatefulWidget {
  const ParahsScreen({super.key});

  @override
  State<ParahsScreen> createState() => _ParahsScreenState();
}

class _ParahsScreenState extends State<ParahsScreen> {
  final TextEditingController _searchController = TextEditingController();
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
                        onChanged: (val) {
                          if (kDebugMode) {
                            print(val);
                          }
                        },
                        onVoice: () {},
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
                            easy.tr(AppLabels.paras),
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
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    var count = index + 1;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: ListViewBuilderItemWidget(
                        index: count,
                        number: count,
                        engName: quran.getSurahName(count),
                        arabicName: quran.getSurahNameArabic(count),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
