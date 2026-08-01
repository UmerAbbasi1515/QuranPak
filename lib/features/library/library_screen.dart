import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/features/reader/reader_screen.dart';
import 'package:holy_quran/features/search/search_screen.dart';
import 'package:holy_quran/ui/widgets/app_card.dart';
import 'package:holy_quran/ui/widgets/list_tiles.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

/// Browse the Quran either by surah or by juz.
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, this.section});

  /// Owned by the root shell so other tabs can open straight to Surah or Juz.
  final ValueNotifier<int>? section;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _repository = QuranRepository.instance;
  final _searchController = TextEditingController();

  late final ValueNotifier<int> _section =
      widget.section ?? ValueNotifier<int>(0);
  late List<SurahInfo> _surahs = _repository.surahs;

  @override
  void initState() {
    super.initState();
    _section.addListener(_onSectionChanged);
  }

  @override
  void dispose() {
    _section.removeListener(_onSectionChanged);
    if (widget.section == null) _section.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSectionChanged() => setState(() {});

  void _onSearchChanged(String value) {
    setState(() => _surahs = _repository.searchSurahs(value));
  }

  void _openSurah(int surahNumber, {int? verse}) {
    Get.to(
      () => ReaderScreen(surahNumber: surahNumber, initialVerse: verse),
      preventDuplicates: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final juzs = _repository.juzs;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Text(
                    easy.tr('theQuran'),
                    style: TextStyle(
                      fontFamily: 'InterBold',
                      fontSize: 24,
                      color: palette.text,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: easy.tr('searchVerses'),
                    onPressed: () => Get.to(() => const SearchScreen()),
                    icon: Icon(
                      Icons.manage_search_rounded,
                      color: palette.text,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: SegmentedTabs(
                labels:  [easy.tr('surah'), easy.tr('para')],
                selectedIndex: _section.value,
                onChanged: (index) => _section.value = index,
              ),
            ),
            if (_section.value == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: AppSearchField(
                  controller: _searchController,
                  hintText: easy.tr('searchSurahNameOrNumber'),
                  onChanged: _onSearchChanged,
                ),
              ),
            Expanded(
              child: _section.value == 0
                  ? _surahList()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: juzs.length,
                      itemBuilder: (context, index) {
                        final juz = juzs[index];
                        return JuzTile(
                          juz: juz,
                          startSurahName:
                              _repository.surah(juz.startSurah).englishName,
                          onTap: () => _openSurah(
                            juz.startSurah,
                            verse: juz.startVerse,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _surahList() {
    if (_surahs.isEmpty) {
      return  EmptyState(
        icon: Icons.search_off_rounded,
        title: easy.tr('noSurahFound'),
        message: easy.tr('tryAnotherNameExample'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: _surahs.length,
      itemBuilder: (context, index) {
        final surah = _surahs[index];
        return SurahTile(
          surah: surah,
          onTap: () => _openSurah(surah.number),
        );
      },
    );
  }
}
