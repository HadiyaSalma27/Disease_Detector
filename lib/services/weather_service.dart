import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {

  static const String apiKey = "6a2b2892d61a6df0daf190fd653d3b9c";

  static Future<Map<String, dynamic>> getWeather(
      double latitude, double longitude) async {

    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {

      throw Exception("Failed to load weather data");

    }
  }
}






 //"6a2b2892d61a6df0daf190fd653d3b9c";

  