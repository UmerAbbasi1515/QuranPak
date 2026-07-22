// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holy_quran/constant/assets_path.dart';
import 'package:holy_quran/constant/style/app_colors.dart';
import 'package:holy_quran/quran_dashboard/home/home_screen.dart';
import 'package:holy_quran/quran_dashboard/quran_dashboard_controller.dart';
import 'package:holy_quran/widgets/bottom_nav_bar.dart';

class QuransDashboardTabs extends StatefulWidget {
  final int? initialIndex;
  const QuransDashboardTabs({
    super.key,
    this.initialIndex = 0,
  });

  @override
  QuransDashboardTabsState createState() => QuransDashboardTabsState();
}

class QuransDashboardTabsState extends State<QuransDashboardTabs> {
  // ignore: unused_field
  final QuranDashboardTabsController _dashboardTabsController =
      Get.put(QuranDashboardTabsController());

  int? _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  List<Widget>? _buildScreens;

  @override
  Widget build(BuildContext context) {
    _buildScreens = [
      const HomeScreen(),
      Container(
        color: Colors.pink,
        child: const Text("BookMark"),
      ),
      Container(
        color: Colors.amber,
        child: const Text("Daily Dua's"),
      ),
      Container(
        color: Colors.blue,
        child: const Text("Setting"),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.backgroundColor),
              child: Column(
                children: [
                  Expanded(
                    child: _buildScreens![_selectedIndex!],
                  ),
                  CustomNavBar(
                    items: [
                      NavBarItem(
                        icon: _selectedIndex == 0
                            ? AppImagesPath.home
                            : AppImagesPath.home,
                        title: 'Home',
                        onTap: (pos) {
                          setState(() {
                            _selectedIndex = pos;
                          });
                        },
                        position: 0,
                      ),
                      NavBarItem(
                        icon: _selectedIndex == 1
                            ? AppImagesPath.bookmark
                            : AppImagesPath.bookmark,
                        title: 'Bookmark',
                        onTap: (pos) {
                          setState(() {
                            _selectedIndex = pos;
                          });
                        },
                        position: 1,
                      ),
                      NavBarItem(
                        icon: _selectedIndex == 2
                            ? AppImagesPath.bookmark
                            : AppImagesPath.bookmark,
                        title: 'Daily Dua',
                        onTap: (pos) {
                          setState(() {
                            _selectedIndex = pos;
                          });
                        },
                        position: 2,
                      ),
                      NavBarItem(
                        icon: _selectedIndex == 3
                            ? AppImagesPath.bookmark
                            : AppImagesPath.bookmark,
                        title: 'Settings',
                        onTap: (pos) async {
                          setState(() {
                            _selectedIndex = pos;
                          });
                        },
                        position: 3,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
