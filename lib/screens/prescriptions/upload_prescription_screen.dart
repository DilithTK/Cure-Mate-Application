import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

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

  final ImagePicker _picker = ImagePicker();
  final pharmacyService = PharmacyService();
  final locationService = LocationService();

  /// 📍 LOCATION PERMISSION
  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }
  }

  /// 📸 PICK IMAGE
  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  /// ☁️ UPLOAD IMAGE
  Future<String> uploadImage(File file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child('prescriptions')
        .child(user.uid)
        .child('$fileName.jpg');

    final snapshot = await ref.putFile(file);
    return await snapshot.ref.getDownloadURL();
  }

  /// 🚀 MAIN UPLOAD (NO LOADING UI)
  Future<void> uploadPrescription() async {
    if (_image == null) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      /// 1️⃣ upload image
      final imageUrl = await uploadImage(_image!);

      /// 2️⃣ location
      await checkLocationPermission();
      final position = await locationService.getLocation();

      /// 3️⃣ save prescription
      final docRef =
          await FirebaseFirestore.instance.collection('prescriptions').add({
        'userId': uid,
        'imageUrl': imageUrl,
        'status': 'pending',
        'pharmacyResponse': null,
        'createdAt': FieldValue.serverTimestamp(),
        'expiryTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
        'location': {
          'lat': position.latitude,
          'lng': position.longitude,
        }
      });

      /// 4️⃣ send to pharmacy system
      await pharmacyService.findNearbyAndSend(
        prescriptionId: docRef.id,
        lat: position.latitude,
        lng: position.longitude,
      );

      /// 5️⃣ USER NOTIFICATION (Firestore only)
      /// 5️⃣ SEND TO PHARMACY (REAL NOTIFICATION)
await FirebaseFirestore.instance.collection('fcm_messages').add({
  'to': 'pharmacy',
  'title': 'New Prescription',
  'body': 'A user uploaded a prescription',
  'prescriptionId': docRef.id,
  'createdAt': FieldValue.serverTimestamp(),
});




      /// 7️⃣ reset UI
      setState(() {
        _image = null;
      });

      /// 8️⃣ only simple feedback (NO loading)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Prescription uploaded successfully"),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const UserResponseScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      }
    }
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
              "Upload Prescription",
              onPressed: uploadPrescription,
            ),
          ],
        ),
      ),
    );
  }
}
