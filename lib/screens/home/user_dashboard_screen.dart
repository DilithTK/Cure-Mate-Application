import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';

import '../../screens/prescriptions/upload_prescription_screen.dart';
import '../../screens/pharmacy/pharmacy_list_screen.dart';
import '../../screens/reminders/reminder_list_screen.dart';
import '../pharmacy/user_response_screen.dart';
import '../../screens/prescriptions/order_history.dart';
import '../../screens/health/health_tips_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "Good Morning 👋";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon 👋";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening 👋";
    } else {
      return "Good Night 🌙";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // 👋 Greeting
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            getGreeting(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 25),

<<<<<<< HEAD
        
=======
        // 🔲 Dashboard Grid
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                DashboardCard(
                  icon: Icons.upload_outlined,
                  title: "Upload\nPrescription",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UploadPrescriptionScreen(),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  icon: Icons.history,
                  title: "Pharmacy\nResponse",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const UserResponseScreen(
                              
                            ),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  icon: Icons.store_mall_directory_outlined,
                  title: "Find\nPharmacies",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PharmacyListScreen(),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  icon: Icons.alarm_outlined,
                  title: "Medicine\nReminder",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReminderListScreen(),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  icon: Icons.assignment_outlined,
                  title: "My\nPrescriptions",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyPrescriptionsScreen(),
                      ),
                    );
                  },
                ),

                DashboardCard(
                  icon: Icons.favorite_border,
                  title: "Health\nTips",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MedicineExplainerScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
