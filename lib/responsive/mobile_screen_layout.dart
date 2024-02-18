import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:rabka_movie/utils/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:rabka_movie/widgets/bottom_nav_widget.dart';
import 'package:rabka_movie/widgets/custom_drawer_widget.dart';
import 'package:rabka_movie/widgets/top_nav_widget.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late final _advancedDrawerController = AdvancedDrawerController();

  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    _advancedDrawerController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  List<Map<String, dynamic>> navItems = [
    {"page": "Home", "icon": Icons.home},
    {"page": "Movies", "icon": Icons.movie},
    {"page": "Series", "icon": Icons.tv},
    {"page": "Local", "icon": Icons.location_on},
  ];

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: bgPrimaryColor),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      drawer: const CustomDrawerWidget(),
      child: Scaffold(
        appBar:
            TopNavWidget(advancedDrawerController: _advancedDrawerController),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: homeScreenItems,
        ),
        extendBody: true,
        bottomNavigationBar: BottomNavWidget(
          currentPage: _page,
          navItems: navItems,
          onTap: navigationTapped,
        ),
      ),
    );
  }
}
