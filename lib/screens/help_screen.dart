import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final languageProvider = Provider.of<LanguageProvider>(context);
    String lang = languageProvider.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.text("help", lang)),
        backgroundColor: Colors.green,
      ),

      body: Stack(
        children: [

          /// 🌿 Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/bgimg.webp",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

          /// CONTENT
          SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  glassCard(
                    title: "💡 ${AppStrings.text("how_to_use", lang)}",
                    content: AppStrings.text("how_to_use_desc", lang),
                  ),

                  glassCard(
                    title: "📸 ${AppStrings.text("upload_image", lang)}",
                    content: AppStrings.text("upload_image_desc", lang),
                  ),

                  glassCard(
                    title: "📈 ${AppStrings.text("market_help", lang)}",
                    content: AppStrings.text("market_help_desc", lang),
                  ),

                  glassCard(
                    title: "❓ ${AppStrings.text("faq", lang)}",
                    content: AppStrings.text("faq_desc", lang),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  Widget glassCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            content,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}