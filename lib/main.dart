import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
<<<<<<< HEAD
import 'package:flutter_dotenv/flutter_dotenv.dart';
=======

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
<<<<<<< HEAD
import 'screens/Phamacist/pharmacy_dashboard.dart';

=======
import 'screens/phamacist/pharmacy_dashboard.dart';
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
import 'firebase_options.dart';
import 'core/theme/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< HEAD
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("ENV file missing, skipping...");
  }
=======
  await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 App Check (DEBUG mode for development)
  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
   );
  }
  
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

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

<<<<<<< HEAD
      home: const RootDecider(),
=======
      home: kIsWeb ?  PharmacyDashboardScreen() : const SplashScreen(),
      //home: Scaffold(
       // body: Center(
          //child: Text("WEB WORKING", style: TextStyle(fontSize: 40)),
       // ),
      //),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
<<<<<<< HEAD
        '/pharmacy': (context) => PharmacyDashboardScreen(),
=======
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      },
    );
  }
}

<<<<<<< HEAD
class RootDecider extends StatelessWidget {
  const RootDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const SplashScreen();
        }
      },
    );
=======
// 🔥 AUTH CHECK (USE THIS IN SPLASH)
class AuthChecker {
  static Widget getScreen() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  }
}
