import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/prescription_model.dart';
import '../../screens/Phamacist/prescription_details_screen.dart';

class AppNavigation {

  static final GlobalKey<NavigatorState>
      navigatorKey =
      GlobalKey<NavigatorState>();

  static void openPrescription(
      String prescriptionId) async {

    final doc =
        await FirebaseFirestore.instance
            .collection('prescriptions')
            .doc(prescriptionId)
            .get();

    if (!doc.exists) return;

    final data = doc.data()!;

    final prescription =
        PrescriptionModel(

      id: doc.id,

      patientName:
          data['patientName'] ?? "",

      date:
          data['createdAt'] != null
          ? (data['createdAt']
                  as Timestamp)
              .toDate()
              .toString()
              .split(' ')[0]
          : "",

      imageUrl:
          data['imageUrl'] ?? "",

      status:
          data['status'] ?? "Pending",

      medicines: [],
    );

    navigatorKey.currentState?.push(

      MaterialPageRoute(
        builder: (_) =>
            PrescriptionDetailsScreen(
          prescription: prescription,
        ),
      ),
    );
  }
}