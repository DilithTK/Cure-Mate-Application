import 'package:cloud_firestore/cloud_firestore.dart';

class PharmacyService {
  Future<void> findNearbyAndSend({
    required String prescriptionId,
    required double lat,
    required double lng,
  }) async {
<<<<<<< HEAD
    
=======
    // 🔥 TEMP LOGIC (later improve karanna puluwan)
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
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