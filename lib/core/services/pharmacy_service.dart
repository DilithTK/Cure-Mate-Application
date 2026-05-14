import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyService {
  Future<void> findNearbyAndSend({
    required String prescriptionId,
    required double lat,
    required double lng,
  }) async {
    // 🔥 TEMP LOGIC (later improve karanna puluwan)

    final pharmacies =
        await FirebaseFirestore.instance.collection('pharmacies').get();

    for (var doc in pharmacies.docs) {
      await FirebaseFirestore.instance
          .collection('pharmacy_requests')
          .add({
        'pharmacyId': doc.id,
        'prescriptionId': prescriptionId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}