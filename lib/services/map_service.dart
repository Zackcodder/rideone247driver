import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as https;

class MapService {
  static String mapKey = 'AIzaSyB4CbrtiWbGJoVp4D9eAgV9boaAI0kkCwA';

  Future getDirections({
    required List<double> pickup, // [latitude,longitude]
    required List<double> destination, // [latitude,longitude]
  }) async {
    final api =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$pickup&destination=$destination&mode=driving&key=$mapKey';
    // "https://maps.googleapis.com/maps/api/directions/json?origin=${pickup[0]},${pickup[1]}&destination=${destination[0]},${destination[1]}&mode=driving&key=$mapKey";

    final res = await https.get(Uri.parse(api));

    if (res.statusCode == 200) {
      final response = json.decode(res.body);
      print('this is the direction result');
      print(response);
      return response;
    }
    return res;
  }

  Future<Map<String, dynamic>> getDirection({
    required List<double> pickup, // [latitude,longitude]
    required List<double> destination,
  }) async {
    String pickupString = pickup.join(',');
    String destinationString = destination.join(',');

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$pickupString&destination=$destinationString&mode=driving&key=$mapKey';
    var response = await https.get(Uri.parse(url));
    final responseData = jsonDecode(response.body);

    var json = convert.jsonDecode(response.body);
    var results = {
      // 'bound_ne': json['routes'][0]['bounds']['northeast'],
      // 'bound_sw': json['routes'][0]['bounds']['southwest'],
      // 'start_location': json['routes'][0]['legs'][0]['start_location'],
      // 'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points'])
    };
    print('direction 000000000000000 888');
    print(results);
    return results;
  }

  /// tring new code
  Future<Map<String, dynamic>?> getDirection1({
    required List<double> pickup, // [latitude, longitude]
    required List<double> destination, // [latitude, longitude]
  }) async {
    final api = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${pickup[0]},${pickup[1]}'
        '&destination=${destination[0]},${destination[1]}'
        '&mode=driving&key=$mapKey';

    final res = await https.get(Uri.parse(api));

    if (res.statusCode == 200) {
      final response = json.decode(res.body);
      print('this is the direction result');
      print(response);
      return response;
    } else {
      print('Failed to fetch directions: ${res.statusCode}');
      return null;
    }
  }

  ///
}
