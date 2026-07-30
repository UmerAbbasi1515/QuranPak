// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sizer/sizer.dart';

const List<String> _juzNames = [
  'الم',
  'سيقول السفهاء',
  'تلك الرسل',
  'لن تنالوا',
  'والمحصنات',
  'لا يحب الله',
  'وإذا سمعوا',
  'ولو أننا',
  'قال الملأ',
  'واعلموا',
  'يعتذرون',
  'وما من دابة',
  'وما أبرئ',
  'ربما',
  'سبحان الذي',
  'قال ألم',
  'اقترب للناس',
  'قد أفلح',
  'وقال الذين',
  'أمن خلق',
  'اتل ما أوحي',
  'ومن يقنت',
  'وما لي',
  'فمن أظلم',
  'إليه يرد',
  'حم',
  'قال فما خطبكم',
  'قد سمع الله',
  'تبارك الذي',
  'عم يتساءلون',
];

String _arabicNumeral(int number) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  var s = number.toString();
  for (var i = 0; i < western.length; i++) {
    s = s.replaceAll(western[i], eastern[i]);
  }
  return s;
}

class _Section {
  final int surahNumber;
  final bool hasBismillah;
  final List<InlineSpan> tokens;
  _Section({
    required this.surahNumber,
    required this.hasBismillah,
    required this.tokens,
  });
}

class _PageData {
  final List<InlineSpan> tokens;
  final bool showBanner;
  final bool showBismillah;
  final int surahNumber;
  _PageData({
    required this.tokens,
    required this.showBanner,
    required this.showBismillah,
    required this.surahNumber,
  });
}

class ReadParahScreen extends StatefulWidget {
  final int parahNumber;
  final String name;

  const ReadParahScreen({
    super.key,
    required this.parahNumber,
    required this.name,
  });

  @override
  State<ReadParahScreen> createState() => _ReadParahScreenState();
}

