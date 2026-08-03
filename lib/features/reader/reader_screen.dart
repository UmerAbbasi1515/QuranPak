import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/features/ads_controller.dart';
import 'package:holy_quran/features/reader/widgets/reader_settings_sheet.dart';
import 'package:holy_quran/features/reader/widgets/surah_header_card.dart';
import 'package:holy_quran/ui/widgets/ayah_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

/// Verse-by-verse reader: Arabic with the selected translation underneath,
/// resuming wherever the reader was last left.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
    required this.surahNumber,
    this.initialVerse,
  });

  final int surahNumber;

  /// Verse to open at — used by "Continue reading", bookmarks and search.
  final int? initialVerse;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _repository = QuranRepository.instance;
  final _itemScrollController = ItemScrollController();
  final _positionsListener = ItemPositionsListener.create();

  late final SurahInfo _surah;
  late final ValueNotifier<int> _currentVerse;

  /// List index to open on: 0 is the surah header, index N is verse N.
  late final int _initialIndex;

  int? _highlightedVerse;
  Timer? _saveDebounce;
  Timer? _highlightTimer;
  MobileAdsController adsController = Get.put(MobileAdsController());

  @override
  void initState() {
    super.initState();
    adsController.loadBannerAd();
    adsController.loadInterstitialAd();
    _surah = _repository.surah(widget.surahNumber);

    final startVerse = (widget.initialVerse ?? 1).clamp(1, _surah.verseCount);
    _currentVerse = ValueNotifier<int>(startVerse);

    // Opening a surah from the start shows its header plate first.
    _initialIndex = widget.initialVerse == null ? 0 : startVerse;

    if (widget.initialVerse != null && widget.initialVerse! > 1) {
      _highlightedVerse = startVerse;
      _highlightTimer = Timer(const Duration(milliseconds: 2600), () {
        if (mounted) setState(() => _highlightedVerse = null);
      });
    }

    _positionsListener.itemPositions.addListener(_onScroll);

    // Deferred: writing straight away would mark listening widgets dirty while
    // this route is still being built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppPrefs.to.saveLastRead(widget.surahNumber, startVerse);
    });
  }

  @override
  void dispose() {
    _positionsListener.itemPositions.removeListener(_onScroll);
    _saveDebounce?.cancel();
    _highlightTimer?.cancel();
    _currentVerse.dispose();
    adsController.bannerAd?.dispose();
    super.dispose();
  }

  /// Index 0 is the surah header, so list index N holds verse N.
  void _onScroll() {
    final positions = _positionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Ignore an item that is only a sliver above the top edge, otherwise the
    // counter reads one verse behind what is actually being read.
    final visible =
        positions.where((position) => position.itemTrailingEdge > 0.15);
    final firstVisible = (visible.isEmpty ? positions : visible)
        .map((position) => position.index)
        .reduce((a, b) => a < b ? a : b);

    final verse = firstVisible.clamp(1, _surah.verseCount);
    if (verse == _currentVerse.value) return;

    _currentVerse.value = verse;

    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 700), () {
      AppPrefs.to.saveLastRead(widget.surahNumber, verse);
    });
  }

  void _jumpToVerse(int verse) {
    final target = verse.clamp(1, _surah.verseCount);
    _itemScrollController.scrollTo(
      index: target,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: 0.06,
    );
    _highlightTimer?.cancel();
    setState(() => _highlightedVerse = target);
    _highlightTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) setState(() => _highlightedVerse = null);
    });
  }

  void _copyAyah(Ayah ayah) {
    final option = AppPrefs.to.translation;
    final buffer = StringBuffer()
      ..writeln(ayah.arabic)
      ..writeln()
      ..writeln(ayah.translation)
      ..write('— ${_surah.englishName} ${ayah.key} (${option.nativeLabel})');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    _showSnack('${easy.tr('verse')} ${ayah.key} ${easy.tr('copied')} ');
  }

  void _toggleBookmark(Ayah ayah) {
    final added = AppPrefs.to.toggleBookmark(ayah.key);
    _showSnack(added
        ? '${easy.tr('bookmarked')} ${ayah.key}'
        : easy.tr('bookmarkRemoved'));
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
  }

  Future<void> _openJumpSheet() async {
    final palette = context.palette;
    final controller = TextEditingController();

    final verse = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: SizedBox(height: 8)),
            Text(
              easy.tr('goToVerse'),
              style: TextStyle(
                fontFamily: 'InterSemibold',
                fontSize: 17,
                color: palette.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_surah.englishName} ${easy.tr('has')} ${_surah.verseCount} ${easy.tr('verses')}',
              style: TextStyle(
                fontFamily: 'InterRegular',
                fontSize: 13,
                color: palette.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontFamily: 'InterMedium',
                fontSize: 16,
                color: palette.text,
              ),
              decoration: InputDecoration(
                hintText: easy.tr('verseNumber'),
                filled: true,
                fillColor: palette.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) =>
                  Navigator.of(context).pop(int.tryParse(value)),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(int.tryParse(controller.text)),
              child: const Text('Go'),
            ),
          ],
        ),
      ),
    );

    controller.dispose();
    if (verse != null) _jumpToVerse(verse);
  }

  void _openSurah(int surahNumber) {
    Get.off(
      () => ReaderScreen(surahNumber: surahNumber),
      preventDuplicates: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _surah.englishName,
                style: TextStyle(
                  fontFamily: 'InterSemibold',
                  fontSize: 16,
                  color: palette.text,
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _currentVerse,
                builder: (context, verse, _) => Text(
                  '${easy.tr('verse')} $verse ${easy.tr('of')}  ${_surah.verseCount}',
                  style: TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 11.5,
                    color: palette.textMuted,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: easy.tr('goToVerse'),
              icon: const Icon(Icons.numbers_rounded),
              onPressed: _openJumpSheet,
            ),
            IconButton(
              tooltip: easy.tr('readingSettings'),
              icon: const Icon(Icons.tune_rounded),
              onPressed: () => showReaderSettingsSheet(context),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: Obx(() {
          final prefs = AppPrefs.to;
          final option = prefs.translation;
          final ayahs = _repository.versesOfSurah(widget.surahNumber, option);

          // Referenced so Obx rebuilds the list when a bookmark is toggled.
          final bookmarks = prefs.bookmarks;

          return ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _positionsListener,
            initialScrollIndex: _initialIndex,
            initialAlignment: _initialIndex == 0 ? 0 : 0.06,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: ayahs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SurahHeaderCard(
                  surah: _surah,
                  arabicFontSize: prefs.arabicFontSize.value,
                );
              }

              final ayah = ayahs[index - 1];
              return AyahView(
                ayah: ayah,
                arabicFontSize: prefs.arabicFontSize.value,
                translationFontSize: prefs.translationFontSize.value,
                showTranslation: prefs.showTranslation.value,
                translationIsRtl: option.isRtl,
                isBookmarked: bookmarks.contains(ayah.key),
                highlighted: _highlightedVerse == ayah.verseNumber,
                onBookmark: () => _toggleBookmark(ayah),
                onCopy: () => _copyAyah(ayah),
              );
            },
          );
        }),
        bottomNavigationBar: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (adsController.isBannerLoaded.value &&
                  adsController.bannerAd != null)
                SizedBox(
                  width: adsController.bannerAd!.size.width.toDouble(),
                  height: adsController.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: adsController.bannerAd!),
                ),
              _ReaderBottomBar(
                surah: _surah,
                currentVerse: _currentVerse,
                onPrevious: widget.surahNumber > 1
                    ? () => _openSurah(widget.surahNumber - 1)
                    : null,
                onNext: widget.surahNumber < QuranRepository.surahCount
                    ? () => _openSurah(widget.surahNumber + 1)
                    : null,
              ),
            ],
          ),
        ));
  }
}

