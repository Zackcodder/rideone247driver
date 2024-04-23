class Trip {
  final String tripId;
  final String start;
  final String end;
  final String date;
  final double pickUpLon;
  final double pickUpLat;
  final double dropOffLon;
  final double dropOffLat;
  final double rating;
  final int cost;
  final String paymentMethod;
  final bool dispatch;
  final String riderId;
  final String driverId;
  final String riderName;
  final String riderTripId;
  final double riderPickupLon;
  final double riderPickupLat;
  final String riderPickUpName;
  final String riderDestinationName;
  final double riderDropOffLat;
  final double riderDropOffLon;
  final String riderPaymentMethod;


  Trip({
    required this.tripId,
    required this.start,
    required this.end,
    required this.pickUpLon,
    required this.pickUpLat,
    required this.dropOffLon,
    required this.dropOffLat,
    required this.cost,
    required this.date,
    required this.rating,
    required this.paymentMethod,
    required this.dispatch,
    required this.riderId,
    required this.driverId,
    required this.riderName,
    required this.riderDropOffLat,
    required this.riderDropOffLon,
    required this.riderDestinationName,
    required this.riderPaymentMethod,
    required this.riderPickupLat,
    required this.riderPickupLon,
    required this.riderPickUpName,
    required this.riderTripId,
  });

  // Add a factory method to convert JSON data to a Trip object
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['tripId'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      cost: json['fare'] ?? 0,
      rating: json['rating'] ?? 0.0,
      date: json['date'] ?? '',
      pickUpLon: json['pickUpLon'] ?? 0.0,
      pickUpLat: json['pickUpLat'] ?? 0.0,
      riderPickUpName: json['pickOff'] ?? '',
      dropOffLon: json['dropOffLon'] ?? 0.0,
      dropOffLat: json['dropOffLat'] ?? 0.0,
      riderDestinationName: json['dropOff'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      riderId: json['riderId'] ?? '',
      driverId: json['driverId'] ?? '',
      dispatch: json['dispatch'] ?? false,
      riderName: json['riderName'] ?? '',
      riderTripId: json['tripId'] ?? '',
      riderDropOffLat: json['dropOffLat'] ?? 0.0,
      riderDropOffLon: json['dropOffLon'] ?? 0.0,
      riderPaymentMethod: json['paymentMethod'] ??'',
      riderPickupLat: json['pickUpLat'] ?? 0.0,
      riderPickupLon: json['pickUpLon'] ?? 0.0,
    );
  }
}
