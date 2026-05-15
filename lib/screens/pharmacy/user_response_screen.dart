import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserResponseScreen extends StatelessWidget {
  const UserResponseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDDF3EE),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("Pharmacy Response"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('prescriptions')
            .orderBy('createdAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No responses found"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,

            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final imageUrl = data['imageUrl']?.toString() ?? '';
              final pharmacyName =
                  data['pharmacyName']?.toString() ?? 'Pharmacy';
              final status = data['status']?.toString() ?? 'Pending';
              final price = data['price']?.toString() ?? '0';
              final note = data['note']?.toString() ?? 'No note';

              Color statusColor = Colors.orange;
              if (status == "Available") statusColor = Colors.green;
              if (status == "Unavailable") statusColor = Colors.red;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResponseDetailsScreen(
                        imageUrl: imageUrl,
                        pharmacyName: pharmacyName,
                        status: status,
                        price: price,
                        note: note,
                      ),
                    ),
                  );
                },

                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: 80,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 90,
                                      color: Colors.grey,
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 90,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image),
                                ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pharmacyName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Rs. $price",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// DETAILS SCREEN


class ResponseDetailsScreen extends StatelessWidget {
  final String imageUrl;
  final String pharmacyName;
  final String status;
  final String price;
  final String note;

  const ResponseDetailsScreen({
    super.key,
    required this.imageUrl,
    required this.pharmacyName,
    required this.status,
    required this.price,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.orange;

    if (status == "Available") statusColor = Colors.green;
    if (status == "Unavailable") statusColor = Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xffDDF3EE),

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Response Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl)
                  : Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image),
                    ),
            ),

            const SizedBox(height: 20),

            Text(
              pharmacyName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Pharmacy Note",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(note, style: const TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 25),

            const Text(
              "Price",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Rs. $price",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}