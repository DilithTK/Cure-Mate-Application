import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService.instance;

  // 🔹 USER SIGN UP
  Future<String?> signUp(
    String name,
    String email,
    String password,
    String mobile,
    String location,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 🔥 Save normal user
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": name,
        "email": email,
        "mobile": mobile,
        "location": location,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Auth error occurred";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔥 PHARMACY SIGN UP
  Future<String?> pharmacySignUp(
    String name,
    String registrationNo,
    String email,
    String password,
    String mobile,
    String location,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 🔥 Save pharmacy to Firestore
      await _firestore.addPharmacyWithId(
        uid: uid,
        name: name,
        registrationNo: registrationNo,
        email: email,
        mobile: mobile,
        location: location,
      );

      //await FirebaseFirestore.instance.collection("pharmacies").doc(uid).update(
       // {"registrationNo": registrationNo},
      //);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup failed";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔹 LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

  // 🔹 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // 🔹 GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}
