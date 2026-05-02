import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  // 🔹 SIGN UP (UPDATED WITH ROLE)
  Future<String?> signUp(
    String name,
    String email,
    String password,
    String mobile,
    String location,
    String role,
    String? pharmacyId,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.addUserWithId(
        uid,
        name,
        email,
        mobile,
        location,
        role,
        pharmacyId ?? "",
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Auth error occurred";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔹 LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔥 NEW: GET USER ROLE (FIX)
  Future<String?> getUserRole() async {
    try {
      String uid = _auth.currentUser!.uid;

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc["role"];
      }
    } catch (e) {
      print("Error getting role: $e");
    }

    return null;
  }

  // 🔹 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔹 GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}