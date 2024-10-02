import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:palm_pulse/screens/home_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.amber,Colors.brown],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

          )
        ),
        child: const Column(
          children: [
            SplashAnim(),


          ],
        ),
      ),
    );
  }
}

class SplashAnim extends StatelessWidget {
  const SplashAnim({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: LottieBuilder.asset(
                'assets/palmpluse.json',
              ),
            ),
            const SizedBox(height: 2), // إضافة مساحة بين الشعار والنص
            const Text(
              'نبض النخيل',
              style: TextStyle(
                fontSize: 24, // حجم النص
                fontWeight: FontWeight.bold, // سمك النص
                color: Colors.white, // لون النص
              ),
            ),
          ],
        ),
      ),
      nextScreen: const HomeScreen(),
      splashIconSize: 450,
      duration: 3500,
      backgroundColor: Color(0xff156E5C),
    );
  }
}
