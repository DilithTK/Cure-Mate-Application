import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../core/theme/color.dart';
import '../../core/services/prescription_scanner_service.dart';
import '../../models/prescription_model.dart';
import '../../models/medicine_model.dart';
import '../../widgets/medicine_tile.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final PrescriptionModel prescription;

  const PrescriptionDetailsScreen({
    super.key,
    required this.prescription,
  });

  @override
  State<PrescriptionDetailsScreen> createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState
    extends State<PrescriptionDetailsScreen> {

  final TextEditingController noteController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  String selectedStatus = "Available";

  Future<File> urlToFile(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/prescription.jpg');

    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  @override
  void dispose() {
    noteController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text("Prescription Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PATIENT INFO
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10),
                      Text(widget.prescription.patientName),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 10),
                      Text(widget.prescription.date),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

           
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.prescription.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Medicines (Auto Scanned)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ///REAL OCR HERE
            FutureBuilder<List<MedicineModel>>(
              future: () async {
                final file =
                    await urlToFile(widget.prescription.imageUrl);

                return PrescriptionScannerService
                    .scanPrescription(file);
              }(),

              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Text("No medicines detected");
                }

                final medicines = snapshot.data!;

                return Column(
                  children: medicines
                      .map((e) => MedicineTile(medicine: e))
                      .toList(),
                );
              },
            ),

            const SizedBox(height: 20),

            
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter price",
                filled: true,
              ),
            ),

            const SizedBox(height: 10),

            
            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Pharmacy note",
                filled: true,
              ),
            ),

            const SizedBox(height: 20),

            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: AppColors.primary,
              ),

              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('prescriptions')
                    .doc(widget.prescription.id)
                    .update({
                  "note": noteController.text,
                  "price": priceController.text,
                  "status": selectedStatus,
                  "updatedAt":
                      FieldValue.serverTimestamp(),
                });

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Response Sent Successfully"),
                  ),
                );
              },

              child: const Text("Send Response"),
            ),
          ],
        ),
      ),
    );
  }
}
