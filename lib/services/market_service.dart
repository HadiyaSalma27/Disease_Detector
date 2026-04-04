import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketService {

  static Future<Map<String, dynamic>?> getMarketData(String lang) async {

    final url = Uri.parse("https://agri-backend-jx81.onrender.com/api/market-analysis");

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