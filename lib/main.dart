import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/language_provider.dart';
import 'screens/home_screen.dart';

import 'services/disease_info_service.dart';
import 'services/notification_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();

  /// Load disease dataset from JSON
  await DiseaseInfoService.loadDiseaseData();

  /// Initialize notification service
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => LanguageProvider(),

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: "AI Farming Assistant",

        theme: ThemeData(
          primarySwatch: Colors.green,
        ),

        home: const HomeScreen(),

      ),
    );
  }
}