import 'package:flutter/material.dart';
import '../../core/theme/color.dart';

import 'user_dashboard_screen.dart';
import '../../screens/prescriptions/upload_prescription_screen.dart';
import '../../screens/pharmacy/pharmacy_list_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/splash/role_selection_screen.dart';

import '../../widgets/app_background.dart';
import '../../widgets/custom_appbar.dart';

import '../../core/services/firebase_auth_service.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_currentIndex],
        onBellTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Notifications")));
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Prescriptions",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
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
                setState(() {
                  _currentIndex = 3;
                });
              }),

              _menuItem(Icons.history, "My Prescriptions", () {
                Navigator.pop(context);
                // TODO
              }),

              _menuItem(Icons.settings, "Settings", () {
                Navigator.pop(context);
                // TODO
              }),

              const Divider(),

              // 🔐 AUTH
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

              _menuItem(Icons.logout, "Logout", () async {
                Navigator.pop(context);

                await _authService.logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
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