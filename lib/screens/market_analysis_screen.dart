import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/market_service.dart';

class MarketAnalysisScreen extends StatefulWidget {
  const MarketAnalysisScreen({super.key});

  @override
  State<MarketAnalysisScreen> createState() => _MarketAnalysisScreenState();
}

class _MarketAnalysisScreenState extends State<MarketAnalysisScreen> {

  Map<String, dynamic>? data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {

    String lang =
        Provider.of<LanguageProvider>(context, listen: false)
            .languageCode;

    setState(() {
      isLoading = true;
    });

    final result = await MarketService.getMarketData(lang);

    setState(() {
      data = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Analysis"),
        backgroundColor: Colors.green,
      ),

      body: Stack(
        children: [

          /// 🌿 Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/market_bg.jpeg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          /// 🔥 FIXED FULL HEIGHT CONTENT
          SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : data == null
                      ? const Center(child: Text("No data"))
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 📊 DATA CARD
                              glassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    infoRow("🌱 Crop", data!['crop']),
                                    infoRow("🏬 Market", data!['market']),
                                    infoRow("📍 State", data!['state']),
                                    infoRow("💰 Price", "₹${data!['price']}"),
                                    infoRow("📈 Trend", data!['trend']),
                                    infoRow("🔮 Predicted", "₹${data!['predictedPrice']}"),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// 🤖 AI Advice Card
                              glassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    const Text(
                                      "🤖 AI Advice",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      data!['advice'] ?? "",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              /// ⚠️ NOTE
                              if (data!['note'] != null &&
                                  data!['note'].toString().isNotEmpty)
                                glassCard(
                                  child: Text(
                                    data!['note'],
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  Widget glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  ////////////////////////////////////////////////////////////

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        "$title: $value",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}