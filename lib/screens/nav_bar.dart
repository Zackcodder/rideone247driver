import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/provider/nav_bar_provider.dart';
import 'package:ride_on_driver/provider/nav_bar_provider.dart';
import 'package:ride_on_driver/screens/trip_screens/history_screen.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/profile_screens/profile_screen.dart';

import '../core/constants/assets.dart';
import '../core/constants/colors.dart';

class NavBar extends StatefulWidget {
  static String id = 'nav_bar';
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

// final ValueNotifier<int> currentPageIndexNotifier = ValueNotifier<int>(0);

class _NavBarState extends State<NavBar> {
  // late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    // screens = [
    //   const HomeScreen(),
    //   const RideHistoriesScreen(),
    //   const ProfileScreen(),
    // ];
  }

  List<Widget> screens = [
    const HomeScreen(),
    const RideHistoriesScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NavbarProvider navbarProvider = Provider.of<NavbarProvider>(context);
    return Scaffold(
        body: screens[navbarProvider.currenTab],
        // Container(
        //   ///background deco image
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage(Assets.assetsImagesPatternBackground),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   child: Stack(
        //     alignment: Alignment.bottomCenter,
        //     children: [
        //       screens[navbarProvider.currenTab],
        //       _FloatingBottomBar(
        //         currentPageIndex: navbarProvider.currenTab,
        //         onIndexChange: (int index) =>
        //             Provider.of<NavbarProvider>(context, listen: false)
        //                 .updateScreen(index),
        //       ),
        //     ],
        //   ),
        // ),

        bottomNavigationBar: Container(
          margin: EdgeInsets.all(10.h),
          height: 56.h,
          ///background deco image
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage(Assets.assetsImagesPatternBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: NavigationBarTheme(
            data: const NavigationBarThemeData(
              backgroundColor: AppColors.black,
              indicatorColor: Colors.transparent,
            ),
            child: Center(
              child: NavigationBar(
                animationDuration: const Duration(seconds: 1),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                selectedIndex: navbarProvider.currenTab,
                onDestinationSelected: (int idx) {
                  Provider.of<NavbarProvider>(context, listen: false)
                      .updateScreen(idx);
                },
                destinations: const [
                  NavigationDestination(
                      icon: Icon(
                        Icons.home,
                        color: AppColors.white,
                        size: 30,
                      ),
                      selectedIcon: Icon(
                        Icons.home,
                        color: AppColors.yellow,
                        size: 30,
                      ),
                      label: 'Home'),
                  NavigationDestination(
                      icon: Icon(
                        Icons.history,
                        color: AppColors.white,
                        size: 30,
                      ),
                      selectedIcon: Icon(
                        Icons.history,
                        color: AppColors.yellow,
                        size: 30,
                      ),
                      label: 'History'),
                  NavigationDestination(
                    icon: Icon(
                      Icons.settings,
                      color: AppColors.white,
                      size: 30,
                    ),
                    selectedIcon: Icon(
                      Icons.settings,
                      color: AppColors.yellow,
                      size: 30,
                    ),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _FloatingBottomBar extends StatelessWidget {
  const _FloatingBottomBar(
      {required this.currentPageIndex, required this.onIndexChange});
  final int currentPageIndex;
  final Function(int) onIndexChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.h),
      height: 56.h,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _BottomBarItem(
            icon: Icons.home,
            selected: currentPageIndex == 0,
            onTap: () => onIndexChange(0),
          ),
          _BottomBarItem(
            icon: Icons.history,
            selected: currentPageIndex == 1,
            onTap: () => onIndexChange(1),
          ),
          _BottomBarItem(
            icon: Icons.settings,
            selected: currentPageIndex == 2,
            onTap: () => onIndexChange(2),
          ),
        ],
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ///color for selected icon on nav bar top icon
          if (selected)
            Container(
              height: 3.h,
              width: 25.w,
              color: AppColors.yellow,
            ),
          const Spacer(),

          ///color for selected icon on nav bar
          Icon(
            icon,
            color: selected ? AppColors.yellow : AppColors.white,
            size: 30.w,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
