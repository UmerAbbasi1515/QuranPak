// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sizer/sizer.dart';

class ReadSurahScreen extends StatefulWidget {
  final int surahNumber;

  const ReadSurahScreen({
    super.key,
    required this.surahNumber,
  });

  @override
  State<ReadSurahScreen> createState() => _ReadSurahScreenState();
}

class _ReadSurahScreenState extends State<ReadSurahScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  late int _totalVerses;
  bool _isDarkMode = true;
  bool _isAutoScrolling = false;

  // each page is now a list of ready-to-render InlineSpans (word-level split)
  List<List<InlineSpan>>? _pages;
  double? _pagesComputedForWidth;

  @override
  void initState() {
    super.initState();
    _totalVerses = quran.getVerseCount(widget.surahNumber);
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

  /// Builds the small circular ayah-number marker as an inline widget span.
  InlineSpan _markerSpan(
    int verseNumber,
    Color markerColor,
    Color markerTextColor,
  ) {
    return TextSpan(
      text: ' ﴿$verseNumber﴾ ',
      style: TextStyle(
        color: markerColor,
        fontWeight: FontWeight.bold,
        fontSize: 14.sp,
      ),
    );
  }

  /// Flattens the entire surah into word-level tokens (each word is its own
  /// span) so a verse CAN be split across two pages if it doesn't fit —
  /// the marker for that verse is only appended after its last word.
  List<InlineSpan> _buildAllTokens(
    TextStyle textStyle,
    Color markerColor,
    Color markerTextColor,
  ) {
    final tokens = <InlineSpan>[];

    for (int v = 1; v <= _totalVerses; v++) {
      final text =
          quran.getVerse(widget.surahNumber, v, verseEndSymbol: false).trim();
      final words = text.split(RegExp(r'\s+'));

      for (int i = 0; i < words.length; i++) {
        tokens.add(TextSpan(text: '${words[i]} ', style: textStyle));
      }

      // verse-number marker attaches right after this verse's last word
      tokens.add(_markerSpan(v, markerColor, markerTextColor));
      tokens.add(const TextSpan(text: ' '));
    }

    return tokens;
  }

  /// Greedily fills each page word-by-word (instead of verse-by-verse),
  /// so long verses can split across pages — remaining words continue
  /// on the next page, exactly where they left off.
  List<List<InlineSpan>> _computePages({
    required double maxWidth,
    required double maxHeight,
    required TextStyle textStyle,
    required Color markerColor,
    required Color markerTextColor,
  }) {
    const outerPadding = 24.0; // outer SingleChildScrollView padding (12 * 2)
    const borderContainerPadding = 40.0; // inner Container padding (20 * 2)
    const borderWidth = 3.0; // border width (1.5 * 2)
    const verticalPadding = outerPadding + borderContainerPadding + borderWidth;

    final availableWidth =
        maxWidth - outerPadding - borderContainerPadding - borderWidth;
    final availableHeight = maxHeight - verticalPadding;

    final allTokens = _buildAllTokens(textStyle, markerColor, markerTextColor);

    final pages = <List<InlineSpan>>[];
    var currentPageTokens = <InlineSpan>[];

    for (final token in allTokens) {
      final candidateTokens = [...currentPageTokens, token];

      final painter = TextPainter(
        text: TextSpan(children: candidateTokens),
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.justify,
      )..layout(maxWidth: availableWidth);

      final wouldOverflow =
          currentPageTokens.isNotEmpty && painter.height > availableHeight;

      if (wouldOverflow) {
        pages.add(currentPageTokens);
        currentPageTokens = [token];
      } else {
        currentPageTokens = candidateTokens;
      }
    }

    if (currentPageTokens.isNotEmpty) {
      pages.add(currentPageTokens);
    }

    return pages;
  }

  void _ensurePagesComputed(
    double maxWidth,
    double maxHeight,
    TextStyle textStyle,
    Color markerColor,
    Color markerTextColor,
  ) {
    if (_pages != null && _pagesComputedForWidth == maxWidth) return;

    final computed = _computePages(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      textStyle: textStyle,
      markerColor: markerColor,
      markerTextColor: markerTextColor,
    );

    _pages = computed;
    _pagesComputedForWidth = maxWidth;

    if (_currentPageIndex >= computed.length) {
      _currentPageIndex = computed.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        _isDarkMode ? const Color(0xFF3B0E0E) : const Color(0xFFF5F0E6);
    final textColor = _isDarkMode ? Colors.white : Colors.black87;
    final markerColor = const Color(0xFFD4AF37);
    final markerTextColor = _isDarkMode ? Colors.white : Colors.black87;
    final surahName = quran.getSurahNameArabic(widget.surahNumber);
    final surahNameEn = quran.getSurahName(widget.surahNumber);

    final verseStyle = GoogleFonts.amiriQuran(
      fontSize: 20.sp,
      height: 1.9,
      color: textColor,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text('$surahNameEn ($surahName)'),
        foregroundColor: textColor,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          _ensurePagesComputed(
            constraints.maxWidth,
            constraints.maxHeight,
            verseStyle,
            markerColor,
            markerTextColor,
          );

          final pages = _pages!;

          return PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() => _currentPageIndex = index);
            },
            itemBuilder: (context, pageIndex) {
              final spans = pages[pageIndex];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text.rich(
                    TextSpan(children: spans),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                  ),
                ),
              );
            },
          );
        },
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
              icon: _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              label: _isDarkMode ? 'Light Mode' : 'Dark Mode',
              dark: _isDarkMode,
              active: _isDarkMode,
              onTap: _toggleDarkMode,
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
            backgroundColor: !enabled
                ? disabledColor
                : (active ? goldColor : goldColor),
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
