import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/theme/color.dart';

class MyPrescriptionsScreen extends StatelessWidget {
  const MyPrescriptionsScreen({super.key});

  // ================= GET USER PRESCRIPTIONS =================
  Stream<QuerySnapshot> getMyPrescriptions() {
    final user = FirebaseAuth.instance.currentUser;

    return FirebaseFirestore.instance
        .collection('prescriptions')
        .where('userId', isEqualTo: user!.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ================= STATUS COLOR =================
  Color statusColor(String status) {
    switch (status) {
      case "Success":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Failure":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ================= STATUS ICON =================
  IconData statusIcon(String status) {
    switch (status) {
      case "Success":
        return Icons.check_circle_outline;
      case "Pending":
        return Icons.hourglass_bottom;
      case "Failure":
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("My Prescriptions"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: StreamBuilder<QuerySnapshot>(
          stream: getMyPrescriptions(),

          builder: (context, snapshot) {
            // ================= LOADING =================
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ================= EMPTY =================
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No Prescriptions Found",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            // ================= LIST =================
            return ListView.builder(
              itemCount: docs.length,

              itemBuilder: (context, index) {
                final data =
                    docs[index].data() as Map<String, dynamic>;

                final status = data['status'] ?? "Pending";
                final imageUrl = data['imageUrl'] ?? "";
                final createdAt = data['createdAt'];

                String date = "";
                if (createdAt != null) {
                  date = createdAt.toDate().toString();
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 15),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // STATUS ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Prescription ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            Row(
                              children: [
                                Icon(
                                  statusIcon(status),
                                  color: statusColor(status),
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  status,
                                  style: TextStyle(
                                    color: statusColor(status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // DATE
                        Text(
                          date,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // IMAGE
                        if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 12),

                        // VIEW BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      child: Image.network(imageUrl),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.visibility, size: 18),
                              label: const Text("View"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}