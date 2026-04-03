import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';
import '../services/tflite_service.dart';
import '../services/disease_info_service.dart';

class DetectDiseaseScreen extends StatefulWidget {
  const DetectDiseaseScreen({super.key});

  @override
  State<DetectDiseaseScreen> createState() =>
      _DetectDiseaseScreenState();
}

class _DetectDiseaseScreenState extends State<DetectDiseaseScreen> {

  File? selectedImage;
  final picker = ImagePicker();

  final TFLiteService _tfliteService = TFLiteService();

  String result = "";
  Map<String, dynamic>? diseaseInfo;

  bool isLoading = false;
  bool modelLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    bool loaded = await _tfliteService.loadModel();
    setState(() {
      modelLoaded = loaded;
    });
  }

  Future pickCamera() async {
    final picked =
        await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        result = "";
        diseaseInfo = null;
      });
    }
  }

  Future pickGallery() async {
    final picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        result = "";
        diseaseInfo = null;
      });
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
      result = "";
      diseaseInfo = null;
    });
  }

  void predict(String lang) async {

    if (!modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Model is still loading...")),
      );
      return;
    }

    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.text("select_image", lang),
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      result = "";
      diseaseInfo = null;
    });

    try {

      String prediction =
          await _tfliteService.predict(selectedImage!);

      diseaseInfo =
          DiseaseInfoService.getDiseaseInfo(prediction);

      setState(() {
        result = prediction;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        result = "Prediction Failed";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    String lang =
        Provider.of<LanguageProvider>(context)
            .languageCode;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(AppStrings.text("detect_disease", lang)),
      ),

      body: Stack(
        children: [

          /// 🌿 Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/detectscreen.avif",
              fit: BoxFit.cover,
            ),
          ),

          /// Overlay
         Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          /// CONTENT
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const SizedBox(height: 20),

                /// Image Preview
                if (selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 20),

                /// Buttons
                Row(
                  children: [

                    Expanded(
                      child: actionButton(
                        text: AppStrings.text("camera", lang),
                        icon: Icons.camera_alt,
                        color: Colors.green,
                        onTap: pickCamera,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: actionButton(
                        text: AppStrings.text("gallery", lang),
                        icon: Icons.image,
                        color: Colors.blue,
                        onTap: pickGallery,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Predict Button
                actionButton(
                  text: AppStrings.text("predict_disease", lang),
                  icon: Icons.search,
                  color: Colors.red,
                  onTap: () => predict(lang),
                ),

                const SizedBox(height: 20),

                /// Loading
                if (isLoading)
                  const CircularProgressIndicator(),

                const SizedBox(height: 20),

                /// Result Card
                if (result.isNotEmpty)
                  glassCard(
                    child: Text(
                      diseaseInfo?['name']?[lang] ?? result,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                /// Disease Info Card
                if (diseaseInfo != null)
                  glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        infoText("Features", diseaseInfo!['features']?[lang]),
                        infoText("Cause", diseaseInfo!['cause']?[lang]),
                        infoText("Prevention", diseaseInfo!['prevention']?[lang]),
                        infoText("Cure", diseaseInfo!['cure']?[lang]),

                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  Widget actionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////

  Widget glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  ////////////////////////////////////////////////////////////

  Widget infoText(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        "$title: ${value ?? 'N/A'}",
        style: const TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }
}