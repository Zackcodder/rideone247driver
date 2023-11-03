// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';

class TabItem {
  final String title;

  const TabItem(this.title);

  @override
  bool operator ==(covariant TabItem other) => other.title == title;

  @override
  int get hashCode => title.hashCode;
}

class CustomTabbar extends StatelessWidget {
  const CustomTabbar({
    super.key,
    required this.tabs,
    required this.selectedTab,
    this.onTabSelected,
  });
  final List<TabItem> tabs;
  final TabItem selectedTab;
  final Function(TabItem)? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      width: 340.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.yellow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabs
            .map(
              (item) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (selectedTab == item) return;
                    onTabSelected?.call(item);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: item == selectedTab ? Colors.white : null,
                    ),
                    child: Center(
                      child: Text(
                        item.title.toUpperCase(),
                        style: context.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
