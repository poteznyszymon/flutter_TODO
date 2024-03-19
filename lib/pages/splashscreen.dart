import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1600,
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset('assets/animation.json'),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      splashIconSize: 300,
      backgroundColor: Colors.white,
    );
  }
}
