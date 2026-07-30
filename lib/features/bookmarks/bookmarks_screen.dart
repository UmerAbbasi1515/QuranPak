import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/data/quran_repository.dart';
import 'package:holy_quran/core/services/app_prefs.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/features/reader/reader_screen.dart';
import 'package:holy_quran/ui/widgets/app_card.dart';
import 'package:holy_quran/ui/widgets/ayah_view.dart';

/// Every verse the user has saved, newest first.
class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final repository = QuranRepository.instance;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final prefs = AppPrefs.to;
          final option = prefs.translation;
          final keys = prefs.bookmarks;

          final ayahs = <Ayah>[];
          for (final key in keys) {
            final parts = key.split(':');
            if (parts.length != 2) continue;
            final surah = int.tryParse(parts[0]);
            final verse = int.tryParse(parts[1]);
            if (surah == null || verse == null) continue;
            ayahs.add(repository.verse(surah, verse, option));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
                child: Row(
                  children: [
                    Text(
                      easy.tr('bookmark'),
                      style: TextStyle(
                        fontFamily: 'InterBold',
                        fontSize: 24,
                        color: palette.text,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (ayahs.isNotEmpty)
                      InfoPill(label: '${ayahs.length} saved'),
                    const Spacer(),
                    if (ayahs.isNotEmpty)
                      TextButton(
                        onPressed: () => _confirmClear(context),
                        style: TextButton.styleFrom(
                          foregroundColor: palette.textMuted,
                        ),
                        child: const Text(
                          'Clear all',
                          style: TextStyle(
                            fontFamily: 'InterMedium',
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ayahs.isEmpty
                    ? const EmptyState(
                        icon: Icons.bookmark_border_rounded,
                        title: 'No bookmarks yet',
                        message:
                            'Tap the bookmark icon on any verse while reading '
                            'and it will show up here.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: ayahs.length,
                        itemBuilder: (context, index) {
                          final ayah = ayahs[index];
                          return AyahView(
                            ayah: ayah,
                            arabicFontSize: prefs.arabicFontSize.value,
                            translationFontSize:
                                prefs.translationFontSize.value,
                            showTranslation: prefs.showTranslation.value,
                            translationIsRtl: option.isRtl,
                            isBookmarked: true,
                            subtitle: repository
                                .surah(ayah.surahNumber)
                                .englishName,
                            onBookmark: () => prefs.toggleBookmark(ayah.key),
                            onTap: () => Get.to(
                              () => ReaderScreen(
                                surahNumber: ayah.surahNumber,
                                initialVerse: ayah.verseNumber,
                              ),
                              preventDuplicates: false,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context) async {
    final palette = context.palette;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        title: Text(
          'Remove all bookmarks?',
          style: TextStyle(
            fontFamily: 'InterSemibold',
            fontSize: 17,
            color: palette.text,
          ),
        ),
        content: Text(
          'This cannot be undone.',
          style: TextStyle(
            fontFamily: 'InterRegular',
            fontSize: 14,
            color: palette.textMuted,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(easy.tr('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove all'),
          ),
        ],
      ),
    );

    if (confirmed == true) AppPrefs.to.clearBookmarks();
  }
}
