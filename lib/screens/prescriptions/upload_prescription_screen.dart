import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/location_service.dart';
import '../../core/services/pharmacy_service.dart';
import '../../core/theme/color.dart';
import '../../widgets/custom_button.dart';
import '../pharmacy/user_response_screen.dart';

class UploadPrescriptionScreen extends StatefulWidget {
  const UploadPrescriptionScreen({super.key});

  @override
  State<UploadPrescriptionScreen> createState() =>
      _UploadPrescriptionScreenState();
}

class _UploadPrescriptionScreenState extends State<UploadPrescriptionScreen> {
  XFile? _image;
  Uint8List? _imageBytes;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();
  final pharmacyService = PharmacyService();
  final locationService = LocationService();

  Future<void> _pickImage(ImageSource source) async {
    if (_isUploading) return;

    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    if (!mounted) return;
    setState(() {
      _image = picked;
      _imageBytes = bytes;
    });
  }

  Future<Position?> _tryGetLocation() async {
    try {
      return await locationService
          .getLocation()
          .timeout(const Duration(seconds: 15));
    } catch (e) {
      debugPrint("Prescription location skipped: $e");
      return null;
    }
  }

  Future<String> uploadImage(XFile file) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final bytes = await file.readAsBytes();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final ref = FirebaseStorage.instance
        .ref()
        .child('prescriptions')
        .child(user.uid)
        .child('$fileName.jpg');

    final snapshot = await ref
        .putData(bytes, SettableMetadata(contentType: 'image/jpeg'))
        .timeout(const Duration(seconds: 45));

    return await snapshot.ref
        .getDownloadURL()
        .timeout(const Duration(seconds: 20));
  }

  Future<void> uploadPrescription() async {
    if (_isUploading) return;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a prescription image")),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please log in before uploading")),
        );
        return;
      }

      setState(() => _isUploading = true);

      final position = await _tryGetLocation();
      final imageUrl = await uploadImage(_image!);

      final data = <String, dynamic>{
        'userId': user.uid,
        'patientId': user.uid,
        'patientName': user.displayName ?? user.email ?? 'Patient',
        'imageUrl': imageUrl,
        'status': 'pending',
        'pharmacyResponse': null,
        'createdAt': FieldValue.serverTimestamp(),
        'expiryTime': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
      };

      if (position != null) {
        data['location'] = {
          'lat': position.latitude,
          'lng': position.longitude,
        };
      }

      final docRef = await FirebaseFirestore.instance
          .collection('prescriptions')
          .add(data)
          .timeout(const Duration(seconds: 30));

      try {
        await pharmacyService.findNearbyAndSend(
          prescriptionId: docRef.id,
          lat: position?.latitude ?? 0,
          lng: position?.longitude ?? 0,
        );

        await FirebaseFirestore.instance.collection('fcm_messages').add({
          'to': 'pharmacy',
          'title': 'New Prescription',
          'body': 'A user uploaded a prescription',
          'prescriptionId': docRef.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint("Prescription pharmacy request failed: $e");
      }

      if (!mounted) return;
      setState(() {
        _image = null;
        _imageBytes = null;
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Prescription uploaded successfully")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const UserResponseScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: ${_friendlyError(e)}")),
      );
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString();

    if (message.contains('permission-denied') ||
        message.contains('unauthorized')) {
      return "Firebase permission denied. Check Storage/Firestore rules.";
    }

    if (message.contains('app-check') || message.contains('AppCheck')) {
      return "Firebase App Check blocked the request.";
    }

    if (message.contains('TimeoutException')) {
      return "Upload timed out. Check your internet connection.";
    }

    return message;
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
              onTap:
                  _isUploading ? null : () => _pickImage(ImageSource.gallery),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: _imageBytes != null
                    ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                    : const Center(child: Text("Tap to select image")),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              _isUploading ? "Uploading..." : "Upload Prescription",
              onPressed: uploadPrescription,
              isLoading: _isUploading,
            ),
          ],
        ),
      ),
    );
  }
}
