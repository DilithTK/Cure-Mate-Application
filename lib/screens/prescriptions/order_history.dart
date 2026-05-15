import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
        return Icons.check_circle;

      case "Pending":
        return Icons.access_time;

      case "Failure":
        return Icons.cancel;

      default:
        return Icons.info;
    }
  }

  // ================= DATE FORMAT =================
  String formatDate(Timestamp? ts) {
    if (ts == null) return "Unknown date";

    final date = ts.toDate();

    return DateFormat(
      'dd MMM yyyy • hh:mm a',
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Prescription History"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: getMyPrescriptions(),

        builder: (context, snapshot) {
          // ================= LOADING =================
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ================= ERROR =================
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          // ================= EMPTY =================
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No prescription history yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // ================= LIST =================
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,

            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;

              final status =
                  data['status']?.toString() ?? "Pending";

              final imageUrl =
                  data['imageUrl']?.toString() ?? "";

              final createdAt =
                  data['createdAt'] as Timestamp?;

              return Container(
                margin: const EdgeInsets.only(bottom: 18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ================= IMAGE =================
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),

                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,

                              errorBuilder:
                                  (context, error,
                                      stackTrace) {
                                return Container(
                                  height: 220,
                                  color:
                                      Colors.grey.shade300,

                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              height: 220,
                              color: Colors.grey.shade300,

                              child: const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 50,
                                ),
                              ),
                            ),
                    ),

                    // ================= DETAILS =================
                    Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          // ================= TITLE + STATUS =================
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,

                            children: [
                              Text(
                                "Prescription #${index + 1}",

                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(
                                  color: statusColor(
                                    status,
                                  ).withValues(alpha: 0.15),

                                  borderRadius:
                                      BorderRadius.circular(
                                    30,
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Icon(
                                      statusIcon(status),
                                      size: 16,
                                      color: statusColor(
                                        status,
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 5,
                                    ),

                                    Text(
                                      status,

                                      style: TextStyle(
                                        color: statusColor(
                                          status,
                                        ),

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // ================= DATE =================
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color:
                                    Colors.grey.shade600,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                formatDate(createdAt),

                                style: TextStyle(
                                  color: Colors
                                      .grey.shade700,

                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}