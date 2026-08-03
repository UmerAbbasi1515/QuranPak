import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/core/theme/app_theme.dart';
import 'package:holy_quran/features/ads_controller.dart';
import 'package:holy_quran/features/reader/reader_screen.dart';
import 'package:holy_quran/features/search/search_screen.dart';
import 'package:holy_quran/ui/widgets/app_card.dart';
import 'package:holy_quran/ui/widgets/list_tiles.dart';
import 'package:holy_quran/ui/widgets/star_badge.dart';

/// Landing tab: where you left off, quick entry points and a verse for today.
class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
    required this.onOpenLibrary,
    required this.onOpenBookmarks,
  });

  /// Opens the read tab on section 0 (surahs) or 1 (juz).
  final ValueChanged<int> onOpenLibrary;

  /// Opens the bookmarks tab.
  final VoidCallback onOpenBookmarks;

  final MobileAdsController adsController = Get.put(MobileAdsController());
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final repository = QuranRepository.instance;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 24),
          children: [
            _Greeting(onSearch: () {
              adsController.showInterstitialAd();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            }),
            const SizedBox(height: 10),
            _ContinueReadingCard(
              repository: repository,
              adsController: adsController,
            ),
            const SizedBox(height: 18),
            _QuickActions(
              onOpenLibrary: onOpenLibrary,
              onOpenBookmarks: onOpenBookmarks,
              adsController: adsController,
            ),
            const SizedBox(height: 22),
            _VerseOfTheDay(
              repository: repository,
              adsController: adsController,
            ),
            const SizedBox(height: 22),
            SectionHeader(
              title: easy.tr('surahsL'),
              actionLabel: easy.tr('seeAll'),
              onAction: () {
                adsController.showInterstitialAd();
                onOpenLibrary(0);
              },
            ),
            const SizedBox(height: 10),
            for (final surah in repository.surahs.take(3))
              SurahTile(
                  surah: surah,
                  onTap: () {
                    adsController.showInterstitialAd();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReaderScreen(surahNumber: surah.number)));
                  }),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                easy.tr('app_name'),
                style: TextStyle(
                  fontFamily: 'InterBold',
                  fontSize: 24,
                  color: palette.text,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onSearch,
          tooltip: easy.tr('search'),
          icon: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.border),
            ),
            child: Icon(Icons.search_rounded, color: palette.text, size: 20),
          ),
        ),
      ],
    );
  }
}

/// Hero card that resumes the last reading position.
class _ContinueReadingCard extends StatelessWidget {
  const _ContinueReadingCard(
      {required this.repository, required this.adsController});

  final QuranRepository repository;

  final MobileAdsController adsController;
  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Obx(() {
      final lastRead = AppPrefs.to.lastRead.value;
      final surahNumber = lastRead?.surahNumber ?? 1;
      final verseNumber = lastRead?.verseNumber ?? 1;
      final surah = repository.surah(surahNumber);
      final progress = verseNumber / surah.verseCount;

      return GestureDetector(
        onTap: () {
          adsController.showInterstitialAd();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReaderScreen(
                  surahNumber: surahNumber, initialVerse: verseNumber),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: palette.heroGradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: palette.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    lastRead == null
                        ? Icons.auto_stories_rounded
                        : Icons.play_circle_fill_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    lastRead == null
                        ? easy.tr('start_reading')
                        : easy.tr('continue_reading'),
                    style: TextStyle(
                      fontFamily: 'InterMedium',
                      fontSize: 12.5,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const Spacer(),
                  StarBadge(
                    label: '${surah.number}',
                    size: 34,
                    outlined: true,
                    fill: Colors.white.withValues(alpha: 0.5),
                    foreground: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surah.englishName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'InterBold',
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${easy.tr('verse')}#  $verseNumber  ·  ${easy.tr('para')}# ${_juzOf(surahNumber, verseNumber)}  ·  ${easy.tr('page')}# ${_pageOf(surahNumber, verseNumber)}',
                          style: TextStyle(
                            fontFamily: 'InterRegular',
                            fontSize: 12.5,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    surah.arabicName,
                    style: AppTextStyles.arabicDisplay(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  int _juzOf(int surah, int verse) => repository.verseJuz(surah, verse);

  int _pageOf(int surah, int verse) => repository.versePage(surah, verse);
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onOpenLibrary,
    required this.onOpenBookmarks,
    required this.adsController,
  });

  final ValueChanged<int> onOpenLibrary;
  final VoidCallback onOpenBookmarks;
  final MobileAdsController adsController;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final actions = <_QuickAction>[
      _QuickAction(
        icon: Icons.menu_book_rounded,
        label: easy.tr('surah'),
        color: palette.primary,
        onTap: () {
          adsController.showInterstitialAd();
          onOpenLibrary(0);
        },
      ),
      _QuickAction(
        icon: Icons.auto_stories_rounded,
        label: easy.tr('para'),
        color: palette.gold,
        onTap: () {
          adsController.showInterstitialAd();
          onOpenLibrary(1);
        },
      ),
      _QuickAction(
        icon: Icons.bookmark_rounded,
        label: easy.tr('bookmark'),
        color: palette.primary,
        onTap: () {
          adsController.showInterstitialAd();
          onOpenBookmarks;
        },
      ),
      _QuickAction(
        icon: Icons.search_rounded,
        label: easy.tr('search'),
        color: palette.gold,
        onTap: () {
          adsController.showInterstitialAd();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        },
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: actions[i]),
        ],
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      radius: 18,
      child: Column(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'InterMedium',
              fontSize: 12,
              color: palette.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// A verse that stays the same for the whole day, with its translation.
class _VerseOfTheDay extends StatelessWidget {
  const _VerseOfTheDay({required this.repository, required this.adsController});

  final QuranRepository repository;
  final MobileAdsController adsController;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Obx(() {
      final prefs = AppPrefs.to;
      final ayah = repository.verseOfTheDay(prefs.translation);
      final surah = repository.surah(ayah.surahNumber);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: easy.tr("verseOfTheDay")),
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(18),
            radius: 22,
            onTap: () {
              adsController.showInterstitialAd();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReaderScreen(
                    surahNumber: ayah.surahNumber,
                    initialVerse: ayah.verseNumber,
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ayah.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.arabic(
                      color: palette.text,
                      fontSize: prefs.arabicFontSize.value * 0.85,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  ayah.translation,
                  textDirection: prefs.translation.isRtl
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: prefs.translationFontSize.value,
                    height: 1.6,
                    color: palette.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    InfoPill(
                      label: '${surah.englishName} · ${ayah.key}',
                      icon: Icons.bookmark_border_rounded,
                    ),
                    const Spacer(),
                    Text(
                      easy.tr('readSurah'),
                      style: TextStyle(
                        fontFamily: 'InterMedium',
                        fontSize: 12.5,
                        color: palette.primary,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: palette.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
