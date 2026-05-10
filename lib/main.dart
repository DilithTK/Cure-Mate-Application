import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/phamacist/pharmacy_dashboard.dart';
import 'firebase_options.dart';
import 'core/theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 App Check (DEBUG mode for development)
  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
   );
  }
  

  runApp(const CureMateApp());
}

class CureMateApp extends StatelessWidget {
  const CureMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CureMate',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.transparent,
      ),

      home: kIsWeb ?  PharmacyDashboardScreen() : const SplashScreen(),
      //home: Scaffold(
       // body: Center(
          //child: Text("WEB WORKING", style: TextStyle(fontSize: 40)),
       // ),
      //),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

// 🔥 AUTH CHECK (USE THIS IN SPLASH)
class AuthChecker {
  static Widget getScreen() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
