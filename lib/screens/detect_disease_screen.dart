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

  // CAMERA
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

  // GALLERY
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

  // REMOVE IMAGE
  void removeImage() {

    setState(() {
      selectedImage = null;
      result = "";
      diseaseInfo = null;
    });

  }

  // PREDICTION
  void predict(String lang) async {

    if (!modelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Model is still loading..."),
        ),
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

      print("Prediction from model: $prediction");

      /* CLEAN MODEL OUTPUT
      String cleanPrediction = prediction
          .replaceAll("Tomato___", "")
          .replaceAll("Tomato_", "")
          .replaceAll("_", " ");

      print("Cleaned disease name: $cleanPrediction");*/

      // GET DATA FROM JSON
      diseaseInfo =
          DiseaseInfoService.getDiseaseInfo(prediction);

      setState(() {

        result = prediction;

        isLoading = false;

      });

    } catch (e) {

      print("Prediction error: $e");

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

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          AppStrings.text("detect_disease", lang),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// IMAGE PREVIEW WITH CLOSE BUTTON
            if (selectedImage != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Stack(
                  children: [

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(15),
                      child: Image.file(
                        selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      right: 10,
                      top: 10,
                      child: InkWell(
                        onTap: removeImage,
                        child: const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            /// CAMERA & GALLERY BUTTONS
            Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.camera),
                    label: Text(
                      AppStrings.text("camera", lang),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: pickCamera,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: Text(
                      AppStrings.text("gallery", lang),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: pickGallery,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            /// PREDICT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => predict(lang),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  AppStrings.text("predict_disease", lang),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LOADING
            if (isLoading)
              const CircularProgressIndicator(),

            const SizedBox(height: 20),

            /// RESULT
            if (result.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// DISEASE INFORMATION
            if (diseaseInfo != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Features: ${diseaseInfo!['features'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Cause: ${diseaseInfo!['cause'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Prevention: ${diseaseInfo!['prevention'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Cure: ${diseaseInfo!['cure'] ?? 'N/A'}",
                        style: const TextStyle(fontSize: 16),
                      ),

                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }
}