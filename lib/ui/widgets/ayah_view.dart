import 'package:flutter/material.dart';
import 'package:holy_quran/core/data/quran_models.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/core/theme/app_theme.dart';

/// One verse: Arabic on top, translation underneath, with per-verse actions.
///
/// Used by the reader, the bookmarks screen and search results.
class AyahView extends StatelessWidget {
  const AyahView({
    super.key,
    required this.ayah,
    required this.arabicFontSize,
    required this.translationFontSize,
    required this.showTranslation,
    required this.isBookmarked,
    required this.translationIsRtl,
    this.onBookmark,
    this.onCopy,
    this.onTap,
    this.subtitle,
    this.highlighted = false,
  });

  final Ayah ayah;
  final double arabicFontSize;
  final double translationFontSize;
  final bool showTranslation;
  final bool isBookmarked;
  final bool translationIsRtl;
  final VoidCallback? onBookmark;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;

  /// Extra context line, e.g. the surah name in bookmarks and search results.
  final String? subtitle;

  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: highlighted ? palette.primarySoft : palette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlighted ? palette.primary : palette.border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(context, palette),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ayah.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.arabic(
                      color: palette.text,
                      fontSize: arabicFontSize,
                    ),
                  ),
                ),
                if (showTranslation && ayah.translation.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    ayah.translation,
                    textDirection:
                        translationIsRtl ? TextDirection.rtl : TextDirection.ltr,
                    textAlign:
                        translationIsRtl ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'InterRegular',
                      fontSize: translationFontSize,
                      height: 1.65,
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, AppPalette palette) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: palette.primarySoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            ayah.key,
            style: TextStyle(
              fontFamily: 'InterSemibold',
              fontSize: 11.5,
              color: palette.primary,
            ),
          ),
        ),
        if (ayah.isSajdah) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: palette.goldSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Sajdah',
              style: TextStyle(
                fontFamily: 'InterSemibold',
                fontSize: 11.5,
                color: palette.gold,
              ),
            ),
          ),
        ],
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'InterMedium',
                fontSize: 12,
                color: palette.textFaint,
              ),
            ),
          ),
        ] else
          const Spacer(),
        if (onCopy != null)
          _ActionIcon(
            icon: Icons.copy_rounded,
            tooltip: 'Copy verse',
            onTap: onCopy!,
          ),
        if (onBookmark != null)
          _ActionIcon(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark verse',
            color: isBookmarked ? palette.gold : null,
            onTap: onBookmark!,
          ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Icon(icon, size: 19, color: color ?? palette.textFaint),
        ),
      ),
    );
  }
}
