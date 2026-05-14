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
  String regNo = "Loading...";

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
        setState(() {
          regNo = "PH-${doc['registrationNo'] ?? '0000'}";
        });
      } else {
        setState(() {
          regNo = "PH-0000";
        });
      }
    } catch (e) {
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
      appBar: AppBar(
        title: Text("Pharmacy Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              regNo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                statCard("Total", totalCount),
                const SizedBox(width: 10),
                statCard("Pending", pendingCount),
                const SizedBox(width: 10),
                statCard(
                  "Completed",
                  totalCount - pendingCount,
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Recent Prescriptions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getPrescriptionsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                      child: Text("No prescriptions found"),
                    );
                  }

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
                              builder: (_) =>
                                  PrescriptionDetailsScreen(
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
    );
  }

  Widget statCard(String title, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}