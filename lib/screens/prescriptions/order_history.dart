import 'package:flutter/material.dart';
<<<<<<< HEAD
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

=======
import '../../core/theme/color.dart';
import '../../models/myorder_model.dart';


class MyPrescriptionsScreen extends StatelessWidget {
   const MyPrescriptionsScreen({super.key});

  // Sample orders
  static List<Order> orders = [
    Order(
      id: "ORD12345",
      date: "2026-03-10 10:15 AM",
      status: "Delivered",
      items: ["Paracetamol 500mg", "Vitamin C 1000mg"],
    ),
    Order(
      id: "ORD12346",
      date: "2026-03-08 02:30 PM",
      status: "Pending",
      items: ["Cough Syrup", "Zinc Tablets"],
    ),
    Order(
      id: "ORD12347",
      date: "2026-03-05 11:45 AM",
      status: "Cancelled",
      items: ["Ibuprofen 200mg"],
    ),
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      default:
        return Colors.grey;
    }
  }

<<<<<<< HEAD
  // ================= STATUS ICON =================
  IconData statusIcon(String status) {
    switch (status) {
      case "Success":
        return Icons.check_circle_outline;

      case "Pending":
        return Icons.hourglass_bottom;

      case "Failure":
        return Icons.cancel_outlined;

=======
  IconData _statusIcon(String status) {
    switch (status) {
      case "Delivered":
        return Icons.check_circle_outline;
      case "Pending":
        return Icons.hourglass_bottom;
      case "Cancelled":
        return Icons.cancel_outlined;
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
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
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ================= EMPTY =================
            if (!snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
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

                final status =
                    data['status'] ?? "Pending";

                final imageUrl =
                    data['imageUrl'] ?? "";

                final createdAt =
                    data['createdAt'];

                String date = "";

                if (createdAt != null) {
                  date = createdAt
                      .toDate()
                      .toString();
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),

                  elevation: 4,

                  margin:
                      const EdgeInsets.only(bottom: 15),

                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [
                        // ================= STATUS =================
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [
                            Text(
                              "Prescription ${index + 1}",

                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            Row(
                              children: [
                                Icon(
                                  statusIcon(status),

                                  color:
                                      statusColor(status),

                                  size: 20,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  status,

                                  style: TextStyle(
                                    color:
                                        statusColor(
                                            status),

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ================= DATE =================
                        Text(
                          date,

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ================= IMAGE =================
                        if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),

                            child: Image.network(
                              imageUrl,

                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 12),

                        // ================= ACTIONS =================
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end,

                          children: [
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,

                                  builder: (_) => Dialog(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  12),

                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.visibility,
                                size: 18,
                              ),

                              label: const Text("View"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
=======
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
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
                    // Order ID & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.id,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Icon(
                              _statusIcon(order.status),
                              color: _statusColor(order.status),
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              order.status,
                              style: TextStyle(
                                  color: _statusColor(order.status),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Date
                    Text(
                      order.date,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 10),

                    // Items
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: order.items
                          .map(
                            (item) => Chip(
                              label: Text(item),
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              labelStyle: const TextStyle(
                                  color: AppColors.primary, fontSize: 12),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 10),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // TODO: View order details
                          },
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text("View"),
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Reorder
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Reorder"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            );
          },
        ),
      ),
    );
  }
}