import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService.instance;

  
  // EMAIL VALIDATION 
  
  bool _isValidEmail(String email) {
    email = email.trim().toLowerCase();

    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

 
  // USER SIGNUP
 
  Future<String?> signUp(
    String name,
    String email,
    String password,
    String mobile,
    String location,
  ) async {
    try {
      email = email.trim().toLowerCase();
      password = password.trim();

      if (!_isValidEmail(email)) {
        return "Invalid email format";
      }

      if (password.length < 6) {
        return "Password must be at least 6 characters";
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": name.trim(),
        "email": email,
        "mobile": mobile.trim(),
        "location": location.trim(),
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Auth error occurred";
    } catch (e) {
      return e.toString();
    }
  }

 
  // PHARMACY SIGNUP
  
  Future<String?> pharmacySignUp(
    String name,
    String registrationNo,
    String email,
    String password,
    String mobile,
    String location,
  ) async {
    try {
      email = email.trim().toLowerCase();
      password = password.trim();

      if (!_isValidEmail(email)) {
        return "Invalid email format";
      }

      if (password.length < 6) {
        return "Password must be at least 6 characters";
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore.addPharmacyWithId(
        uid: uid,
        name: name.trim(),
        registrationNo: registrationNo.trim(),
        email: email,
        mobile: mobile.trim(),
        location: location.trim(),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup failed";
    } catch (e) {
      return e.toString();
    }
  }

  
  // LOGIN
  
  Future<String?> login(String email, String password) async {
    try {
      email = email.trim().toLowerCase();
      password = password.trim();

      if (!_isValidEmail(email)) {
        return "Invalid email format";
      }

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

  
  // LOGOUT

  Future<void> logout() async {
    await _auth.signOut();
  }

  
  // CURRENT USER
  
  User? get currentUser => _auth.currentUser;
}