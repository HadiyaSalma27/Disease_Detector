import 'location_service.dart';
import 'weather_service.dart';
import 'weather_disease_predictor.dart';
import 'notification_service.dart';

class WeatherAlertService {

  static Future checkWeatherDiseaseRisk() async {

    try {

      print("Weather check button pressed");

      final position = await LocationService.getLocation();

      print("Location obtained:");
      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");

      final weather = await WeatherService.getWeather(
        position.latitude,
        position.longitude,
      );

      print("Weather API response received");

      // 🔧 FIX: convert to double
      double temperature = (weather["main"]["temp"] as num).toDouble();
      double humidity = (weather["main"]["humidity"] as num).toDouble();

      double rainfall = 0;

      if (weather.containsKey("rain")) {
        rainfall = (weather["rain"]["1h"] ?? 0).toDouble();
      }

      print("Temperature: $temperature");
      print("Humidity: $humidity");
      print("Rainfall: $rainfall");

      String prediction =
          WeatherDiseasePredictor.predictDiseaseRisk(
              temperature,
              humidity,
              rainfall);

      print("AI Prediction: $prediction");

      await NotificationService.showNotification(
        "Tomato Disease Weather Alert",
        prediction,
      );

      print("Notification sent successfully");

    } catch (e) {

      print("Weather alert error: $e");

    }

  }
}