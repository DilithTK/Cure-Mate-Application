import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Add User (FULL VERSION)
  Future<void> addUserWithId(
    String uid,
    String name,
    String email,
    String mobile,
    String location,
    String role,          // ✅ MUST be here
    String? pharmacyId,
  ) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'location': location,
      'role': role, // default role
      'pharmacyId': pharmacyId,
      'createdAt': Timestamp.now(),
    });
  }

  // 🔹 Get Users (all users stream)
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }

  // 🔹 Get single user (optional but useful)
  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection('users').doc(uid).get();
  }

  // 🔹 Update user (optional future use)
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }
}