import 'package:flutter/material.dart';
import 'dart:async';
<<<<<<< HEAD
import 'package:flutter/foundation.dart';

=======
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
import '../../core/theme/color.dart';
import '../../widgets/app_background.dart';
import '../../screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';
import '../../screens/splash/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

<<<<<<< HEAD
  User? _user; 

=======
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

<<<<<<< HEAD
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _initUserAndNavigate();
  }

  void _initUserAndNavigate() {
    
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      
      if (!kDebugMode) {
        _user = FirebaseAuth.instance.currentUser;
      }

      
      if (_user != null) {
=======
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();

    /*Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });*/
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ✅ User already logged in
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
<<<<<<< HEAD
=======
        // ✅ Go to Role Selection Screen
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
<<<<<<< HEAD
        useImage: true,
=======
        useImage: true, // 👈 Splash uses background image
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: 120),
                const SizedBox(height: 20),
                const Text(
                  'Cure Mate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
