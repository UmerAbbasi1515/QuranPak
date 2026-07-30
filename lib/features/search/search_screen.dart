import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/features/reader/reader_screen.dart';
import 'package:holy_quran/ui/widgets/app_card.dart';
import 'package:holy_quran/ui/widgets/ayah_view.dart';
import 'package:holy_quran/ui/widgets/list_tiles.dart';

/// Searches surah names and the full text of the selected translation.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// Verse hits are capped so a common word doesn't build thousands of rows.
const int _verseResultLimit = 60;

class _SearchScreenState extends State<SearchScreen> {
  final _repository = QuranRepository.instance;
  final _controller = TextEditingController();

  Timer? _debounce;
  String _query = '';
  List<SurahInfo> _surahHits = const [];
  List<Ayah> _verseHits = const [];
  bool _searching = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    if (value.trim().isEmpty) {
      setState(() {
        _query = '';
        _surahHits = const [];
        _verseHits = const [];
        _searching = false;
      });
      return;
    }

    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 350), () => _run(value));
  }

  void _run(String value) {
    final option = AppPrefs.to.translation;
    final surahHits = _repository.searchSurahs(value).take(6).toList();
    final verseHits = _repository.searchTranslation(
      value,
      option,
      limit: _verseResultLimit,
    );

    if (!mounted) return;
    setState(() {
      _query = value.trim();
      _surahHits = surahHits;
      _verseHits = verseHits;
      _searching = false;
    });
  }

  void _openVerse(Ayah ayah) {
    Get.to(
      () => ReaderScreen(
        surahNumber: ayah.surahNumber,
        initialVerse: ayah.verseNumber,
      ),
      preventDuplicates: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final prefs = AppPrefs.to;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: AppSearchField(
              controller: _controller,
              hintText: 'Search surahs or words in the translation',
              autofocus: true,
              onChanged: _onChanged,
            ),
          ),
          Expanded(child: _results(context, prefs)),
        ],
      ),
    );
  }

  Widget _results(BuildContext context, AppPrefs prefs) {
    if (_query.isEmpty && !_searching) {
      return const EmptyState(
        icon: Icons.search_rounded,
        title: 'Search the Quran',
        message:
            'Look up a surah by name, or find every verse containing a word — '
            'for example "mercy", "patience" or "light".',
      );
    }

    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_surahHits.isEmpty && _verseHits.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No matches for "$_query"',
        message:
            'Verse search looks inside the translation you have selected in '
            'settings.',
      );
    }

    return Obx(
      () => ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          if (_surahHits.isNotEmpty) ...[
            const SectionHeader(title: 'Surahs'),
            const SizedBox(height: 8),
            for (final surah in _surahHits)
              SurahTile(
                surah: surah,
                onTap: () => Get.to(
                  () => ReaderScreen(surahNumber: surah.number),
                  preventDuplicates: false,
                ),
              ),
            const SizedBox(height: 8),
          ],
          if (_verseHits.isNotEmpty) ...[
            SectionHeader(
              title: _verseHits.length >= _verseResultLimit
                  ? 'Verses (first $_verseResultLimit)'
                  : 'Verses (${_verseHits.length})',
            ),
            const SizedBox(height: 8),
            for (final ayah in _verseHits)
              AyahView(
                ayah: ayah,
                arabicFontSize: prefs.arabicFontSize.value,
                translationFontSize: prefs.translationFontSize.value,
                showTranslation: true,
                translationIsRtl: prefs.translation.isRtl,
                isBookmarked: prefs.bookmarks.contains(ayah.key),
                subtitle: _repository.surah(ayah.surahNumber).englishName,
                onTap: () => _openVerse(ayah),
                onBookmark: () => prefs.toggleBookmark(ayah.key),
              ),
          ],
        ],
      ),
    );
  }
}
