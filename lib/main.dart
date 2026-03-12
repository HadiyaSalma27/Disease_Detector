import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'services/disease_info_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Load disease dataset before app starts
  await DiseaseInfoService.loadDiseaseData();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tomato Disease Detection",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}
