
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/color.dart';
import '../../widgets/custom_button.dart';

import '../../core/services/pharmacy_service.dart';
import '../../core/services/location_service.dart';

import '../pharmacy/user_response_screen.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  File? _image;
  bool isProcessing = false;

  final ImagePicker _picker = ImagePicker();

  final pharmacyService = PharmacyService();
  final locationService = LocationService();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<String> uploadImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final uid = user.uid;

    final ref = FirebaseStorage.instance
        .ref()
        .child('prescriptions')
        .child(uid)
        .child('$fileName.jpg');

    UploadTask uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    } else {
      throw Exception("Upload failed");
    }
  }

  Future<void> uploadPrescription() async {
    if (_image == null) return;

    setState(() => isProcessing = true);

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      ///  Upload Image
      String imageUrl = await uploadImage(_image!);

      ///  Save Prescription
      await FirebaseFirestore.instance.collection('prescriptions').add({
        'userId': uid,
        'imageUrl': imageUrl,
        'status': 'Pending',
        'pharmacyResponse': null,
        'createdAt': FieldValue.serverTimestamp(),

        'expiryTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
      });

      ///  Get User Location
      final position = await locationService.getLocation();

      ///  Send to nearby pharmacies
      await pharmacyService.findNearbyAndSend(
        prescriptionId: "auto",
        lat: position.latitude,
        lng: position.longitude,
      );

      if (!mounted) return;

      setState(() => _image = null);

      ///  Navigate
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UserResponseScreen()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Uploaded successfully")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }

    setState(() => isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Upload Prescription"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Center(child: Text("Tap to select image")),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            CustomButton(
              isProcessing ? "Uploading..." : "Upload",
              onPressed: isProcessing ? null : uploadPrescription,
            ),
          ],
        ),
      ),
    );
  }
}
