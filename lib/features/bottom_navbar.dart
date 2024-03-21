import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:test_flutter/features/home/home.dart';
import 'package:test_flutter/features/profile/profile_page.dart';
import 'package:test_flutter/features/search/search_page.dart';
import 'package:test_flutter/utils/constant.dart' as constant;

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  bool isLoading = false;
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();

    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Dashboard",
        labels: const [
          "Search",
          "Dashboard",
          "Profile"
        ],
        icons: const [
          Icons.search_rounded,
          Icons.dashboard_rounded,
          Icons.person_rounded
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: constant.COLOR,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: constant.COLOR,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _motionTabBarController!.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _motionTabBarController,
        children: const <Widget>[
          SearchPage(),
          HomeScreen(),
          ProfilePage()
        ],
      ),
    );
  }
}