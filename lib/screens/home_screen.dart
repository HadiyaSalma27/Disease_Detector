import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';

import 'detect_disease_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

import '../services/weather_alert_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 1;

  void _onItemTapped(int index) {

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(),
        ),
      );
    }

    else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NotificationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final languageProvider = Provider.of<LanguageProvider>(context);
    String lang = languageProvider.languageCode;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 2,
        centerTitle: true,

        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: lang,
            dropdownColor: Colors.white,
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.black),
            items: const [
              DropdownMenuItem(value: "en", child: Text("English")),
              DropdownMenuItem(value: "ml", child: Text("Malayalam")),
            ],
            onChanged: (value) {
              languageProvider.changeLanguage(value!);
            },
          ),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (value) {

              if (value == "login") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              }

              if (value == "signup") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [

              PopupMenuItem(
                value: "login",
                child: Text(AppStrings.text("login", lang)),
              ),

              PopupMenuItem(
                value: "signup",
                child: Text(AppStrings.text("signup", lang)),
              ),

              PopupMenuItem(
                value: "logout",
                child: Text(AppStrings.text("logout", lang)),
              ),

              PopupMenuItem(
                value: "help",
                child: Text(AppStrings.text("help", lang)),
              ),
            ],
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 30),

              Text(
                AppStrings.text("home_title", lang),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Image.asset(
                "assets/images/tomato_plant.png",
                height: 500,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              /// Detect Disease
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetectDiseaseScreen(),
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.text("detect_disease", lang),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Weather AI Alert
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    await WeatherAlertService.checkWeatherDiseaseRisk();
                  },
                  child: const Text(
                    "Check Weather Disease Risk",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [

          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppStrings.text("profile", lang),
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppStrings.text("home", lang),
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: AppStrings.text("notification", lang),
          ),
        ],
      ),
    );
  }
}