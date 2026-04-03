import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {

  static Future<Map<String, dynamic>?> getMarketData(String lang) async {

    final url = Uri.parse("http://192.168.1.4:3000/api/market-analysis");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "crop": "Tomato",
        "location": "Kerala",
        "language": lang   // 🔥 important
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}