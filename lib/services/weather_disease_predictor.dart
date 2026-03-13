class WeatherDiseasePredictor {

  static String predictDiseaseRisk(
      double temperature,
      double humidity,
      double rainfall) {

    if (temperature >= 15 &&
        temperature <= 25 &&
        humidity > 80 &&
        rainfall > 0) {

      return "High risk of Late Blight due to cool and humid weather.";
    }

    if (humidity > 85 && temperature >= 20) {

      return "High humidity may cause Leaf Mold disease.";
    }

    if (temperature > 30 && humidity < 40) {

      return "Hot and dry weather may lead to Spider Mites infestation.";
    }

    if (temperature > 25 && humidity > 70) {

      return "Warm humid weather may cause Bacterial Spot disease.";
    }

    return "Weather conditions look safe for tomato plants.";
  }
}