/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/color.dart';

class UserPharmacyResponseScreen extends StatefulWidget {
  final String prescriptionId;

  const UserPharmacyResponseScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  State<UserPharmacyResponseScreen> createState() =>
      _PharmacyResponseScreenState();
}

class _PharmacyResponseScreenState
    extends State<UserPharmacyResponseScreen> {
  int? selectedIndex;

  /// 🔥 STORE LIVE DOCS HERE
  List<QueryDocumentSnapshot> docs = [];

  @override
  Widget build(BuildContext context) {
    final responseRef = FirebaseFirestore.instance
        .collection('prescriptions')
        .doc(widget.prescriptionId)
        .collection('responses');

    return Scaffold(
      backgroundColor: const Color(0xFF6FA3A7),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// HEADER
            const Text(
              "Availability Status",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 10),

            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white24,
              child: Icon(Icons.local_pharmacy, color: Colors.white),
            ),

            const SizedBox(height: 10),

            const Text(
              "Pharmacy Responses",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Live updates from nearby pharmacies",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            /// LIVE RESPONSES
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: responseRef.snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No pharmacy responses yet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  /// 🔥 UPDATE LIVE DOCS
                  docs = snapshot.data!.docs;

                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: docs.length,

                    itemBuilder: (context, index) {
                      var data =
                          docs[index].data() as Map<String, dynamic>;

                      String status =
                          data['availability'] ?? "Unavailable";

                      String pharmacyName =
                          data['pharmacyName'] ??
                              "Unknown Pharmacy";

                      Color color;
                      IconData icon;

                      if (status == "Available") {
                        color = Colors.green;
                        icon = Icons.check_circle;
                      } else if (status == "Partial") {
                        color = Colors.orange;
                        icon = Icons.warning;
                      } else {
                        color = Colors.red;
                        icon = Icons.close;
                      }

                      return Container(
                        margin:
                            const EdgeInsets.only(bottom: 12),

                        padding: const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selectedIndex,

                              onChanged: (v) {
                                setState(() {
                                  selectedIndex = v;
                                });
                              },
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    pharmacyName,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "Response received",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                color:
                                    color.withOpacity(0.15),

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    size: 16,
                                    color: color,
                                  ),

                                  const SizedBox(width: 4),

                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
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
            ),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.all(16),

              child: ElevatedButton(
                onPressed: selectedIndex == null
                    ? null
                    : () {
                        final selectedDoc =
                            docs[selectedIndex!].data()
                                as Map<String, dynamic>;

                        print(selectedDoc);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              "${selectedDoc['pharmacyName']} selected",
                            ),
                          ),
                        );
                      },

                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 55),

                  backgroundColor: Colors.white,

                  foregroundColor: Colors.black,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                ),

                child: const Text(
                  "Select a Pharmacy",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserResponseScreen extends StatelessWidget {
  const UserResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDDF3EE),

      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('prescriptions')
              .orderBy('createdAt', descending: true)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No prescriptions found"));
            }

            final prescriptions = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: prescriptions.length,

              itemBuilder: (context, index) {
                final data =
                    prescriptions[index].data() as Map<String, dynamic>;

                final imageUrl = data['imageUrl']?.toString() ?? '';
                final pharmacyName =
                    data['pharmacyName']?.toString() ?? 'Pharmacy';
                final status = data['status']?.toString() ?? 'Pending';
                final price = data['price']?.toString() ?? '0';
                final note = data['note']?.toString() ?? 'No details';

                Color statusColor = Colors.orange;
                if (status == "Available") statusColor = Colors.green;
                if (status == "Unavailable") statusColor = Colors.red;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 100,
                                    color: Colors.grey,
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              )
                            : Container(
                                width: 80,
                                height: 100,
                                color: Colors.grey,
                                child: const Icon(Icons.image),
                              ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pharmacyName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(note),

                              const SizedBox(height: 8),

                              Text(
                                "Rs. $price",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
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
