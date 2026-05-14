import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/color.dart';
import '../../models/prescription_model.dart';
import '../../widgets/prescription_card.dart';
import 'prescription_details_screen.dart';

import '../splash/role_selection_screen.dart';

class PharmacyDashboardScreen extends StatefulWidget {
  const PharmacyDashboardScreen({super.key});

  @override
  State<PharmacyDashboardScreen> createState() =>
      _PharmacyDashboardScreenState();
}

class _PharmacyDashboardScreenState extends State<PharmacyDashboardScreen> {
  String regNo = "Loading ...";

  int totalCount = 0;
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    loadPharmacyData();
    loadStats();
  }

  
  void loadPharmacyData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('pharmacies')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;

        setState(() {
          regNo = "PH-${data['registrationNo'] ?? '0000'}";
        });
      } else {
        setState(() {
          regNo = "PH-0000";
        });
      }
    } catch (e) {
      debugPrint("Error loading pharmacy: $e");

      setState(() {
        regNo = "PH-0000";
      });
    }
  }

  void loadStats() async {
    try {
      final pendingSnap = await FirebaseFirestore.instance
          .collection('prescriptions')
          .where('status', isEqualTo: 'Pending')
          .get();

      final allSnap =
          await FirebaseFirestore.instance.collection('prescriptions').get();

      setState(() {
        pendingCount = pendingSnap.docs.length;
        totalCount = allSnap.docs.length;
      });
    } catch (e) {
      debugPrint("Stats error: $e");
    }
  }

  
  Stream<QuerySnapshot> getPrescriptionsStream() {
    return FirebaseFirestore.instance
        .collection('prescriptions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello 👋",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            regNo.isNotEmpty ? regNo : "PH-0000",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Notification
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),

                      //  Logout 
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const RoleSelectionScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),

                      CircleAvatar(
                        child: Text(
                          regNo.isNotEmpty && regNo.length >= 2
                              ? regNo.substring(0, 2).toUpperCase()
                              : "PH",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              
              Row(
                children: [
                  statCard("Total", totalCount.toString(), AppColors.primary),
                  const SizedBox(width: 10),
                  statCard("Pending", pendingCount.toString(), AppColors.warning),
                  const SizedBox(width: 10),
                  statCard(
                    "Completed",
                    (totalCount - pendingCount).toString(),
                    AppColors.success,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Recent Prescriptions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getPrescriptionsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No prescriptions found"),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data =
                            docs[index].data() as Map<String, dynamic>;

                        final prescription = PrescriptionModel(
                          id: docs[index].id,
                          patientName: data['patientName'] ?? "Unknown",
                          date: data['date']?.toString() ?? "",
                          imageUrl: data['imageUrl'] ?? "",
                          medicines: [],
                        );

                        return PrescriptionCard(
                          prescription: prescription,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PrescriptionDetailsScreen(
                                  prescription: prescription,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(color: color, fontSize: 18),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}