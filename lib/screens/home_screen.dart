import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/screens/active_trip_detail_view.dart';
import 'package:ride_on_driver/screens/profile_screen.dart';
import 'package:ride_on_driver/screens/requests_view.dart';
import 'package:ride_on_driver/widgets/app_logo.dart';
import 'package:ride_on_driver/widgets/custom_switch.dart';
import 'package:ride_on_driver/widgets/spacing.dart';

import '../widgets/custom_tabbar.dart';
import 'trips_view.dart';

ValueNotifier isActiveNotifier = ValueNotifier(true);
ValueNotifier isRideActiveNotifier = ValueNotifier(false);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final ValueNotifier<TabItem> currentTabNotifier;
  List<TabItem> tabs = [const TabItem('Active'), const TabItem('Requests')];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentTabNotifier = ValueNotifier(tabs.last);
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      isActiveNotifier.dispose();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (tabController.index == 0) return true;

        currentTabNotifier.value = tabs[tabController.index - 1];

        tabController.animateTo(tabController.index - 1,
            duration: const Duration(milliseconds: 300));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RIDEON247'),
          leading: UnconstrainedBox(
            child: Image.asset(
              Assets.assetsImagesDriverProfile,
              width: 40.w,
            ).clip(radius: 100),
          ).onTap(() => context.push(const ProfileScreen())),
          actions: [
            ValueListenableBuilder(
                valueListenable: isActiveNotifier,
                builder: (context, isActive, _) {
                  return CustomSwitch(
                    value: isActive,
                    onChanged: (value) => isActiveNotifier.value = value,
                  );
                }),
            const HorizontalSpacing(10),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const VerticalSpacing(20),
              MultiValueListenableBuilder(
                  valueListenables: [currentTabNotifier, isRideActiveNotifier],
                  builder: (context, values, _) {
                    final currentTab = values[0] as TabItem;
                    return CustomTabbar(
                      tabs: tabs,
                      selectedTab: currentTab,
                      onTabSelected: (item) => {
                        tabController.animateTo(
                          tabs.indexOf(item),
                          duration: const Duration(milliseconds: 300),
                        ),
                        currentTabNotifier.value = item,
                      },
                    );
                  }),
              const VerticalSpacing(20),
              ValueListenableBuilder(
                valueListenable: isActiveNotifier,
                builder: (context, active, _) {
                  return active
                      ? TabBarView(
                          controller: tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            const TripsView(),
                            ValueListenableBuilder(
                              valueListenable: isRideActiveNotifier,
                              builder: (_, rideActive, __) {
                                return rideActive
                                    ? const ActiveTripDetailView()
                                    : RequestsView(tabController: tabController);
                              },
                            ),
                          ],
                        )
                      : const OfflineView();
                },
              ).expand()
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineView extends StatelessWidget {
  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(Assets.assetsSvgsOffline),
            Text(
              'You are Currently Offline',
              style: context.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 250.w,
              child: Text(
                'please go online to get orders and do much more.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
            ),
            const Spacer(),
            const AppLogo(),
            const VerticalSpacing(30),
          ],
        ),
      ),
    );
  }
}