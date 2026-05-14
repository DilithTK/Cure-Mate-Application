import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUserWithId(
    String uid,
    String name,
    String email,
    String mobile,
    String location,
  ) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'location': location,
      'role': 'user',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> addPharmacyWithId({
    required String uid,
    required String name,
    required String registrationNo,
    required String email,
    required String mobile,
    required String location,
  }) async {
    try {
      double latitude = 6.9271;
      double longitude = 79.8612;

      await _db.collection('pharmacies').doc(uid).set({
        'uid': uid,
        'name': name,
        'registrationNo': registrationNo,
        'email': email,
        'mobile': mobile,
        'location': location,

        // ✅ GeoPoint instead of GeoFlutterFire
        'position': GeoPoint(latitude, longitude),
        'latitude': latitude,
        'longitude': longitude,

        'role': 'pharmacy',
        'isApproved': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("✅ Pharmacy saved successfully");
    } catch (e) {
      print("❌ Error saving pharmacy: $e");
      rethrow;
    }
  }

  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

  Future<void> updateUser(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // ⚠️ SIMPLE VERSION (no geoflutterfire)
  Stream<QuerySnapshot> getNearbyPharmacies({
    required double lat,
    required double lng,
    double radiusKm = 5,
  }) {
    // NOTE: Firestore cannot do real radius queries without geohash
    // This is basic fallback (you can improve later)

    return _db.collection('pharmacies').snapshots();
  }
}