import 'package:aj_autofix/screens/home.dart';
import 'package:aj_autofix/screens/login_screen.dart';
import 'package:aj_autofix/screens/onboaring_screen.dart';
import 'package:aj_autofix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(); 

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _checkOnboardingAndLoginStatus();
  }

  Future<void> _checkOnboardingAndLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
   
    String? accessToken = await _secureStorage.read(key: 'access_token');

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
      
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (accessToken != null) {
                return const Home();
              } else {
                return hasSeenOnboarding
                    ? const LoginScreen() 
                    : const OnBoardingScreen(); 
              }
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: kGradientBoxDecoration,
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}
