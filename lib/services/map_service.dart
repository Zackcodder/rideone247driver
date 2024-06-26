import 'dart:convert';
import 'package:http/http.dart' as https;

class MapService {
  static String mapKey = 'AIzaSyB4CbrtiWbGJoVp4D9eAgV9boaAI0kkCwA';
  Future<Map<String, dynamic>?> getDirection1({
    required List<double> pickup,
    required List<double> destination,
  }) async {
    final api = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${pickup[0]},${pickup[1]}'
        '&destination=${destination[0]},${destination[1]}'
        '&mode=driving&key=$mapKey';

    final res = await https.get(Uri.parse(api));

    if (res.statusCode == 200) {
      final response = json.decode(res.body);
      print('Direction result: $response');
      return response;
    } else {
      print('Failed to fetch directions: ${res.statusCode}');
      return null;
    }
  }
}
