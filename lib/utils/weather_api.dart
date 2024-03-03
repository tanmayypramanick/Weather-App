import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/weather_model.dart';

class WeatherApi {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String geoBaseUrl = 'http://api.openweathermap.org/geo/1.0/direct';

  WeatherApi(this.apiKey);

  Future<Map<String, dynamic>> getCoordinates(String location) async {
    final Uri uri = Uri.parse('$geoBaseUrl?q=$location&limit=1&appid=$apiKey');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return {'lat': data[0]['lat'], 'lon': data[0]['lon']};
      } else {
        throw Exception('Location not found');
      }
    } else {
      throw Exception(
          'Failed to get coordinates. Status code: ${response.statusCode}');
    }
  }

  Future<WeatherModel> getWeatherFromCoordinates(double lat, double lon) async {
    final Uri uri =
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load weather data. Status code: ${response.statusCode}');
    }
  }

  Future<WeatherModel> getWeatherFromLocationName(String location) async {
    try {
      final coordinates = await getCoordinates(location);
      return await getWeatherFromCoordinates(
          coordinates['lat'], coordinates['lon']);
    } catch (e) {
      throw Exception(
          'Failed to load weather data for $location: ${e.toString()}');
    }
  }
}
