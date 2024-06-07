import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/core/extensions/build_context_extensions.dart';
import 'package:ride_on_driver/core/extensions/widget_extensions.dart';
import 'package:ride_on_driver/model/rides_histories_model.dart';

import '../../core/constants/assets.dart';
import '../../core/painters_clippers/vertical_dot_line.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/currency_widget.dart';
import '../../widgets/map_widget.dart';
import '../../widgets/spacing.dart';

class RidesHistoriesDetailsScreen extends StatefulWidget {
  final RidesHistories singleTrip;
  const RidesHistoriesDetailsScreen(this.singleTrip, {super.key});

  @override
  State<RidesHistoriesDetailsScreen> createState() =>
      _RidesHistoriesDetailsScreenState();
}

class _RidesHistoriesDetailsScreenState
    extends State<RidesHistoriesDetailsScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver{
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = {};
  BitmapDescriptor? startMarker;
  BitmapDescriptor? endMarker;

  @override
  void initState() {
    super.initState();
    _plotPolyline();
    _loadCustomMarkers();
  }

  Future<void> _loadCustomMarkers() async {
    final BitmapDescriptor startIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)), // Adjust size as needed
      'assets/images/pickup_marker.png',
    );
    final BitmapDescriptor endIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(10, 10)), // Adjust size as needed
      'assets/images/dest_marker.png',
    );

    setState(() {
      startMarker = startIcon;
      endMarker = endIcon;
    });

    // Plot the polyline after loading the markers
    _plotPolyline();
  }

  LatLng convertToLatLng(Map<String, dynamic> locationMap) {
    return LatLng(locationMap['coordinates'][1], locationMap['coordinates'][0]);
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = list[0].latitude;
    double x1 = list[0].latitude;
    double y0 = list[0].longitude;
    double y1 = list[0].longitude;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(
      northeast: LatLng(x1, y1),
      southwest: LatLng(x0, y0),
    );
  }

  _plotPolyline() {
    if (startMarker == null || endMarker == null) return;

    setState(() {
      _polylines = {
        Polyline(
          geodesic: true,
          polylineId: const PolylineId('trip_polyline'),
          points: [
            convertToLatLng(widget.singleTrip.dropOffLocation),
            convertToLatLng(widget.singleTrip.pickUpLocation),
          ],
          color: Colors.orange,
          width: 3,
          startCap: Cap.customCapFromBitmap(startMarker!),
          endCap: Cap.customCapFromBitmap(endMarker!),
        ),
      };

      LatLngBounds bounds = boundsFromLatLngList([
        convertToLatLng(widget.singleTrip.dropOffLocation),
        convertToLatLng(widget.singleTrip.pickUpLocation),
      ]);

      // Move camera to fit the bounds
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History',
            style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'SFPRODISPLAYREGULAR')),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      backgroundColor: AppColors.lightGrey,
      body: Container(
        ///background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsImagesPatternBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: AppColors.grey.withOpacity(0.7),
            ),

            ///google map
            SizedBox(
              height: 150,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: convertToLatLng(widget.singleTrip.dropOffLocation),
                  zoom: 12,
                ),
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {});
                  _plotPolyline();
                  _loadCustomMarkers();
                  mapController = controller;
                  _controller.complete(controller);
                  mapController!.animateCamera(CameraUpdate.newLatLng(
                      convertToLatLng(widget.singleTrip.dropOffLocation)));
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
              ),
            ),
            const VerticalSpacing(10),

            ///driver details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ///passenger name
                Column(
                  children: [
                    Text('Passenger',
                        style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    Text(
                        '${widget.singleTrip.rider.firstName} ${widget.singleTrip.rider.lastName}',
                        style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'SFPRODISPLAYREGULAR'))
                  ],
                ),

                /// trip rating
                Column(
                  children: [
                    Text('Rating',
                        style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.yellow,
                        ),
                        Text('4.5',
                            style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                fontFamily: 'SFPRODISPLAYREGULAR')),
                      ],
                    )
                  ],
                ),

                /// status
                Column(
                  children: [
                    Text('Status',
                        style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            fontFamily: 'SFPRODISPLAYREGULAR')),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: widget.singleTrip.status == 'ended'
                              ? AppColors.red
                              : AppColors.yellow,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(widget.singleTrip.status,
                            style: context.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: widget.singleTrip.status == 'ended'
                                    ? AppColors.red
                                    : AppColors.green,
                                fontFamily: 'SFPRODISPLAYREGULAR')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppColors.grey.withOpacity(0.7),
                  ),

                  ///pickup and destination name
                  Row(
                    children: [
                      /// pickup and destination icon
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.black,
                            size: 20.w,
                          ),
                          CustomPaint(
                            size: Size(1, 30.h),
                            painter: const DashedLineVerticalPainter(
                              color: AppColors.black,
                            ),
                          ),
                          Icon(
                            Icons.send_outlined,
                            // Icons.electric_bike,
                            color: AppColors.black,
                            size: 20.w,
                          ).rotate(-0.6),
                        ],
                      ),
                      const HorizontalSpacing(10),

                      /// pickup and destination names
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.singleTrip.pickUpName,
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            widget.singleTrip.createdAt.toLocal().toString(),
                            style: context.textTheme.bodySmall,
                          ),
                          const VerticalSpacing(10),
                          Text(
                            widget.singleTrip.dropOffName,
                            style: context.textTheme.bodyMedium,
                          ),
                          Text(
                            widget.singleTrip.createdAt.toLocal().toString(),
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ).expand(),
                      const HorizontalSpacing(10),
                    ],
                  ),
                  Divider(
                    color: AppColors.grey.withOpacity(0.7),
                  ),

                  ///payment summary
                  const Text('Payment Summary'),
                  const VerticalSpacing(10),

                  ///fare
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fare',
                          style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              fontFamily: 'SFPRODISPLAYREGULAR')),
                      CurrencyWidget(
                        price: widget.singleTrip.fare ?? 0,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                  const VerticalSpacing(10),

                  ///booking fee
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Booking Fee',
                          style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              fontFamily: 'SFPRODISPLAYREGULAR')),
                      CurrencyWidget(
                        price: widget.singleTrip.fare ?? 0,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                  const VerticalSpacing(10),

                  ///discount
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text('Discount',
                  //         style: context.textTheme.bodyMedium!.copyWith(
                  //             fontWeight: FontWeight.w400,
                  //             fontSize: 13,
                  //             fontFamily: 'SFPRODISPLAYREGULAR')),
                  //     const CurrencyWidget(
                  //       price: 0,
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w400,
                  //     )
                  //   ],
                  // ),
                  // const VerticalSpacing(10),
                  // Divider(
                  //   color: AppColors.grey.withOpacity(0.7),
                  // ),
                  // const VerticalSpacing(10),

                  ///total amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL',
                          style: context.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              fontFamily: 'SFPRODISPLAYREGULAR')),
                      CurrencyWidget(
                        price: widget.singleTrip.fare ?? 0,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                  const VerticalSpacing(10),

                  ///payment method
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         const Icon(Icons.money_rounded),
                  //         // Image.asset(Assets.assetsSvgsPaymentMethod),
                  //         Text(widget.singleTrip.paymentMethod,
                  //             style: context.textTheme.bodyMedium!.copyWith(
                  //                 fontWeight: FontWeight.w400,
                  //                 fontSize: 13,
                  //                 fontFamily: 'SFPRODISPLAYREGULAR')),
                  //       ],
                  //     ),
                  //     const CurrencyWidget(
                  //       price: 6500,
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w400,
                  //     )
                  //   ],
                  // ),
                  // const VerticalSpacing(30),
                  //
                  AppElevatedButton.large(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      text: 'Done')
                ],
              ),
            ).expand()
          ],
        ),
      ),
    );
  }
}
