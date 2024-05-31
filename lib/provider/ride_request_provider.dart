import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_on_driver/core/constants/colors.dart';
import 'package:ride_on_driver/services/geo_locator_service.dart';
import 'package:ride_on_driver/services/polyline_point_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/trip.dart';
import '../services/google_map_service.dart';
import '../services/map_service.dart';
import '../services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  final bool _rideRequestLoading = false;
  bool get rideRequestLoading => _rideRequestLoading;

  final SocketService _socketService = SocketService();

  RideRequestProvider(String token, String id, imageConfiguration) {
    listenForRideRequests(imageConfiguration);
    acceptRideRequestResponse(imageConfiguration);
    _socketService.initSocket(token, id);
    notifyListeners();
  }

  bool get hasRideRequests => _rideRequests.isNotEmpty;
  final bool _onLine = false;
  bool get onLine => _onLine;

  ///updating driver online status
  updateDriverStatus(String id, bool availability) async {
    await _socketService.driverOnlineStatus(id: id, availability: availability);
    driverOnlineStatus();
    notifyListeners();
  }

  ///listen for driver updated status
  driverOnlineStatus() async {
    print('Driver status:');
    _socketService.listenForSuccess();
    _socketService.socket.on('SUCCESS', (data) {
      print('Driver status: $data');
      // Check if the data contains the success message
      if (data == 'You are now available') {
        return Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: AppColors.green.withOpacity(0.7),
            msg: 'You are now available',
            gravity: ToastGravity.TOP,
            textColor: AppColors.black);
      } else {
        print('error from driver online status: $data');
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: data,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
      }
      notifyListeners();
    });
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
  double get tripRequestSheetHeight => _tripRequestSheetHeight;
  double _tripRequestSheetHeight = 0;
  bool _newTripRequest = false;
  bool get newTripRequest => _newTripRequest;
  List<Trip> _rideRequests = [];
  List<Trip> get rideRequests => _rideRequests;

  ///
  listenForRideRequests(imageConfiguration) {
    _socketService.rideRequestStream.listen((newRequest) {
      _newTripRequest = true;
      _acceptedNewTripRequest = false;
      _tripHasStarted = false;
      _tripHasEnded = false;
      _driverHasArrived = false;
      _tripRequestSheetHeight = 250;
      _acceptedTripRequestSheetHeight = 0;
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
      displayDirectionsToPickup(
          imageConfiguration, _riderPickUpLat!, _riderPickUpLon!);
      notifyListeners();
    });
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
  String? _riderPickUpLocationName;
  String? get riderPickUpLocationName => _riderPickUpLocationName;
  String? _riderDestinationLocationName;
  String? get riderDestinationLocationName => _riderDestinationLocationName;
  bool _acceptedNewTripRequest = false;
  bool get acceptedNewTripRequest => _acceptedNewTripRequest;
  double get acceptedTripRequestSheetHeight => _acceptedTripRequestSheetHeight;
  double _acceptedTripRequestSheetHeight = 0;

  acceptRideRequest(String id, String lon, String lat, String tripId) async {
    print('starting accept trip in provider');
    await _socketService.acceptRide(id: id, lon: lon, lat: lat, tripId: tripId);
    notifyListeners();
  }

  // launch drive mode to rider location
  late List _riderLocationCoordinates = [_riderPickUpLat, _riderPickUpLon];
  List get riderLocationCoordinates => _riderLocationCoordinates;
  bool _isNavigationActive = false;
  bool get isNavigationActive => _isNavigationActive;
  launchGoogleMapsNavigationToRiderLocation() async {
    final url =
        Uri.parse('google.navigation:q=$_riderLocationCoordinates&mode=d');
    if (await launchUrl(url)) {
      _isNavigationActive = true;
      notifyListeners();

      return true;
    }
    return false;
  }

  ///accept trip request
  acceptRideRequestResponse(imageConfiguration) async {
    _socketService.acceptedRequestStream.listen((newAcceptedRequest) {
      if (newAcceptedRequest != null) {
        _acceptedNewTripRequest = true;
        _driverHasArrived = false;
        _newTripRequest = false;
        _tripHasStarted = false;
        _tripHasEnded = false;
        _tripRequestSheetHeight = 0;
        _acceptedTripRequestSheetHeight = 220;
        _rideAcceptedRequests.add(newAcceptedRequest);
        _riderName = newAcceptedRequest.riderName;
        _acceptedTripId = newAcceptedRequest.riderTripId;
        _riderPaymentMethod = newAcceptedRequest.riderPaymentMethod;
        _riderPickUpLat = newAcceptedRequest.riderPickupLat;
        _riderPickUpLon = newAcceptedRequest.riderPickupLon;
        _riderDestinationLat = newAcceptedRequest.riderDropOffLat;
        _riderDestinationLon = newAcceptedRequest.riderDropOffLon;
        displayDirectionsToPickup(
            imageConfiguration, _riderPickUpLat!, _riderPickUpLon!);
        // launchGoogleMapsNavigationToRiderLocation();

        print('this is a rider name: ${newAcceptedRequest.riderName}');
        print('this is a rider trip id: ${newAcceptedRequest.riderTripId}');
        print(
            'this is a rider pickup lat: ${newAcceptedRequest.riderPickupLat}');
        print(
            'this is a rider pickup lon: ${newAcceptedRequest.riderPickupLon}');
        print(
            'this is a rider destination lat: ${newAcceptedRequest.riderDropOffLat}');
        print(
            'this is a rider destination lon: ${newAcceptedRequest.riderDropOffLon}');
        print(
            'this is a rider payment method: ${newAcceptedRequest.riderPaymentMethod}');

        notifyListeners();
      }
    });
  }

  ///cancel trip
  tripCancellation(
      String id, String tripId, String role, imageConfiguration) async {
    print('driver cancelling trip');
    await _socketService.cancelTrip(id: id, tripId: tripId, role: role);
    print('printing driver cancel trip status');
    _socketService.listenForSuccess();
    resetApp(imageConfiguration);
    notifyListeners();
  }

  ///reject trip
  bool _tripRejected = false;
  bool get tripRejected => _tripRejected;
  tripRejection(String id, String tripId, imageConfiguration) async {
    print('driver rejecting trip');
    await _socketService.rejectTrip(id: id, tripId: tripId);
    print('printing driver rejection status');
    _socketService.listenForSuccess();
    _tripRejected = false;
    // _driverHasArrived = true;
    // _tripHasStarted = false;
    // _tripHasEnded = false;
    resetApp(imageConfiguration);
    notifyListeners();
  }

  ///arrived rider location
  bool _driverHasArrived = false;
  bool get driverHasArrived => _driverHasArrived;
  arrivedPickup(String id, String tripId) async {
    print('arrival of driver');
    await _socketService.driverArrival(id: id, tripId: tripId);
    print('printing driver arrival status');
    _socketService.listenForSuccess();
    _driverHasArrived = true;
    _tripHasStarted = false;
    _tripHasEnded = false;
    _socketService.socket.on('SUCCESS', (data) {
      print('starting trip status from driver: $data');
      if (data == 'rider has been notified') {
        _driverHasArrived = true;
        _tripHasStarted = false;
        _tripHasEnded = false;
        return Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: AppColors.green.withOpacity(0.7),
            msg: data,
            gravity: ToastGravity.TOP,
            textColor: AppColors.black);
      } else {
        print('error from starting trip status from driver: $data');
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: data,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
      }
      notifyListeners();
    });
    // notifyListeners();
  }

  ///start trip
  bool _tripHasStarted = false;
  bool get tripHasStarted => _tripHasStarted;
  startRide(String id, String tripId) async {
    print('starting ride in provider');
    await _socketService.startTrip(id: id, tripId: tripId);
    print('starting ride response in provider');
    _socketService.listenForSuccess();
    _socketService.listenForError();
    _driverHasArrived = false;
    _tripHasStarted = true;
    _tripHasEnded = false;
    _socketService.socket.on('SUCCESS', (data) {
      print('starting trip status from driver: $data');
      if (data == 'Trip started successfully') {
        _driverHasArrived = false;
        _tripHasStarted = true;
        _tripHasEnded = false;
        return Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: AppColors.green.withOpacity(0.7),
            msg: data,
            gravity: ToastGravity.TOP,
            textColor: AppColors.black);
      } else {
        print('error from starting trip status from driver: $data');
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: data,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
      }
      notifyListeners();
    });
  }

  ///end trip
  bool _tripHasEnded = false;
  bool get tripHasEnded => _tripHasEnded;
  endRiderTrip(String id, String tripId) async {
    print('ending trip from provider');
    _socketService.endTrip(id: id, tripId: tripId);
    print('printing the success response for end trip in provider $id');
    _socketService.listenForTripEnd();
    print('printing the error response for end trip in provider $tripId');
    _socketService.listenForError();
    _driverHasArrived = false;
    _tripHasStarted = false;
    _tripHasEnded = true;
    _acceptedNewTripRequest = false;
    _newTripRequest = false;
    stopAutoDisplayDirectionsToPickup();
    _socketService.socket.on('TRIP_ENDED', (data) {
      print('ending trip status from driver: $data');
      if (data == 'Trip Ended Successfully') {
        return Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: AppColors.green.withOpacity(0.7),
            msg: data,
            gravity: ToastGravity.TOP,
            textColor: AppColors.black);
      } else {
        print('error from ending trip status from driver: $data');
        Fluttertoast.showToast(
            fontSize: 18,
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red.withOpacity(0.7),
            msg: 'data',
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
      }
    });
    notifyListeners();
  }

  ///trying new code
  final GoogleMapService _googleMapService = GoogleMapService();
  final PolylinePointService _polylinePointService = PolylinePointService();
  final MapService _mapService = MapService();
  final GeoLocationService _geoLocationService = GeoLocationService();

  // late List<double> _riderLocationCoordinates;
  // List<double> get riderLocationCoordinates => _riderLocationCoordinates;
  String? _etaTimer;
  String? get etaTimer => _etaTimer;
  String? _distance;
  String? get distance => _distance;

  /// Extracting coordinates from PointLatLng
  List<LatLng> extractPolylineCoordinates(List<PointLatLng> points) {
    return points
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  /// Displaying the directions from the driver location to the rider pickup location
  Future<void> displayDirectionsToPickup(ImageConfiguration imageConfiguration,
      double riderPickUpLat, double riderPickUpLon) async {
    try {
      // Get driver's current location
      var currentPosition = await _geoLocationService.getCurrentPosition(
        forceUseCurrentLocation: true,
        asPosition: true,
      );

      if (currentPosition == null) {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'Unable to fetch current position',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        return;
      }

      // Get rider's coordinates
      var pickup = LatLng(riderPickUpLat, riderPickUpLon);

      if (pickup.latitude == 0.0 || pickup.longitude == 0.0) {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'Invalid pickup coordinates',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        return;
      }

      // Fetch directions
      var directionsResponse = await _mapService.getDirection1(
        pickup: [currentPosition.latitude, currentPosition.longitude],
        destination: [pickup.latitude, pickup.longitude],
      );

      // Check if directionsResponse is valid
      if (directionsResponse == null || directionsResponse.isEmpty) {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'Unable to fetch directions',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        return;
      }

      if (directionsResponse['routes'].isEmpty) {
        Fluttertoast.showToast(
          fontSize: 18,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red.withOpacity(0.7),
          msg: 'No routes found',
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
        );
        return;
      }

      // Extract polyline points from the response
      final List<LatLng> polylineCoordinates =
          _polylinePointService.decodePolyPoints(
        directionsResponse['routes'][0]['overview_polyline']['points'],
      );

      // Clear previous map data
      _googleMapService.clearCircles();
      _googleMapService.clearMarkers();
      _googleMapService.clearPolyLines();
      _googleMapService.clearPolyLineCoordinate();

      // Update the map with the new polyline
      _googleMapService.setPolyLine(polylineCoordinates);
      _googleMapService.fitPolyLineToMap(
        pickup: [currentPosition.latitude, currentPosition.longitude],
        destination: [pickup.latitude, pickup.longitude],
      );

      // Create and add markers
      var driverMarker = _googleMapService.createMarker(
        id: 'pickup',
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        imageConfiguration: imageConfiguration,
      );
      var riderMarker = _googleMapService.createMarker(
        id: 'destination',
        position: pickup,
        imageConfiguration: imageConfiguration,
      );
      _googleMapService.addMarkers(driverMarker);
      _googleMapService.addMarkers(riderMarker);

      // Update ETA and distance
      final durationText =
          directionsResponse['routes'][0]['legs'][0]['duration']['text'];
      final distanceText =
          directionsResponse['routes'][0]['legs'][0]['distance']['text'];
      _etaTimer = durationText ?? 'Calculating';
      _distance = distanceText ?? 'Calculating';

      print('Time to get to the rider: $_etaTimer');

      notifyListeners();
    } catch (e) {
      print('Error in displayDirectionsToPickup: $e');
      Fluttertoast.showToast(
        fontSize: 18,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red.withOpacity(0.7),
        msg: 'An error occurred while fetching directions',
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
      );
    }
  }

  late Timer _refreshDirectionToPickUpLocationTimer;
  restartDisplayDirectionsToPickUp(imageConfiguration) {
    // Start a repeating timer that triggers every 2 seconds
    _refreshDirectionToPickUpLocationTimer =
        Timer.periodic(const Duration(seconds: 60), (timer) {
      // Call the refreshMap function to update the map and driver locations
      displayDirectionsToPickup(
          imageConfiguration, _riderPickUpLat!, _riderPickUpLon!);
    });
  }

  // Start the auto-refresh timer
  startAutoDisplayDirectionsToPickup(imageConfiguration) {
    restartDisplayDirectionsToPickUp(imageConfiguration);
  }

  //stop rider request timer
  stopAutoDisplayDirectionsToPickup() {
    if (_refreshDirectionToPickUpLocationTimer.isActive) {
      _refreshDirectionToPickUpLocationTimer.cancel();
    }
  }

  ///display the trip direction for the driver
  String? get tripEtaTimer => _tripEtaTimer;
  String? _tripEtaTimer;
  String? get tripDistance => _tripDistance;
  String? _tripDistance;
  late List _destinationCoordinates;
  List get destinationCoordinate => _destinationCoordinates;
  // displayDirectionForActivateTrip(imageConfiguration) async {
  //   // /// get rider pickup coordinates
  //   // var pickup = _googleMapService.convertDoubleToLatLng(
  //   //     _riderDestinationLat ?? 0.0, _riderDestinationLon ?? 0.0);
  //   //
  //   // /// get rider destination coordinate
  //   // var destination = _googleMapService.convertDoubleToLatLng(
  //   //     _riderPickUpLat ?? 0.0, _riderPickUpLon ?? 0.0);
  //   /// get rider pickup coordinates
  //   var pickup = [_riderDestinationLat ?? 0.0, _riderDestinationLon ?? 0.0];
  //
  //   /// get rider destination coordinate
  //   var destination = [_riderPickUpLat ?? 0.0, _riderPickUpLon ?? 0.0];
  //
  //   ///assign the destination location as lan and lng
  //   // var destinationLocationCoordinates = [destination.latitude, destination.longitude];
  //   //
  //   // _destinationCoordinates = destinationLocationCoordinates;
  //
  //   ///assign the rider location as lan and lng
  //   // var pickupCoordinates = [
  //   //   pickup.latitude,
  //   //   pickup.longitude,
  //   // ];
  //   // _riderLocationCoordinates = pickupCoordinates;
  //   if (pickup.isEmpty && destination.isEmpty) {
  //     return Fluttertoast.showToast(
  //         fontSize: 18,
  //         toastLength: Toast.LENGTH_LONG,
  //         backgroundColor: Colors.red.withOpacity(0.7),
  //         msg: 'no dest and pickup',
  //         gravity: ToastGravity.BOTTOM,
  //         textColor: Colors.white);
  //   }
  //
  //   /// Fetch directions using your API service (e.g., MapService)
  //   var directionsResponse = await _mapService.getDirection(
  //     pickup: pickup,
  //     destination: destination,
  //   );
  //   // var directionsResponse = await _mapService.getDirection(
  //   //   pickup: pickupCoordinates,
  //   //   destination: destinationLocationCoordinates,
  //   // );
  //
  //   if (directionsResponse != null) {
  //     print('Directions Response: $directionsResponse');
  //     if (directionsResponse == null) {
  //       print('The plotting is not working');
  //     } else if (directionsResponse.isNotEmpty &&
  //         directionsResponse.containsKey('routes') &&
  //         directionsResponse['routes'].isNotEmpty) {
  //       var route = directionsResponse['routes'][0];
  //       print('Route: $route');
  //       if (route.containsKey('overview_polyline')) {
  //         var overviewPolyline = route['overview_polyline'];
  //         print('Overview Polyline: $overviewPolyline');
  //         var points = overviewPolyline['points'];
  //         print('Points: $points');
  //       }
  //
  //       /// Extract polyline coordinates from the directions response
  //       final List<PointLatLng> pointLatLngList =
  //           _googleMapService.decodePolylines(
  //         directionsResponse['routes'][0]['overview_polyline']['points'],
  //       );
  //
  //       /// Convert List<PointLatLng> to List<LatLng>
  //       final List<LatLng> polylineCoordinates = pointLatLngList
  //           .map((point) => LatLng(point.latitude, point.longitude))
  //           .toList();
  //       _googleMapService.clearCircles();
  //       _googleMapService.clearMarkers();
  //       _googleMapService.clearPolyLines();
  //       _googleMapService.clearPolyLineCoordinate();
  //
  //       /// Update the map to display the polyline
  //       _googleMapService.setPolyLine(polylineCoordinates);
  //       _googleMapService.fitPolyLineToMap(
  //         pickup: pickup,
  //         // pickupCoordinates,
  //         destination: destination,
  //         // destinationLocationCoordinates,
  //       );
  //       LatLng convertPositionToLatLng(Position position) {
  //         return LatLng(position.latitude, position.longitude);
  //       }
  //
  //       // Marker originMarker = _googleMapService.createMarker(
  //       //   id: 'origin',
  //       //   position: pickup,
  //       //   imageConfiguration: imageConfiguration,
  //       //   // iconPath: 'assets/images/logo.png',
  //       // );
  //       // Marker destinationMarker = _googleMapService.createMarker(
  //       //   id: 'destination',
  //       //   position: destination,
  //       //   imageConfiguration: imageConfiguration,
  //       //   // icon: Icon(Icons.add),
  //       // );
  //       //
  //       // _googleMapService.addMarkers(originMarker);
  //       // _googleMapService.addMarkers(destinationMarker);
  //       //
  //       // Circle originCircle = Circle(
  //       //     circleId: CircleId('origin'),
  //       //     fillColor: Colors.green,
  //       //     radius: 12,
  //       //     strokeColor: Colors.white,
  //       //     strokeWidth: 3,
  //       //     center: pickup);
  //       //
  //       // Circle destinationCircle = Circle(
  //       //     circleId: CircleId('destination'),
  //       //     fillColor: Colors.black,
  //       //     radius: 12,
  //       //     strokeColor: Colors.white,
  //       //     strokeWidth: 3,
  //       //     center: pickup);
  //       // _googleMapService.addCircle(originCircle);
  //       // _googleMapService.addCircle(destinationCircle);
  //       notifyListeners();
  //
  //       final durationText =
  //           directionsResponse['routes'][0]['legs'][0]['duration']['text'];
  //       final distanceText =
  //           directionsResponse['routes'][0]['legs'][0]['distance']['text'];
  //       // final etaTimer1 =
  //       //     int.parse(RegExp(r"(\d+)").stringMatch(durationText) ?? '0');
  //
  //       // _tripDistance = distanceText;
  //       // _etaTimer1 = etaTimer1.toString();
  //       _tripEtaTimer = durationText ?? 'Calculating';
  //       _tripDistance = distanceText ?? 'Calculating';
  //       print('this is the time fro the rider trip: $_tripEtaTimer');
  //       print('this is the distance to the rider destination: $_tripDistance');
  //       notifyListeners();
  //     } else {
  //       print('No routes in directions response');
  //     }
  //
  //     /// Extract polyline coordinates from the directions response
  //     final List<PointLatLng> pointLatLngList =
  //         _googleMapService.decodePolylines(
  //       directionsResponse['routes'][0]['overview_polyline']['points'],
  //     );
  //
  //     /// Convert List<PointLatLng> to List<LatLng>
  //     final List<LatLng> polylineCoordinates = pointLatLngList
  //         .map((point) => LatLng(point.latitude, point.longitude))
  //         .toList();
  //     _googleMapService.clearCircles();
  //     _googleMapService.clearMarkers();
  //     _googleMapService.clearPolyLines();
  //     _googleMapService.clearPolyLineCoordinate();
  //
  //     /// Update the map to display the polyline
  //     _googleMapService.setPolyLine(polylineCoordinates);
  //     _googleMapService.fitPolyLineToMap(
  //       pickup: pickup,
  //       // pickupCoordinates,
  //       destination: destination,
  //       // destinationLocationCoordinates,
  //     );
  //     LatLng convertPositionToLatLng(Position position) {
  //       return LatLng(position.latitude, position.longitude);
  //     }
  //
  //     // Marker originMarker = _googleMapService.createMarker(
  //     //   id: 'origin',
  //     //   position: pickup,
  //     //   imageConfiguration: imageConfiguration,
  //     //   // iconPath: 'assets/images/logo.png',
  //     // );
  //     // Marker destinationMarker = _googleMapService.createMarker(
  //     //   id: 'destination',
  //     //   position: destination,
  //     //   imageConfiguration: imageConfiguration,
  //     //   // icon: Icon(Icons.add),
  //     // );
  //     //
  //     // _googleMapService.addMarkers(originMarker);
  //     // _googleMapService.addMarkers(destinationMarker);
  //     //
  //     // Circle originCircle = Circle(
  //     //     circleId: CircleId('origin'),
  //     //     fillColor: Colors.green,
  //     //     radius: 12,
  //     //     strokeColor: Colors.white,
  //     //     strokeWidth: 3,
  //     //     center: pickup);
  //     //
  //     // Circle destinationCircle = Circle(
  //     //     circleId: CircleId('destination'),
  //     //     fillColor: Colors.black,
  //     //     radius: 12,
  //     //     strokeColor: Colors.white,
  //     //     strokeWidth: 3,
  //     //     center: pickup);
  //     // _googleMapService.addCircle(originCircle);
  //     // _googleMapService.addCircle(destinationCircle);
  //     notifyListeners();
  //
  //     final durationText =
  //         directionsResponse['routes'][0]['legs'][0]['duration']['text'];
  //     final distanceText =
  //         directionsResponse['routes'][0]['legs'][0]['distance']['text'];
  //     // final etaTimer1 =
  //     //     int.parse(RegExp(r"(\d+)").stringMatch(durationText) ?? '0');
  //
  //     // _tripDistance = distanceText;
  //     // _etaTimer1 = etaTimer1.toString();
  //     _tripEtaTimer = durationText ?? 'Calculating';
  //     _tripDistance = distanceText ?? 'Calculating';
  //     print('this is the time fro the rider trip: $_tripEtaTimer');
  //     print('this is the distance to the rider destination: $_tripDistance');
  //     notifyListeners();
  //   } else {
  //     print('No routes in directions response');
  //   }
  // }

  // ///refresh connect rider code
  // late Timer _refreshDirectionToDestinationLocationTimer;
  // restartDisplayDirectionsToDestination(imageConfiguration) {
  //   // Start a repeating timer that triggers every 2 seconds
  //   _refreshDirectionToDestinationLocationTimer =
  //       Timer.periodic(const Duration(seconds: 60), (timer) {
  //     // Call the refreshMap function to update the map and driver locations
  //         displayDirectionsToPickup(imageConfiguration, _riderDestinationLat!, _riderDestinationLon!);
  //   });
  // }
  //
  // // Start the auto-refresh timer
  // startAutoDisplayDirectionsToPickup(imageConfiguration) {
  //   restartDisplayDirectionsToDestination(imageConfiguration);
  // }
  //
  // //stop rider request timer
  // stopAutoDisplayDirectionsToPickup() {
  //   if (_refreshDirectionToDestinationLocationTimer.isActive) {
  //     _refreshDirectionToDestinationLocationTimer.cancel();
  //   }
  // }

  ///reset app to default
  resetApp(imageConfiguration) async {
    _googleMapService.clearPolyLines();
    _googleMapService.clearPolyLineCoordinate();
    _googleMapService.clearMarkers();
    _googleMapService.clearCircles();
    _driverHasArrived = false;
    _tripHasStarted = false;
    _tripHasEnded = false;
    _newTripRequest = false;
    _acceptedNewTripRequest = false;
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
    stopAutoDisplayDirectionsToPickup();
    listenForRideRequests(imageConfiguration);
    notifyListeners();
  }
}