class _ReaderBottomBar extends StatelessWidget {
  const _ReaderBottomBar({
    required this.surah,
    required this.currentVerse,
    this.onPrevious,
    this.onNext,
  });

  final SurahInfo surah;
  final ValueNotifier<int> currentVerse;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              _NavButton(
                icon: Icons.chevron_left_rounded,
                label: easy.tr('previous'),
                onTap: onPrevious,
              ),
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: currentVerse,
                  builder: (context, verse, _) {
                    final progress = verse / surah.verseCount;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(progress * 100).clamp(0, 100).round()}% ${easy.tr('of')} ${surah.englishName}',
                          style: TextStyle(
                            fontFamily: 'InterMedium',
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 4,
                            backgroundColor: palette.surfaceAlt,
                            valueColor: AlwaysStoppedAnimation(palette.primary),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _NavButton(
                icon: Icons.chevron_right_rounded,
                label: easy.tr('next'),
                onTap: onNext,
                trailingIcon: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailingIcon = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final enabled = onTap != null;
    final color = enabled ? palette.primary : palette.textFaint;

    final children = <Widget>[
      Icon(icon, size: 20, color: color),
      Text(
        label,
        style: TextStyle(
          fontFamily: 'InterMedium',
          fontSize: 12.5,
          color: color,
        ),
      ),
    ];

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: trailingIcon ? children.reversed.toList() : children,
      ),
    );
  }
}
