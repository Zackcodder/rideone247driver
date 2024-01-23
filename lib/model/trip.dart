// trip.dart
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
      id: json['id'],
      start: json['start'],
      end: json['end'],
      cost: json['cost'],
      rating: json['rating'],
      date: json['date'],
      pickUpLon: json['pickUpLon'],
      pickUpLat: json['pickUpLat'],
      dropOffLon: json['dropOffLon'],
      dropOffLat: json['dropOffLat'],
      paymentMethod: json['paymentMethod'],
      dispatch: json['dispatch'],
    );
  }
}
