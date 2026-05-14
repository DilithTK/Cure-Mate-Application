import 'package:flutter/material.dart';
import '../core/theme/color.dart';
import 'custom_appbar.dart';
import '../screens/home/home_screen.dart';
import '../screens/prescriptions/find_pharmacies_screen.dart';
import '../screens/pharmacy/pharmacy_list_screen.dart';
import '../screens/pharmacy/map_screen.dart';
import '../screens/profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    FindPharmaciesScreen(),
    PharmacyListScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = const [
    "Cure Mate",
    "Prescriptions",
    "Pharmacies",
    "Map",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _titles[_currentIndex],
        onBellTap: () {
          
        },
        onMenuTap: () {
          
        },
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: "Prescriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy_outlined),
            label: "Pharmacy",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}