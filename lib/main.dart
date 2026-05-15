import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'firebase_options.dart';
import 'core/services/notification_service.dart';
import 'core/navigation/app_navigation.dart';
import 'core/theme/color.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/phamacist/pharmacy_dashboard.dart';

/// 🔥 Background handler (must be top-level)
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 1. LOAD .env FIRST (IMPORTANT)
  await dotenv.load(fileName: ".env");

  /// 🧪 DEBUG (REMOVE LATER if you want)
  print("🔥 ENV KEY => ${dotenv.env['GEMINI_API_KEY']}");

  /// 🌍 2. TIMEZONE INIT
  tz.initializeTimeZones();

  /// 🔥 3. FIREBASE INIT
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// 🔔 4. BACKGROUND MESSAGE HANDLER
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  /// 🔔 5. NOTIFICATION CLICK HANDLER
  NotificationService.onNotificationClick = (prescriptionId) {
    if (prescriptionId.isNotEmpty) {
      AppNavigation.openPrescription(prescriptionId);
    }
  };

  /// 🚀 RUN APP FIRST (important order fix)
  runApp(const CureMateApp());

  /// 🔔 6. INIT NOTIFICATIONS AFTER APP START
  NotificationService.init().catchError((error) {
    debugPrint("Notification init failed: $error");
  });
}

class CureMateApp extends StatelessWidget {
  const CureMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CureMate',

      navigatorKey: AppNavigation.navigatorKey,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),

      home: const RootDecider(),

      routes: {
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/pharmacy': (_) => const PharmacyDashboardScreen(),
      },
    );
  }
}

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

        return snapshot.hasData
            ? const HomeScreen()
            : const SplashScreen();
      },
    );
  }
}