import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/color.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/firebase_auth_service.dart';

import 'user_dashboard_screen.dart';
import '../../screens/prescriptions/upload_prescription_screen.dart';
import '../../screens/pharmacy/pharmacy_list_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/splash/role_selection_screen.dart';

import '../../widgets/app_background.dart';
import '../../widgets/custom_appbar.dart';

import '../notifications/user_notification_screen.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final AuthService _authService = AuthService();

  final List<String> _titles = const [
    "Cure Mate",
    "Prescriptions",
    "Nearby Pharmacies",
    "My Profile",
  ];

  final List<Widget> _pages = const [
    DashboardPage(),
    UploadPrescriptionScreen(),
    PharmacyListScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();

    
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      NotificationService.subscribeUser(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_currentIndex],

         
        onBellTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UserNotificationScreen(),
            ),
          );
        },

        onMenuTap: () {
          _showMenu(context);
        },
      ),

      body: AppBackground(child: _pages[_currentIndex]),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Prescriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menuItem(Icons.person, "Profile", () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              }),

              _menuItem(Icons.history, "My Prescriptions", () {
                Navigator.pop(context);
              }),

              _menuItem(Icons.settings, "Settings", () {
                Navigator.pop(context);
              }),

              const Divider(),

              if (FirebaseAuth.instance.currentUser == null) ...[
                _menuItem(Icons.login, "Login", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                }),
                _menuItem(Icons.app_registration, "Register", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                }),
                const Divider(),
              ],

              _menuItem(Icons.logout, "Logout", () async {
                Navigator.pop(context);

                await _authService.logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _menuItem(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
