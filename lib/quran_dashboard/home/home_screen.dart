import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holy_quran/constant/app_labels.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/constant/style/app_styles.dart';
import 'package:holy_quran/widgets.dart';
import 'package:holy_quran/widgets/button_widget.dart';
import 'package:holy_quran/widgets/top_mosque_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GridItemData> homeGridItems = [
    GridItemData(
      image: AppImagesPath.quranPak,
      title: easy.tr(AppLabels.paras).toString(),
      subtitle: easy.tr(AppLabels.readyByParas).toString(),
    ),
    GridItemData(
      image: AppImagesPath.surahsIm,
      title: easy.tr(AppLabels.paras).toString(),
      subtitle: easy.tr(AppLabels.readyByParas).toString(),
    ),
    GridItemData(
      image: AppImagesPath.gotopage,
      title: easy.tr(AppLabels.goToPage).toString(),
      subtitle: easy.tr("${AppLabels.jumpTo} ${AppLabels.page}").toString(),
    ),
    GridItemData(
      image: AppImagesPath.bookmarkN,
      title: easy.tr(AppLabels.bookmark).toString(),
      subtitle: easy.tr(AppLabels.savedPlaces).toString(),
    ),
    GridItemData(
      image: AppImagesPath.duas,
      title: easy.tr(AppLabels.dailyDuas).toString(),
      subtitle: easy.tr(AppLabels.duasCollection).toString(),
    ),
    GridItemData(
      image: AppImagesPath.features,
      title: easy.tr(AppLabels.moreFeatures).toString(),
      subtitle: easy.tr(AppLabels.exploreMore).toString(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 90.h),
          child: Container(
            decoration:
                const BoxDecoration(gradient: AppColors.backgroundColor),
            child: Column(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 2.h),
                      child: SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 0.0,
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    easy.tr(AppLabels.welcome),
                                    style: TextStyle(
                                      fontFamily: AppFonts.interRegular,
                                      fontSize: 13.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  Text(
                                    easy.tr(AppLabels.appName),
                                    style: TextStyle(
                                      fontFamily: AppFonts.interRegular,
                                      fontSize: 17.sp,
                                      color: AppColors.goldTan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 10.w,
                              child: SvgPicture.asset(
                                AppImagesPath.king,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 3.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1.w, right: 1.w, top: 5.h),
                      child: const TopMosqueWidget(
                        image: AppImagesPath.bismillahMosque,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 1.w, right: 1.w, top: 22.h),
                      child: SvgPicture.asset(
                        AppImagesPath.masgids,
                        fit: BoxFit.contain,
                        width: 100.w,
                      ),
                    )
                  ],
                ),
                Container(
                  height: 15.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.brownGradient,
                    border: Border.all(
                      color: AppColors.goldTan,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                easy.tr(SurahNames.arabic[0]),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 22.sp,
                                  color: AppColors.goldTan,
                                ),
                              ),
                              Text(
                                easy.tr("Al-Fatihah"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 18.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "${easy.tr(AppLabels.page)} 45 . ${easy.tr(AppLabels.juzz)} 2",
                                textAlign: TextAlign.center,
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
                      Expanded(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform(
                            transform: Matrix4.translationValues(0, -6.h, 0),
                            child: SvgPicture.asset(
                              AppImagesPath.quranPak,
                              fit: BoxFit.fill,
                              width: 11.h,
                            ),
                          ),
                          Transform(
                            transform: Matrix4.translationValues(0, -3.h, 0),
                            child: ColorButtonWidget(
                                btnText: easy.tr(AppLabels.continueReading),
                                btnheight: 3.h,
                                btnWidth: 36.w,
                                fontSize: 13.sp,
                                fontFamily: AppFonts.interBold,
                                fontColor: AppColors.black,
                                gradient: AppColors.goldGradient,
                                isIcons: true),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: homeGridItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return DashboardGridWidget(
                      height: 13.h,
                      width: 10.h,
                      radius: 2.h,
                      gradient: AppColors.brownGradient,
                      borderColor: AppColors.goldTan,
                      image: homeGridItems[index].image,
                      title: homeGridItems[index].title,
                      subTitle: homeGridItems[index].subtitle,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GridItemData {
  final String image;
  final String title;
  final String subtitle;

  const GridItemData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
