import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResponseScreen extends StatefulWidget {
  final String prescriptionId;

  const ResponseScreen({super.key, required this.prescriptionId});

  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  String selectedStatus = "Available";
  final TextEditingController messageController = TextEditingController();

  Future<void> sendResponse() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    String pharmacyName = userDoc.data()?['name'] ?? 'Pharmacy';

    await FirebaseFirestore.instance
        .collection('prescriptions')
        .doc(widget.prescriptionId)
        .collection('responses')
        .add({
      'pharmacyId': uid,
      'pharmacyName': pharmacyName,
      'availability': selectedStatus,
      'message': messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('prescriptions')
        .doc(widget.prescriptionId)
        .update({
      'status': 'responded',
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Response")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton(
              value: selectedStatus,
              items: ["Available", "Partial", "Unavailable"]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedStatus = val!;
                });
              },
            ),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: "Message"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendResponse,
              child: const Text("Send"),
            )
          ],
        ),
      ),
    );
  }
}