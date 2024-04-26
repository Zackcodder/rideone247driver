import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';
import 'package:ride_on_driver/services/polyline_point_service.dart';

import '../model/trip.dart';
import '../screens/home_screen.dart';
import '../services/google_map_service.dart';
import '../services/map_service.dart';
import '../services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
 final bool _rideRequestLoading = false;
  bool get rideRequestLoading => _rideRequestLoading;

  final SocketService _socketService = SocketService();

  RideRequestProvider(
    String token,
    String id,
  ) {
    listenForRideRequests();
    acceptRideRequestResponse();
    _socketService.initSocket(token, id);
    notifyListeners();
  }

  List<Trip> _rideRequests = [];
  List<Trip> get rideRequests => _rideRequests;
  bool get hasRideRequests => _rideRequests.isNotEmpty;
  final bool _onLine = false;
  bool get onLine => _onLine;

  ///updating driver online status
  updateDriverStatus(BuildContext context, String id, bool availability) async {
    await _socketService.driverOnlineStatus(id: id, availability: availability);
    print('this is the status $availability');
    print('this is the id $id');
    // var onlineResponse = await _socketService.listenForSuccess();
    // if (onlineResponse == 'You are now available'
    //     || onlineResponse == 'You are now unavailable') {
    //   isActiveNotifier.value = availability; // Update isActiveNotifier value
    //   notifyListeners();
    // }
    isActiveNotifier.value = availability;
    notifyListeners();
    // if(onlineResponse == 'You are now available'){
    //   return Fluttertoast.showToast(
    //     fontSize: 18,
    //     toastLength: Toast.LENGTH_LONG,
    //     backgroundColor: Colors.black.withOpacity(0.7),
    //     msg: 'You are now available',
    //     gravity: ToastGravity.BOTTOM,
    //     textColor: Colors.white);
    // }
    // else if(onlineResponse == 'You are now unavailable'){
    //   return Fluttertoast.showToast(
    //       fontSize: 18,
    //       toastLength: Toast.LENGTH_LONG,
    //       backgroundColor: Colors.black.withOpacity(0.7),
    //       msg: 'You are now unavailable',
    //       gravity: ToastGravity.BOTTOM,
    //       textColor: Colors.white);
    //
    // }
    //
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
  int? _tripCost;
  int? get tripCost => _tripCost;
  String? get paymentMethod => _paymentMethod;
  String? _paymentMethod;
  double get tripRequestSheetHeight =>_tripRequestSheetHeight;
  double _tripRequestSheetHeight = 0;
  bool _newTripRequest = false;
  bool get newTripRequest => _newTripRequest;

  ///
 listenForRideRequests() {
   _socketService.rideRequestStream.listen((newRequest) {
     if (newRequest != null) {
       _newTripRequest = true;
       _rideRequests.add(newRequest);
       _riderName = newRequest.riderName;
       _riderPickUpLocationName = newRequest.riderPickUpName;
       _riderDestinationLocationName = newRequest.riderDestinationName;
       _tripCost = newRequest.cost;
       _tripId = newRequest.tripId;
       _tripLat = newRequest.dropOffLon.toString();
       _tripLng = newRequest.pickUpLat.toString();
       _driverId = newRequest.driverId;
       _paymentMethod = newRequest.paymentMethod;

       _tripRequestSheetHeight = 250;

       // Notify listeners that the ride requests list has been updated
       notifyListeners();
     }
   });
 }
  ///

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
  String? _riderPickUpLocationName;
  String? get riderPickUpLocationName => _riderPickUpLocationName;
  String? _riderDestinationLocationName;
  String? get riderDestinationLocationName => _riderDestinationLocationName;

  acceptRideRequest(String id, String lon, String lat, String tripId) async {
    print('starting accetp trip in provider');
    await _socketService.acceptRide(id: id, lon: lon, lat: lat, tripId: tripId);
    _tripRequestSheetHeight=0;
    notifyListeners();
  }
  ///accept trip request
 ///
 acceptRideRequestResponse() async{
   _socketService.acceptedRequestStream.listen((newAcceptedRequest) {
     if (newAcceptedRequest != null) {
       // Handle the accepted ride request data
       _rideAcceptedRequests.add(newAcceptedRequest);
       _riderName = newAcceptedRequest.riderName;
       _acceptedTripId = newAcceptedRequest.riderTripId;
       _riderPaymentMethod = newAcceptedRequest.riderPaymentMethod;
       _riderPickUpLat = newAcceptedRequest.riderPickupLat;
       _riderPickUpLon = newAcceptedRequest.riderPickupLon;
       _riderDestinationLat = newAcceptedRequest.riderDropOffLat;
       _riderDestinationLon = newAcceptedRequest.riderDropOffLon;

       print('this is a rider name: ${newAcceptedRequest.riderName}');
       print('this is a trip lng: ${newAcceptedRequest.riderPickupLon}');
       print('this is a rider trip id: ${newAcceptedRequest.riderTripId}');
       print('this is a rider payment method: ${newAcceptedRequest.riderPaymentMethod}');

       notifyListeners();
     }
   });
 }

  
  ///start trip
  startRide(String id, String tripId) async {
    print('starting ride in provider');
    await _socketService.startTrip(id: id, tripId: tripId);
    print('starting ride respoinse in provider');
    _socketService.listenForSuccess();
    _socketService.listenForError();
    notifyListeners();
  }

  endRiderTrip(String id, String tripId) async {
    print('ending trip from provider');
    _socketService.endTrip(id: id, tripId: tripId);
    print('printing the success response for end trip in provider $id');
    _socketService.listenForTripEnd();
    print('printing the error response for end trip in provider $tripId');
    _socketService.listenForError();
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
  final PolylinePointService _polylinePointService = PolylinePointService();
  final MapService _mapService = MapService();
  final GeoLocationService _geoLocationService = GeoLocationService();
  late List _riderLocationCoordinates;
  List get riderLocationCoordinates => _riderLocationCoordinates;
  String? get etaTimer => _etaTimer;
  String? _etaTimer;
  String? get distance => _distance;
  String? _distance;

  ///displaying the location to the rider fromt he driver location
  displayDirectionsToPickup(imageConfiguration) async {
    ///get driver current location
    var currentPosition = await _geoLocationService.getCurrentPosition(
      forceUseCurrentLocation: true,
      asPosition: true,
    );
    /// get rider  coordinates
    var pickup = _googleMapService.convertDoubleToLatLng(
        _riderDestinationLat ?? 0.0, _riderDestinationLon ?? 0.0);

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
      pickup: currentPosition,
      destination: pickupCoordinates,
    );

    if (directionsResponse != null) {
      if (directionsResponse == null) {
        print('The plotting is not working');
      } else if (directionsResponse.isNotEmpty) {
        /// Extract polyline coordinates from the directions response
        final List pointLatLngList =
        _polylinePointService.decodePolyPoints(
          directionsResponse ['routes'][0]['overview_polyline']['points'],
        );
        // final List<PointLatLng> pointLatLngList =
        // _googleMapService.decodePolylines(
        //   directionsResponse ['routes'][0]['overview_polyline']['points'],
        // );

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

        final durationText = directionsResponse['routes'][0]['legs'][0]['duration']['text'];
        final distanceText = directionsResponse['routes'][0]['legs'][0]['distance']['text'];
        // final etaTimer1 =
        //     int.parse(RegExp(r"(\d+)").stringMatch(durationText) ?? '0');

        // _tripDistance = distanceText;
        // _etaTimer1 = etaTimer1.toString();
         _etaTimer = durationText ?? 'Calculating';
         _distance = distanceText ?? 'Calculating';
         print('this is the time to get to the rider: $_etaTimer');

        notifyListeners();
      } else {}
    } else {}
  }

  ///display the trip direction for the driver

  String? get tripEtaTimer => _tripEtaTimer;
  String? _tripEtaTimer;
  String? get tripDistance => _tripDistance;
  String? _tripDistance;
  displayDirectionForActivateTrip(imageConfiguration) async {
    /// get rider pickup coordinates
    var pickup = _googleMapService.convertDoubleToLatLng(
        _riderDestinationLat ?? 0.0, _riderDestinationLon ?? 0.0);

    /// get rider destination coordinate
    var destination = _googleMapService.convertDoubleToLatLng(
        _riderPickUpLat ?? 0.0, _riderPickUpLon ?? 0.0);

    ///assign the destination location as lan and lng
    var destinationCoordinates = [destination.latitude, destination.longitude];

    ///assign the rider location as lan and lng
    var pickupCoordinates = [
      pickup.latitude,
      pickup.longitude,
    ];
    _riderLocationCoordinates = pickupCoordinates;
    if (pickupCoordinates.isEmpty && destinationCoordinates.isEmpty) {
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
      pickup: destinationCoordinates,
      destination: pickupCoordinates,
    );

    if (directionsResponse != null) {
      print('Directions Response: $directionsResponse');
      if (directionsResponse == null) {
        print('The plotting is not working');
      }
      else if (directionsResponse.isNotEmpty &&directionsResponse.containsKey('routes') && directionsResponse['routes'].isNotEmpty) {
        var route = directionsResponse['routes'][0];
        print('Route: $route');
        if (route.containsKey('overview_polyline')) {
          var overviewPolyline = route['overview_polyline'];
          print('Overview Polyline: $overviewPolyline');
          var points = overviewPolyline['points'];
          print('Points: $points');}
        /// Extract polyline coordinates from the directions response
        final List pointLatLngList = _polylinePointService.decodePolyPoints(
          directionsResponse['routes'][0]['overview_polyline']['points'],

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
          pickup: destinationCoordinates,
          destination: pickupCoordinates,
        );
        LatLng convertPositionToLatLng(Position position) {
          return LatLng(position.latitude, position.longitude);
        }

        Marker originMarker = _googleMapService.createMarker(
          id: 'origin',
          position: destination,
          imageConfiguration: imageConfiguration,
          iconPath: 'assets/images/logo.png',
        );
        Marker destinationMarker = _googleMapService.createMarker(
          id: 'destination',
          position: pickup,
          imageConfiguration: imageConfiguration,
          // icon: Icon(Icons.add),
        );

        Circle originCircle = Circle(
            circleId: CircleId('origin'),
            fillColor: Colors.green,
            radius: 12,
            strokeColor: Colors.white,
            strokeWidth: 3,
            center: pickup);

        Circle destinationCircle = Circle(
            circleId: CircleId('destination'),
            fillColor: Colors.black,
            radius: 12,
            strokeColor: Colors.white,
            strokeWidth: 3,
            center: pickup);
        _googleMapService.addMarkers(originMarker);
        _googleMapService.addMarkers(destinationMarker);
        _googleMapService.addCircle(originCircle);
        _googleMapService.addCircle(destinationCircle);
        notifyListeners();

        final durationText =
            directionsResponse['routes'][0]['legs'][0]['duration']['text'];
        final distanceText =
            directionsResponse['routes'][0]['legs'][0]['distance']['text'];
        // final etaTimer1 =
        //     int.parse(RegExp(r"(\d+)").stringMatch(durationText) ?? '0');

        // _tripDistance = distanceText;
        // _etaTimer1 = etaTimer1.toString();
        _tripEtaTimer = durationText ?? 'Calculating';
        _tripDistance = distanceText ?? 'Calculating';
        print('this is the time fro the rider trip: $_tripEtaTimer');
        print('this is the distance to the rider destination: $_tripDistance');
        notifyListeners();
      }
      else {
        print('No routes in directions response');}
    } else {
      print('Directions response is null');}
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

  ///reset app to default
  resetApp() async {
    _riderName = '';
    _acceptedTripId = '';
    _riderPaymentMethod = '';
    _riderPickUpLat = 0.0;
    _riderPickUpLon = 0.0;
    _riderDestinationLat = 0.0;
    _riderDestinationLon = 0.0;
    _tripId = '';
    _tripLat = '';
    _tripLng = '';
    _driverId = '';
    _paymentMethod = '';
    _rideRequests = [];
    _riderLocationCoordinates = [];
    _rideAcceptedRequests = [];
    _riderPickUpLon = 0.0;
    _riderPickUpLat = 0.0;
    _googleMapService.clearPolyLines();
    _googleMapService.clearPolyLineCoordinate();
    // listenForRideRequests();
    notifyListeners();
  }
}