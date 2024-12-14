import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skytrack_app/model/weather.dart';

class WeatherService {
  final String apiKey = "071d751da5d2479daaa134257241112";

  Future<Weather?> fetchWeatherByCoordinates(double latitude, double longitude) async {
    final String _apiUrl =
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=7";

    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> weatherMap = json.decode(response.body);
        return Weather.fromMap(weatherMap);
      } else {
        print("API Hatası: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }
}