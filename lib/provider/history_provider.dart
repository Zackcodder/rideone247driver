

import 'package:flutter/material.dart';
import 'package:ride_on_driver/model/rides_histories_model.dart';

import '../services/driver_services.dart';

class OrderHistoryProvider with ChangeNotifier {
  final DriverService _driverService = DriverService();

  ///ride histories
  List<RidesHistories>? allRideHistory;

  fetchRideHistory(String token) async {
    print('oya ooo');
    try {
      allRideHistory = await _driverService.getRideHistory(token);
      // Sort the ride history from recent to old
      allRideHistory?.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      print('ahhhh');
      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching ride history: $error');
    }
  }

  ///
/// GoogleMapController? mapController;
//   final Completer<GoogleMapController> _controller = Completer();
//   Set<Polyline> _polylines = {};
//   BitmapDescriptor? startMarker;
//   BitmapDescriptor? endMarker;
//
//   @override
//   void initState() {
//     super.initState();
//     // _plotPolyline();
//     _loadCustomMarkers();
//   }
//
//   Future<void> _loadCustomMarkers() async {
//     final BitmapDescriptor startIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(10, 10)), // Adjust size as needed
//       'assets/images/pickup_marker.png',
//     );
//     final BitmapDescriptor endIcon = await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(10, 10)), // Adjust size as needed
//       'assets/images/dest_marker.png',
//     );
//
//     setState(() {
//       startMarker = startIcon;
//       endMarker = endIcon;
//     });
//
//     // Plot the polyline after loading the markers
//     _plotPolyline();
//   }
//
//   LatLng convertToLatLng(Map<String, dynamic> locationMap) {
//     return LatLng(locationMap['coordinates'][1], locationMap['coordinates'][0]);
//   }
//
//   LatLngBounds boundsFromLatLngList(List<LatLng> list) {
//     assert(list.isNotEmpty);
//     double x0 = list[0].latitude;
//     double x1 = list[0].latitude;
//     double y0 = list[0].longitude;
//     double y1 = list[0].longitude;
//     for (LatLng latLng in list) {
//       if (latLng.latitude > x1) x1 = latLng.latitude;
//       if (latLng.latitude < x0) x0 = latLng.latitude;
//       if (latLng.longitude > y1) y1 = latLng.longitude;
//       if (latLng.longitude < y0) y0 = latLng.longitude;
//     }
//     return LatLngBounds(
//       northeast: LatLng(x1, y1),
//       southwest: LatLng(x0, y0),
//     );
//   }
//
//    _plotPolyline() {
//     if (startMarker == null || endMarker == null) return;
//
//     setState(() {
//       _polylines = {
//         Polyline(
//             geodesic: true,
//             polylineId: const PolylineId('trip_polyline'),
//           points: [
//             convertToLatLng(
//                 widget.singleTrip.dropOffLocation as Map<String, dynamic>),
//             convertToLatLng(
//                 widget.singleTrip.pickUpLocation as Map<String, dynamic>),
//           ],
//           color: Colors.orange,
//           width: 3,
//           startCap: Cap.customCapFromBitmap(startMarker!),
//           endCap: Cap.customCapFromBitmap(endMarker!),
//         ),
//       };
//
//       LatLngBounds bounds = boundsFromLatLngList([
//         convertToLatLng(
//             widget.singleTrip.dropOffLocation as Map<String, dynamic>),
//         convertToLatLng(
//             widget.singleTrip.pickUpLocation as Map<String, dynamic>),
//       ]);
//
//       // Move camera to fit the bounds
//       mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
//     });
//   }
///

}