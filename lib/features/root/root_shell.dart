import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/core/theme/app_palette.dart';
import 'package:holy_quran/features/ads_controller.dart';
import 'package:holy_quran/features/bookmarks/bookmarks_screen.dart';
import 'package:holy_quran/features/home/home_screen.dart';
import 'package:holy_quran/features/library/library_screen.dart';
import 'package:holy_quran/features/settings/settings_screen.dart';

/// Holds the four main tabs and the bottom navigation bar.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  static const _homeTab = 0;
  static const _readTab = 1;
  static const _bookmarksTab = 2;

  final _librarySection = ValueNotifier<int>(0);
  int _index = _homeTab;

  @override
  void dispose() {
    _librarySection.dispose();
    super.dispose();
  }

  void _openLibrary(int section) {
    _librarySection.value = section;
    setState(() => _index = _readTab);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onOpenLibrary: _openLibrary,
            onOpenBookmarks: () {
              MobileAdsController adsController =
                  Get.put(MobileAdsController());
              adsController.showInterstitialAd();
              setState(() => _index = _bookmarksTab);
            },
          ),
          LibraryScreen(section: _librarySection),
          const BookmarksScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        index: _index,
        onChanged: (index) {
          MobileAdsController adsController = Get.put(MobileAdsController());
          adsController.showInterstitialAd();
          setState(() => _index = index);
        },
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final items = <_BarItem>[
      _BarItem(icon: Icons.home_rounded, label: easy.tr('home')),
      _BarItem(icon: Icons.menu_book_rounded, label: 'Read'),
      _BarItem(icon: Icons.bookmark_rounded, label: easy.tr('bookmark')),
      _BarItem(icon: Icons.settings_rounded, label: easy.tr('settings')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BarButton(
                    item: items[i],
                    selected: i == index,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem {
  const _BarItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _BarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = selected ? palette.primary : palette.textFaint;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? palette.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 21, color: color),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: selected ? 'InterSemibold' : 'InterMedium',
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