class _ReadParahScreenState extends State<ReadParahScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  bool _isDarkMode = false; // defaults to light mode
  bool _isAutoScrolling = false;

  List<_PageData>? _pages;
  double? _pagesComputedForWidth;

  // SINGLE SOURCE OF TRUTH for spacing — used both when *measuring* how
  // much text fits on a page (_computePages) and when *rendering* it
  // (build). These must always match, or pagination and layout drift
  // apart and text spills past the decorative frame.
  static const EdgeInsets _kOuterPadding = EdgeInsets.fromLTRB(12, 12, 28, 12);
  static const EdgeInsets _kContentPadding =
      EdgeInsets.only(top: 70, bottom: 40, left: 20, right: 20);

  // Small safety buffer so tiny font-metric rounding differences between
  // TextPainter's estimate and the real Text.rich render never cause a
  // last-minute overflow. Better to leave a sliver of empty space at the
  // bottom of a page than to overflow it.
  static const double _kSafetyBuffer = 12;

  static const double _kBannerBlockHeight = 86;
  static const double _kBismillahBlockHeight = 58;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalPages => _pages?.length ?? 1;
  bool get _isFirstPage => _currentPageIndex == 0;
  bool get _isLastPage => _currentPageIndex >= _totalPages - 1;

  void _goToPrevious() {
    if (!_isFirstPage) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    if (!_isLastPage) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleAutoScroll() {
    setState(() => _isAutoScrolling = !_isAutoScrolling);
    if (_isAutoScrolling) {
      _autoScrollLoop();
    }
  }

  Future<void> _autoScrollLoop() async {
    while (_isAutoScrolling && !_isLastPage && mounted) {
      await Future.delayed(const Duration(seconds: 8));
      if (!_isAutoScrolling || !mounted) break;
      _goToNext();
    }
    if (mounted) setState(() => _isAutoScrolling = false);
  }

  void _toggleDarkMode() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  InlineSpan _ayahMarkerSpan(int ayah, Color markerColor, double baseFontSize) {
    String marker;
    try {
      marker = quran.getVerseEndSymbol(ayah, arabicNumeral: true);
    } catch (_) {
      marker = '﴿${_arabicNumeral(ayah)}﴾';
    }
    return TextSpan(
      text: ' $marker',
      style: TextStyle(
        color: markerColor,
        fontWeight: FontWeight.bold,
        fontSize: baseFontSize * 0.75,
      ),
    );
  }

  List<_Section> _buildSections(TextStyle verseStyle, Color markerColor) {
    final sections = <_Section>[];

    for (int surah = 1; surah <= 114; surah++) {
      final verseCount = quran.getVerseCount(surah);
      List<InlineSpan>? tokens;
      var hasBismillah = false;
      var started = false;

      for (int ayah = 1; ayah <= verseCount; ayah++) {
        if (quran.getJuzNumber(surah, ayah) != widget.parahNumber) {
          if (started) break;
          continue;
        }

        if (!started) {
          started = true;
          tokens = [];
          hasBismillah = ayah == 1 && surah != 9;
        }

        final text = quran.getVerse(surah, ayah, verseEndSymbol: false).trim();
        for (final word in text.split(RegExp(r'\s+'))) {
          tokens!.add(TextSpan(text: '$word ', style: verseStyle));
        }
        tokens!.add(_ayahMarkerSpan(ayah, markerColor, verseStyle.fontSize!));
        tokens.add(const TextSpan(text: '\n'));
      }

      if (tokens != null && tokens.isNotEmpty) {
        sections.add(_Section(
          surahNumber: surah,
          hasBismillah: hasBismillah,
          tokens: tokens,
        ));
      }
    }

    return sections;
  }

  List<_PageData> _computePages({
    required double maxWidth,
    required double maxHeight,
    required TextStyle textStyle,
    required Color markerColor,
  }) {
    // These MUST mirror exactly what's applied in build() below: the
    // Padding around the Stack (_kOuterPadding) plus the padding inside
    // the SingleChildScrollView (_kContentPadding).
    final horizontalReserved =
        _kOuterPadding.left + _kOuterPadding.right +
        _kContentPadding.left + _kContentPadding.right;
    final verticalReserved =
        _kOuterPadding.top + _kOuterPadding.bottom +
        _kContentPadding.top + _kContentPadding.bottom +
        _kSafetyBuffer;

    final availableWidth = maxWidth - horizontalReserved;
    final fullAvailableHeight = maxHeight - verticalReserved;

    final sections = _buildSections(textStyle, markerColor);
    final pages = <_PageData>[];

    for (final section in sections) {
      var isFirstPageOfSection = true;
      var currentTokens = <InlineSpan>[];

      double heightBudget() {
        if (!isFirstPageOfSection) return fullAvailableHeight;
        var budget = fullAvailableHeight - _kBannerBlockHeight;
        if (section.hasBismillah) budget -= _kBismillahBlockHeight;
        return budget;
      }

      void flushPage() {
        pages.add(_PageData(
          tokens: currentTokens,
          showBanner: isFirstPageOfSection,
          showBismillah: isFirstPageOfSection && section.hasBismillah,
          surahNumber: section.surahNumber,
        ));
        currentTokens = [];
        isFirstPageOfSection = false;
      }

      for (final token in section.tokens) {
        final candidate = [...currentTokens, token];
        final painter = TextPainter(
          text: TextSpan(children: candidate),
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
        )..layout(maxWidth: availableWidth);

        final overflow =
            currentTokens.isNotEmpty && painter.height > heightBudget();

        if (overflow) {
          flushPage();
          currentTokens = [token];
        } else {
          currentTokens = candidate;
        }
      }

      if (currentTokens.isNotEmpty) flushPage();
    }

    return pages;
  }

  void _ensurePagesComputed(
    double maxWidth,
    double maxHeight,
    TextStyle textStyle,
    Color markerColor,
  ) {
    if (_pages != null && _pagesComputedForWidth == maxWidth) return;

    final computed = _computePages(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      textStyle: textStyle,
      markerColor: markerColor,
    );

    _pages = computed;
    _pagesComputedForWidth = maxWidth;

    if (_currentPageIndex >= computed.length) {
      _currentPageIndex = computed.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF3B0E0E) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : Colors.black87;
    final goldColor = const Color(0xFFD4AF37);

    final verseStyle = GoogleFonts.amiriQuran(
      fontSize: 20.sp,
      height: 1.0,
      color: textColor,
    );

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _TopInfoBar(
                  dark: _isDarkMode,
                  gold: goldColor,
                  surahName: _pages != null && _pages!.isNotEmpty
                      ? quran.getSurahNameArabic(
                          _pages![_currentPageIndex].surahNumber)
                      : '',
                  onBack: () => Navigator.of(context).maybePop(),
                  onToggleDarkMode: _toggleDarkMode,
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      _ensurePagesComputed(
                        constraints.maxWidth,
                        constraints.maxHeight,
                        verseStyle,
                        goldColor,
                      );

                      final pages = _pages!;

                      return PageView.builder(
                        controller: _pageController,
                        itemCount: pages.length,
                        onPageChanged: (index) {
                          setState(() => _currentPageIndex = index);
                        },
                        itemBuilder: (context, pageIndex) {
                          final page = pages[pageIndex];

                          return Padding(
                            // Uses the SAME constant as _computePages.
                            padding: _kOuterPadding,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: SvgPicture.asset(
                                    AppImagesPath.testing,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SingleChildScrollView(
                                  // Uses the SAME constant as _computePages.
                                  padding: _kContentPadding,
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (page.showBanner)
                                        _SurahBanner(
                                          surahNumber: page.surahNumber,
                                          dark: _isDarkMode,
                                          gold: goldColor,
                                        ),
                                      if (page.showBismillah)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            quran.basmala,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.amiriQuran(
                                              fontSize: 19.sp,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text.rich(
                                          TextSpan(children: page.tokens),
                                          textDirection: TextDirection.rtl,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 90,
              child: _SideJuzTab(
                gold: goldColor,
                dark: _isDarkMode,
                juzNumber: widget.parahNumber,
                juzName: _juzNames[widget.parahNumber - 1],
                pageLabel:
                    '${_arabicNumeral(_currentPageIndex + 1)}/${_arabicNumeral(_totalPages)}',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _BarButton(
              icon: Icons.arrow_back,
              label: 'Previous',
              dark: _isDarkMode,
              enabled: !_isFirstPage,
              onTap: _goToPrevious,
            ),
            _BarButton(
              icon: _isAutoScrolling ? Icons.pause : Icons.play_arrow,
              label: 'Autoscroll',
              dark: _isDarkMode,
              active: _isAutoScrolling,
              enabled: !_isLastPage || _isAutoScrolling,
              onTap: _toggleAutoScroll,
            ),
            _BarButton(
              icon: Icons.arrow_forward,
              label: 'Next',
              dark: _isDarkMode,
              enabled: !_isLastPage,
              onTap: _goToNext,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopInfoBar extends StatelessWidget {
  final bool dark;
  final Color gold;
  final String surahName;
  final VoidCallback onBack;
  final VoidCallback onToggleDarkMode;

  const _TopInfoBar({
    required this.dark,
    required this.gold,
    required this.surahName,
    required this.onBack,
    required this.onToggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: gold.withOpacity(0.5))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 18, color: textColor),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              surahName,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiriQuran(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              dark ? Icons.light_mode : Icons.dark_mode,
              size: 18,
              color: textColor,
            ),
            onPressed: onToggleDarkMode,
          ),
        ],
      ),
    );
  }
}

class _SideJuzTab extends StatelessWidget {
  final Color gold;
  final bool dark;
  final int juzNumber;
  final String juzName;
  final String pageLabel;

  const _SideJuzTab({
    required this.gold,
    required this.dark,
    required this.juzNumber,
    required this.juzName,
    required this.pageLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: gold,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(-1, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'جزء',
            style: GoogleFonts.amiriQuran(
              fontSize: 10.sp,
              color: const Color(0xFF3B0E0E),
            ),
          ),
          Text(
            _arabicNumeral(juzNumber),
            style: GoogleFonts.amiriQuran(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3B0E0E),
            ),
          ),
          const SizedBox(height: 4),
          Container(width: 18, height: 1, color: const Color(0xFF3B0E0E)),
          const SizedBox(height: 4),
          Text(
            juzName,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiriQuran(
              fontSize: 9.sp,
              color: const Color(0xFF3B0E0E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            pageLabel,
            style: TextStyle(fontSize: 9.sp, color: const Color(0xFF3B0E0E)),
          ),
        ],
      ),
    );
  }
}

class _SurahBanner extends StatelessWidget {
  final int surahNumber;
  final bool dark;
  final Color gold;

  const _SurahBanner({
    required this.surahNumber,
    required this.dark,
    required this.gold,
  });

  @override
  Widget build(BuildContext context) {
    final place = quran.getPlaceOfRevelation(surahNumber);
    final placeAr = place.toLowerCase().contains('makk') ? 'مكية' : 'مدنية';
    final verseCount = quran.getVerseCount(surahNumber);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        border: Border.all(color: gold, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'آياتها ${_arabicNumeral(verseCount)}',
              textAlign: TextAlign.right,
              style: GoogleFonts.amiriQuran(fontSize: 11.sp, color: gold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              quran.getSurahNameArabic(surahNumber),
              textAlign: TextAlign.center,
              style: GoogleFonts.amiriQuran(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: gold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              placeAr,
              textAlign: TextAlign.left,
              style: GoogleFonts.amiriQuran(fontSize: 11.sp, color: gold),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;
  final bool active;
  final bool enabled;
  final VoidCallback onTap;

  const _BarButton({
    required this.icon,
    required this.label,
    required this.dark,
    required this.onTap,
    this.active = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = const Color(0xFFD4AF37);
    final disabledColor = Colors.grey.shade600;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: !enabled ? disabledColor : goldColor,
            radius: 18,
            child: Icon(
              icon,
              color: !enabled ? Colors.white38 : const Color(0xFF3B0E0E),
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: !enabled
                  ? Colors.white24
                  : (dark ? Colors.white70 : Colors.black54),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}