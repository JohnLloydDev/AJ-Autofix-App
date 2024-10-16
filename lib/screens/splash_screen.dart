import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_bloc.dart';
import 'package:aj_autofix/bloc/auth/auth_state.dart';
import 'package:aj_autofix/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _checkOnboardingAndLoginStatus();
  }

  Future<void> _checkOnboardingAndLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    String? accessToken = await _secureStorage.read(key: 'access_token');
    if (!mounted) return;

    if (accessToken != null) {
      final authState = context.read<AuthBloc>().state;

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            if (authState is AuthSuccessWithRole) {
              if (authState.role == 'admin') {
                GoRouter.of(context).go('/adminScreen');
              } else if (authState.role == 'user') {
                GoRouter.of(context).go('/mainscreen');
              }
            } else {
              GoRouter.of(context).go('/mainscreen');
            }
          }
        }
      });
    } else {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            if (hasSeenOnboarding) {
              GoRouter.of(context).go('/login');
            } else {
              GoRouter.of(context).go('/onboarding');
            }
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/logo.png',
              width: 300,
              height: 300,
            ),
          ),
        ),
      ),
    );
  }
}
