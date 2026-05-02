import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/theme/color.dart';

class PharmacyResponseScreen extends StatefulWidget {
  final String prescriptionId;

  const PharmacyResponseScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  State<PharmacyResponseScreen> createState() =>
      _PharmacyResponseScreenState();
}

class _PharmacyResponseScreenState
    extends State<PharmacyResponseScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6FA3A7),
              Color(0xFF9FC6C3),
            ],
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              // 🔹 TOP BAR
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Text(
                      "Cure Mate",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.notifications_none),
                    SizedBox(width: 10),
                    Icon(Icons.menu),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Pharmacy Responses",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // 🔥 LIVE STREAM FROM FIRESTORE
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('prescriptions')
                      .doc(widget.prescriptionId)
                      .collection('responses')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var responses = snapshot.data!.docs;

                    if (responses.isEmpty) {
                      return const Center(
                        child: Text("No responses yet"),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: responses.length,
                      itemBuilder: (context, index) {
                        var data = responses[index];

                        String status = data['availability'];

                        Color statusColor = status == "Available"
                            ? Colors.green
                            : status == "Partial"
                                ? Colors.orange
                                : Colors.grey;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),

                          child: ListTile(
                            leading: Radio<int>(
                              value: index,
                              groupValue: selectedIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedIndex = value;
                                });
                              },
                            ),

                            title: Text(
                              data['pharmacyName'], // 🔥 REAL NAME
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(
                              data['message'] ?? "",
                            ),

                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // 🔹 SELECT BUTTON
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: selectedIndex == null
                        ? Colors.grey.shade300
                        : AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: selectedIndex == null ? null : () {},
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text("Select Pharmacy"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}