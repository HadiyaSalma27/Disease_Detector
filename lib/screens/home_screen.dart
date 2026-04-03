import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../l10n/app_strings.dart';
import 'market_analysis_screen.dart';
import 'detect_disease_screen.dart';
import 'profile_screen.dart';
import 'help_screen.dart';
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

  if (index == _selectedIndex) return;

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
        builder: (_) => const HelpScreen(),
      ),
    );
  }

  // Keep home selected always when returning
  setState(() {
    _selectedIndex = 1;
  });
}

  @override
  Widget build(BuildContext context) {

    final languageProvider = Provider.of<LanguageProvider>(context);
    String lang = languageProvider.languageCode;

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
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
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }

              if (value == "signup") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
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
              /*PopupMenuItem(
                value: "help",
                child: Text(AppStrings.text("help", lang)),
              ),*/
            ],
          )
        ],
      ),

      // 🔥 FULL SCREEN BACKGROUND
      body: Stack(
        children: [

          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/bgimg.webp",
              fit: BoxFit.cover,
            ),
          ),

          /// Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  AppStrings.text("home_title", lang),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                /// Detect Disease Button
                AnimatedButton(
                  text: AppStrings.text("detect_disease", lang),
                  color: Colors.green,
                  icon: Icons.camera_alt,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetectDiseaseScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                /// Weather Button
                AnimatedButton(
                  text: AppStrings.text("check_weather_disease_risk", lang),
                  color: Colors.orange,
                  icon: Icons.cloud,
                  onTap: () async {
                    await WeatherAlertService.checkWeatherDiseaseRisk();
                  },
                ),
                 const SizedBox(height: 20),

/// Market Analysis Button
              AnimatedButton(
                text: AppStrings.text("market_analysis", lang),  // later AppStrings add ചെയ്യാം
                color: Colors.blue,
                icon: Icons.show_chart,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MarketAnalysisScreen(),
                    ),
                  );
                },
              ),
              ],
            ),
          ),
        ],
      ),
           

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
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
            icon: const Icon(Icons.help_outline),
            label: AppStrings.text("help", lang),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// 🔥 CUSTOM ANIMATED BUTTON
////////////////////////////////////////////////////////////

class AnimatedButton extends StatefulWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {

  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTapDown: (_) {
        setState(() => scale = 0.95);
      },

      onTapUp: (_) {
        setState(() => scale = 1);
        widget.onTap();
      },

      onTapCancel: () {
        setState(() => scale = 1);
      },

      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),

        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.6),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(widget.icon, color: Colors.white),

              const SizedBox(width: 10),

              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}