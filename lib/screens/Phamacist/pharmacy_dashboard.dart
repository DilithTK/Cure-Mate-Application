import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/services/notification_service.dart';
import '../../core/theme/color.dart';
import '../../models/prescription_model.dart';
import '../../widgets/prescription_card.dart';
import '../notifications/pharmacy_notification_screen.dart';
import '../splash/role_selection_screen.dart';
import 'prescription_details_screen.dart';

class PharmacyDashboardScreen extends StatefulWidget {
  const PharmacyDashboardScreen({super.key});

  @override
  State<PharmacyDashboardScreen> createState() =>
      _PharmacyDashboardScreenState();
}

class _PharmacyDashboardScreenState extends State<PharmacyDashboardScreen> {
  String regNo ="";

  int totalCount = 0;
  int pendingCount = 0;
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();

    loadPharmacyData();
    loadStats();

    NotificationService.subscribePharmacy();

    listenNotifications();
  }

  // NOTIFICATION LISTENER

  void listenNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('type', isEqualTo: 'pharmacy')
        .snapshots()
        .listen((snapshot) {
          if (!mounted) return;

          final unread = snapshot.docs.where((doc) {
            return (doc['isRead'] ?? false) == false;
          }).length;

          setState(() {
            notificationCount = unread;
          });
        });
  }

  // MARK ALL AS READ

  Future<void> markAllAsRead() async {
    final batch = FirebaseFirestore.instance.batch();

    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('type', isEqualTo: 'pharmacy')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  // LOAD PHARMACY DATA

  Future<void> loadPharmacyData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(user.uid)
        .get();

    if (!mounted) return;

    if (doc.exists && doc.data() != null) {
      setState(() {
        regNo = "PH-${doc['registrationNo'] ?? '0000'}";
      });
    } else {
      setState(() {
        regNo = "PH-0000";
      });
    }
  }

  // LOAD STATS

  Future<void> loadStats() async {
    final allSnap = await FirebaseFirestore.instance
        .collection('prescriptions')
        .get();

    final pendingSnap = await FirebaseFirestore.instance
        .collection('prescriptions')
        .where('status', isEqualTo: 'Pending')
        .get();

    if (!mounted) return;

    setState(() {
      totalCount = allSnap.docs.length;
      pendingCount = pendingSnap.docs.length;
    });
  }

  // PRESCRIPTION STREAM

  Stream<QuerySnapshot> getPrescriptionsStream() {
    return FirebaseFirestore.instance
        .collection('prescriptions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // LOGOUT

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      (route) => false,
    );
  }

  // UI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,

        foregroundColor: Colors.white,

        elevation: 0,

        title: const Text(
          "Pharmacy Dashboard",

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          // NOTIFICATION BUTTON
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),

                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PharmacyNotificationScreen(),
                    ),
                  );

                  await markAllAsRead();
                },
              ),

              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,

                  child: Container(
                    padding: const EdgeInsets.all(5),

                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),

                    child: Text(
                      notificationCount.toString(),

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // REG NO
              Text(
                "Hello! ${regNo ?? ''}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                regNo ?? "Loading registration...",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMedium,
                ),
              ),

              const SizedBox(height: 20),

              // STATS
              Row(
                children: [
                  statCard(
                    title: "Total",
                    value: totalCount,
                    color: AppColors.info,
                  ),

                  const SizedBox(width: 10),

                  statCard(
                    title: "Pending",
                    value: pendingCount,
                    color: AppColors.warning,
                  ),

                  const SizedBox(width: 10),

                  statCard(
                    title: "Completed",
                    value: totalCount - pendingCount,
                    color: AppColors.success,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Recent Prescriptions",

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 14),

              // LIST
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getPrescriptionsStream(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("No prescriptions found"),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,

                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

                        final prescription = PrescriptionModel(
                          id: docs[index].id,

                          patientName: data['patientName'] ?? "Unknown",

                          date: data['createdAt'] != null
                              ? (data['createdAt'] as Timestamp)
                                    .toDate()
                                    .toString()
                                    .split(' ')[0]
                              : "",

                          imageUrl: data['imageUrl'] ?? "",

                          status: data['status'] ?? "Pending",

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

  // STAT CARD

  Widget statCard({
    required String title,
    required int value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [
            Text(
              value.toString(),

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,

              style: const TextStyle(
                color: AppColors.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
