import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';

import '../model/trip.dart';
import '../services/google_map_service.dart';
import '../services/map_service.dart';
import '../services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  bool _rideRequestLoading = false;
  bool get rideRequestLoading => _rideRequestLoading;

  final SocketService _socketService = SocketService();

  RideRequestProvider(String token, String id) {
    listenForRideRequests();
    acceptRideRequestResponse();
    _socketService.initSocket(token, id);
  }

  List<Trip> _rideRequests = [];
  List<Trip> get rideRequests => _rideRequests;
  bool get hasRideRequests => _rideRequests.isNotEmpty;

  ///updating driver online status
  updateDriverStatus(BuildContext context,String id, bool availability) async {
    _socketService.driverOnlineStatus(
      id: id,
      availability: availability,
    );
    print('this is the status $availability');
    print('this is the id $id');
    _socketService.listenForSuccess();

    notifyListeners();
  }

  /// trip request
  Timer? checkForRideRequestTimer;

  String? get tripId => _tripId;
  String? _tripId;
  String? get tripLat => _tripLat;
  String? _tripLat;
  String? get tripLng => _tripLng;
  String? _tripLng;
  String? get driverId => _driverId;
  String? _driverId;
  String? get paymentMethod => _paymentMethod;
  String? _paymentMethod;

  listenForRideRequests() async {
    print('starting another wahala ');

      try {
        /// Listen for ride requests and handle them
        Trip? newRequest = await _socketService.listenForRideRequest();

        if (newRequest != null) {
          // Handle the ride request data, for example, add it to a list
          _rideRequests.add(newRequest);
          _tripId = newRequest.tripId;
          _tripLat = newRequest.dropOffLon.toString();
          _tripLng = newRequest.pickUpLat.toString();
          _driverId = newRequest.driverId;
          _paymentMethod = newRequest.paymentMethod;
          print('this is a trip lat: ${newRequest.dropOffLon}');
          print('this is a trip lng: ${newRequest.pickUpLat}');
          print('this is a trip id: ${newRequest.tripId}');
          print('this is a driver id: ${newRequest.driverId}');
          print('this is a trip payment method: ${newRequest.paymentMethod}');

          // Notify listeners that the ride requests list has been updated
          notifyListeners();
        }
      } catch (e) {
        // Handle any errors
        print('Error processing ride request data: $e');
      }
  }

  ///accept rider request

  List<Trip> _rideAcceptedRequests = [];
  List<Trip> get rideAcceptedRequests => _rideAcceptedRequests;
  String? get acceptedTripId => _acceptedTripId;
  String? _acceptedTripId;
  String? get riderPaymentMethod => _riderPaymentMethod;
  String? _riderPaymentMethod;
  String? get riderName => _riderName;
  String? _riderName;
  double? get riderPickUpLat => _riderPickUpLat;
  double? _riderPickUpLat;
  double? get riderPickUpLon => _riderPickUpLon;
  double? _riderPickUpLon;
  double? get riderDestinationLat => _riderDestinationLat;
  double? _riderDestinationLat;
  double? get riderDestinationLon => _riderDestinationLon;
  double? _riderDestinationLon;

  acceptRideRequest(String id, String lon, String lat, String tripId) async{
    print('starting accetp trip in provider');
    _socketService.acceptRide(id: id, lon: lon, lat: lat, tripId: tripId);
    // acceptRideRequestResponse();
    // _socketService.listenForError();
    notifyListeners();
  }

  acceptRideRequestResponse() async{
    print('printing accept response in provider');
    try {
      /// Listen for ride acceptance and handle them
      Trip? newAcceptedRequest = await _socketService.acceptRideRespond();

      if (newAcceptedRequest != null) {
        // Handle the ride request data, for example, add it to a list
        _rideAcceptedRequests.add(newAcceptedRequest);
        _riderName = newAcceptedRequest.riderName;
        _acceptedTripId = newAcceptedRequest.riderTripId;
        _riderPaymentMethod = newAcceptedRequest.riderPaymentMethod;
        _riderPickUpLat = newAcceptedRequest.riderPickupLat;
        _riderPickUpLon = newAcceptedRequest.riderPickupLon;
        _riderDestinationLat = newAcceptedRequest.riderDropOffLat;
        _riderDestinationLon = newAcceptedRequest.riderDropOffLon;
        // Notify listeners that the ride requests list has been updated
        notifyListeners();

        print('this is a rider name: ${newAcceptedRequest.riderName}');
        print('this is a trip lng: ${newAcceptedRequest.riderPickupLon}');
        print('this is a rider trip id: ${newAcceptedRequest.riderTripId}');
        print('this is a rider payment method: ${newAcceptedRequest.riderPaymentMethod}');

      }
    } catch (e) {
      // Handle any errors
      print('Error processing ride request data: $e');
    }
  }

  ///start trip
  startRide( String id,  String tripId) async{
    print('starting ride in provider');
    _socketService.startTrip(id: id, tripId: tripId);
    print('starting ride respoinse in provider');
    _socketService.listenForSuccess();
    _socketService.listenForError();
    notifyListeners();
  }

  endRiderTrip(String id,  String tripId) async{
    print('ending trip from provider');
    _socketService.endTrip(id: id, tripId: tripId);
    print('printing the success response for end trip in provider');
    _socketService.listenForTripEnd();
    print('printing the error response for end trip in provider');
    _socketService.listenForError();
    notifyListeners();
  }

  ///reset app to default
  resetApp() async{
    _riderName = '';
    _acceptedTripId = '';
    _riderPaymentMethod = '';
    _riderPickUpLat =0.0;
    _riderPickUpLon = 0.0;
    _riderDestinationLat = 0.0;
    _riderDestinationLon = 0.0;
    _tripId = '';
    _tripLat = '';
    _tripLng ='';
    _driverId = '';
    _paymentMethod = '';
    _rideRequests = [];
    _rideAcceptedRequests = [];
    notifyListeners();
  }

  ///extracting of coordinate
  List<LatLng> extractPolylineCoordinates(List<PointLatLng> points) {
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  ///poly line from driver location to rider pickup location

  final GoogleMapService _googleMapService = GoogleMapService();
  final MapService _mapService = MapService();
  final GeoLocationService _geoLocationService = GeoLocationService();
  late List _riderLocationCoordinates;
  List get riderLocationCoordinates => _riderLocationCoordinates;


  displayDirectionsToPickup(imageConfiguration) async {

    ///get driver current location
    var currentPosition = await _geoLocationService.getCurrentPosition(
      forceUseCurrentLocation: true,
      asPosition: true,
    );
    /// get rider  coordinates
    var pickup = _googleMapService.convertDoubleToLatLng(
        _riderPickUpLat ?? 0.0, _riderPickUpLon ?? 0.0);

    ///assign the driver location as lan and lng
    var currentLocationCoordinates = [
      currentPosition.latitude,
      currentPosition.longitude
    ];
    ///assign the rider location as lan and lng
    var pickupCoordinates = [
      pickup.latitude,
      pickup.longitude,
    ];
    _riderLocationCoordinates = pickupCoordinates;
    if (pickupCoordinates.isEmpty && currentLocationCoordinates.isEmpty) {
      return Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'no dest and pickup',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);

    }

    /// Fetch directions using your API service (e.g., MapService)
    var directionsResponse = await _mapService.getDirections(
      pickup: currentLocationCoordinates,
      destination: pickupCoordinates,
    );

    if (directionsResponse != null) {
      if (directionsResponse == null) {
        print('The plotting is not working');
      } else if (directionsResponse.isNotEmpty) {
        /// Extract polyline coordinates from the directions response
        final List<PointLatLng> pointLatLngList =
        _googleMapService.decodePolylines(
          directionsResponse ['routes'][0]['overview_polyline']['points'],
        );

        /// Convert List<PointLatLng> to List<LatLng>
        final List<LatLng> polylineCoordinates = pointLatLngList
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        _googleMapService.clearCircles();
        _googleMapService.clearMarkers();
        _googleMapService.clearPolyLines();
        _googleMapService.clearPolyLineCoordinate();

        /// Update the map to display the polyline
        _googleMapService.setPolyLine(polylineCoordinates);
        _googleMapService.fitPolyLineToMap(
          pickup: currentLocationCoordinates,
          destination: pickupCoordinates,
        );
        LatLng convertPositionToLatLng(Position position) {
          return LatLng(position.latitude, position.longitude);
        }

        var driverMarker = _googleMapService.createMarker(
          id: 'pickup',
          position: convertPositionToLatLng(currentPosition),
          imageConfiguration: imageConfiguration,
          // icon: carIcon,
        );
        var riderMarker = _googleMapService.createMarker(
          id: 'destination',
          position: pickup,
          imageConfiguration: imageConfiguration,
          // icon: personIcon,
        );
        _googleMapService.addMarkers(driverMarker);
        _googleMapService.addMarkers(riderMarker);

        final durationText =
        directionsResponse['routes'][0]['legs'][0]['duration']['text'];
        // final etaTimer1 =
        //     int.parse(RegExp(r"(\d+)").stringMatch(durationText) ?? '0');

        // _tripDistance = distanceText;
        // _etaTimer1 = etaTimer1.toString();
        /// _etaTimer1 = durationText ?? 'Calculating';

        notifyListeners();
      } else {}
    } else {}
  }

  ///refresh connect rider code
  // late Timer _refreshDirectionToRiderLocationTimer;
  // restartDisplayDirectionsToPickup(imageConfiguration) {
  //   // Start a repeating timer that triggers every 2 seconds
  //   _refreshRideRequestTimer =
  //       Timer.periodic(const Duration(seconds: 60), (timer) {
  //         // Call the refreshMap function to update the map and driver locations
  //         displayDirectionsToPickup(imageConfiguration);
  //       });
  // }
  //
  // // Start the auto-refresh timer
  // startAutoDisplayDirectionsToPickup(imageConfiguration) {
  //   restartDisplayDirectionsToPickup(imageConfiguration);
  // }
  //
  // //stop rider request timer
  // stopAutoDisplayDirectionsToPickup() {
  //   if (_refreshDirectionToRiderLocationTimer.isActive) {
  //     _refreshDirectionToRiderLocationTimer.cancel();
  //   }
  // }
}
