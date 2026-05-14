import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/prescription_model.dart';

class PrescriptionService {
  static final _db = FirebaseFirestore.instance;

  static Stream<List<PrescriptionModel>> getPrescriptions() {
    return _db.collection('prescriptions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PrescriptionModel.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }
}