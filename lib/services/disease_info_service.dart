import 'dart:convert';
import 'package:flutter/services.dart';

class DiseaseInfoService {

  static Map<String, dynamic> _diseaseData = {};

  // Load JSON file
  static Future<void> loadDiseaseData() async {

    try {

      final String jsonString =
          await rootBundle.loadString('assets/disease_info.json');

      _diseaseData = json.decode(jsonString);

      print("Disease dataset loaded successfully");

    } catch (e) {

      print("Error loading disease dataset: $e");

    }
  }

  // Get disease information
  static Map<String, dynamic>? getDiseaseInfo(String diseaseName) {

    // Remove prefix if model returns it
    String cleanName =
        diseaseName.replaceAll("Tomato___", "");

    return _diseaseData[cleanName];
  }

}