import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ride_on_driver/core/constants/assets.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/dummy_data/active_trips.dart';
import 'package:ride_on_driver/provider/ride_request_provider.dart';
import 'package:ride_on_driver/widgets/spacing.dart';
import 'package:ride_on_driver/widgets/trip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/authprovider.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/currency_widget.dart';
import '../widgets/rider_box.dart';

class ActiveTripDetailView extends StatefulWidget {
  const ActiveTripDetailView({super.key});

  @override
  State<ActiveTripDetailView> createState() => _ActiveTripDetailViewState();
}

class _ActiveTripDetailViewState extends State<ActiveTripDetailView> {
  late RideRequestProvider _rideRequestProvider;
  @override
  void initState() {
    super.initState();
    loadDriverDataFromSharedPreference();
    _rideRequestProvider = Provider.of<RideRequestProvider>(context, listen: false);
    _rideRequestProvider.acceptRideRequestResponse();
  }

  String? _driverName;
  String? _driverLastName;
  loadDriverDataFromSharedPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _driverLastName = prefs.getString('driver_lastname');
      _driverName = prefs.getString('driver_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    // ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: const Size(2, 2));
    Provider.of<RideRequestProvider>(context, listen: false).acceptRideRequestResponse();
    RideRequestProvider rideDetails = Provider.of<RideRequestProvider>(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BlackContainer(text: 'Showing trip details'),
              // TripCard(model: activeTripList.first).padAll(20.w),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                leading: Image.asset(Assets.assetsImagesDriverProfile).clip(radius: 100),
                title: Text(
                  '$_driverName $_driverLastName'??'',
                  style: context.textTheme.bodyMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '20/12/2020, 12:27',
                      style: context.textTheme.bodySmall,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: index < 4 ? AppColors.yellow : AppColors.grey,
                          size: 15.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalSpacing(20),
              Text(
                'Payment',
                style: context.textTheme.bodySmall,
              ).padHorizontal(20),
              Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffdfe7f5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: SvgPicture.asset( Assets.assetsSvgsPaymentLeading),
                  ),
                  title: Text(rideDetails.riderPaymentMethod ??'', style: context.textTheme.bodyLarge),
                  trailing: const CurrencyWidget(price: 800),
                ),
              ).padHorizontal(20.w),
              const VerticalSpacing(20),
              const BlackContainer(text: 'Need Help?'),
              const ChoiceRow(text: 'Resend Receipt'),
              const ChoiceRow(text: 'Trip Didn’t Happen'),
              const ChoiceRow(text: 'Reporting a safety incident'),
              const VerticalSpacing(300),
            ],
          ),
        ),
        const RiderBox(),
      ],
    );
  }
}

class ChoiceRow extends StatelessWidget {
  const ChoiceRow({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: context.textTheme.bodyMedium,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20.w,
            color: AppColors.grey.withOpacity(0.6),
          )
        ],
      ),
    );
  }
}

class BlackContainer extends StatelessWidget {
  const BlackContainer({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      color: AppColors.black,
      child: Text(
        text,
        style: context.textTheme.bodySmall!.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
