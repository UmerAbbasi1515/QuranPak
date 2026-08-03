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
import 'package:easy_localization/easy_localization.dart' as easy;

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
  RxBool temp = false.obs;

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReaderScreen(
          surahNumber: ayah.surahNumber,
          initialVerse: ayah.verseNumber,
        ),
      ),
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
              hintText: easy.tr('searchSurahsOrWords'),
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
      return EmptyState(
        icon: Icons.search_rounded,
        title: easy.tr('searchTheQuran'),
        message: easy.tr('searchTheQuranDescription'),
      );
    }

    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_surahHits.isEmpty && _verseHits.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_rounded,
        title: '${easy.tr('noMatchesFor')} "$_query"',
        message: easy.tr('verseSearchNote'),
      );
    }

    return Obx(
      () => temp.value == true
          ? SizedBox()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                if (_surahHits.isNotEmpty) ...[
                  SectionHeader(title: easy.tr('Surah')),
                  const SizedBox(height: 8),
                  for (final surah in _surahHits)
                    SurahTile(
                      surah: surah,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReaderScreen(
                              surahNumber: surah.number,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                ],
                if (_verseHits.isNotEmpty) ...[
                  SectionHeader(
                    title: _verseHits.length >= _verseResultLimit
                        ? '${easy.tr('verses')} (${easy.tr('first')} $_verseResultLimit)'
                        : '${easy.tr('verses')} (${_verseHits.length})',
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
