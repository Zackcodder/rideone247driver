class Trip {
  final String id;
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

  Trip({
    required this.id,
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
  });

  // Add a factory method to convert JSON data to a Trip object
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['tripId'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
      cost: json['cost'] ?? 0,
      rating: json['rating'] ?? 0.0,
      date: json['date'] ?? '',
      pickUpLon: json['pickUpLon'] ?? 0.0,
      pickUpLat: json['pickUpLat'] ?? 0.0,
      dropOffLon: json['dropOffLon'] ?? 0.0,
      dropOffLat: json['dropOffLat'] ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      dispatch: json['dispatch'] ?? false,
    );
  }
}
