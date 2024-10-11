import 'package:aj_autofix/screens/intro_screens/intro_page1.dart';
import 'package:aj_autofix/screens/intro_screens/intro_page2.dart';
import 'package:aj_autofix/screens/intro_screens/intro_page3.dart';
import 'package:aj_autofix/screens/intro_screens/intro_page4.dart';
import 'package:aj_autofix/screens/intro_screens/intro_page5.dart';
import 'package:aj_autofix/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> completeOnboarding() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
    } catch (e) {
      debugPrint("Error saving onboarding completion: $e");
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 4); 
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
              IntroPage4(),
              IntroPage5()
            ],
          ),
          _buildSkipButton(),
          _buildNextOrDoneButton(),
          _buildPageIndicator(),
        ],
      ),
    );
  }

  Widget _buildSkipButton() {
    return Align(
      alignment: const Alignment(-0.8, 0.88),
      child: TextButton(
        onPressed: () {
          _controller.jumpToPage(4);
        },
        child: const Text("Skip",
            style: TextStyle(
              color: kMainColor,
              fontSize: 18.0,
            fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildNextOrDoneButton() {
    return Align(
      alignment: const Alignment(0.8, 0.88),
      child: TextButton(
        onPressed: () {
          if (onLastPage) {
            completeOnboarding();
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          }
        },
        child: Text(onLastPage ? "Done" : "Next",
            style: const TextStyle(
              color: kMainColor,
              fontSize: 18.0,
            fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Align(
      alignment: const Alignment(0, 0.85),
      child: SmoothPageIndicator(
        controller: _controller,
        count: 5,
        effect: const WormEffect(),
      ),
    );
  }
}
