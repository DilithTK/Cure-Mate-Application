import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class FirestoreService {
<<<<<<< HEAD
  
=======
  // ===================================================
  // SINGLETON
  // ===================================================
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

<<<<<<< HEAD
  
  // FIREBASE INSTANCES
  
=======
  // ===================================================
  // FIREBASE INSTANCES
  // ===================================================
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GeoFlutterFire geo = GeoFlutterFire();

<<<<<<< HEAD
  
  // ADD NORMAL USER
  
=======
  // ===================================================
  // ADD NORMAL USER
  // ===================================================

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
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
<<<<<<< HEAD
      
=======
      'role': 'user',
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      'createdAt': Timestamp.now(),
    });
  }

<<<<<<< HEAD
  
  // ADD PHARMACY
  
=======
  // ===================================================
  // ADD PHARMACY
  // ===================================================

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
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

      GeoFirePoint point = geo.point(
        latitude: latitude,
        longitude: longitude,
      );

      await _db.collection('pharmacies').doc(uid).set({
        'uid': uid,
        'name': name,
        'registrationNo': registrationNo,
        'email': email,
        'mobile': mobile,
        'location': location,
        'position': point.data,
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

<<<<<<< HEAD
  
  // GET USERS
  
=======
  // ===================================================
  // GET USERS
  // ===================================================

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _db.collection('users').doc(uid).get();
  }

<<<<<<< HEAD
  
  // UPDATE USER
  
=======
  // ===================================================
  // UPDATE USER
  // ===================================================
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  Future<void> updateUser(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await _db.collection('users').doc(uid).update(data);
  }

<<<<<<< HEAD
  
  // NEARBY PHARMACIES
  
=======
  // ===================================================
  // NEARBY PHARMACIES
  // ===================================================
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  Stream<List<DocumentSnapshot>> getNearbyPharmacies({
    required double lat,
    required double lng,
    double radius = 0.5,
  }) {
    GeoFirePoint center = geo.point(
      latitude: lat,
      longitude: lng,
    );

    return geo
        .collection(collectionRef: _db.collection('pharmacies'))
        .within(
          center: center,
          radius: radius,
          field: 'position',
          strictMode: true,
        );
  }
}