import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';
import 'response_screen.dart';

class PharmacyDashboard extends StatefulWidget {
  const PharmacyDashboard({super.key});

  @override
  State<PharmacyDashboard> createState() => _PharmacyDashboardState();
}

class _PharmacyDashboardState extends State<PharmacyDashboard> {
  int selectedIndex = 0;

  final String pharmacyName = "City Pharmacy";

  // 🔥 LOGOUT FUNCTION
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.local_pharmacy),
            SizedBox(width: 10),
            Text(
              "CureMate",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout, // 🔥 your original logout used
          ),
        ],
      ),

      // ================= BODY =================
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Text(
              "Hello, $pharmacyName 👋",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: selectedIndex == 0
                ? _buildPrescriptions()
                : _buildResponses(),
          ),
        ],
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Prescriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reply),
            label: "Responses",
          ),
        ],
      ),
    );
  }

  // ================= PRESCRIPTION LIST =================
  Widget _buildPrescriptions() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('prescriptions')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var prescriptions = snapshot.data!.docs;

        if (prescriptions.isEmpty) {
          return const Center(child: Text("No prescriptions"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            var data =
                prescriptions[index].data() as Map<String, dynamic>;

            bool isResponded = data['status'] == 'responded';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),

                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    data['imageUrl'] ?? '',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image),
                  ),
                ),

                title: const Text(
                  "Prescription",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(
                  isResponded ? "Responded" : "Pending",
                  style: TextStyle(
                    color:
                        isResponded ? Colors.green : Colors.orange,
                  ),
                ),

                trailing:
                    const Icon(Icons.arrow_forward_ios, size: 18),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResponseScreen(
                        prescriptionId: prescriptions[index].id,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // ================= RESPONSES TAB =================
  Widget _buildResponses() {
    return const Center(
      child: Text(
        "Responses will appear here",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}