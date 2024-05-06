import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/screens/history_screen.dart';
import 'package:ride_on_driver/screens/home_screen.dart';
import 'package:ride_on_driver/screens/profile_edit_screen.dart';
import 'package:ride_on_driver/screens/profile_screen.dart';

import '../core/constants/assets.dart';
import '../core/constants/colors.dart';

class NavBar extends StatefulWidget {
  static String id = 'nav_bar';
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

final ValueNotifier<int> currentPageIndexNotifier = ValueNotifier<int>(0);

class _NavBarState extends State<NavBar> {
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const HomeScreen(),
      const RideHistoriesScreen(),
      const ProfileEditScreen(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        ///background deco image
        // decoration:  BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Assets.assetsImagesPatternBackground),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: ValueListenableBuilder(
          valueListenable: currentPageIndexNotifier,
          builder: (ctx, int currentPageIndex, _) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              screens[currentPageIndex],
              _FloatingBottomBar(
                currentPageIndex: currentPageIndex,
                onIndexChange: (int index) =>
                currentPageIndexNotifier.value = index,
              ),
            ],
          ),
        ),
      ),
    );
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
        color: AppColors.yellow,
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
              color: AppColors.white,
            ),
          const Spacer(),
          ///color for selected icon on nav bar
          Icon(
            icon,
            color: selected ? AppColors.white : AppColors.black,
            size: 30.w,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

