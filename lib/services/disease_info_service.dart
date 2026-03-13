import 'dart:convert';
import 'package:flutter/services.dart';

class DiseaseInfoService {

  static Map<String, dynamic> _diseaseData = {};

  /// Load JSON when app starts
  static Future<void> loadDiseaseData() async {

    String jsonString =
        await rootBundle.loadString('assets/disease_info.json');

    _diseaseData = json.decode(jsonString);
  }

  /// Get disease information
  static Map<String, dynamic>? getDiseaseInfo(String diseaseName) {

    if (_diseaseData.containsKey(diseaseName)) {
      return _diseaseData[diseaseName];
    }

    return null;
  }
}