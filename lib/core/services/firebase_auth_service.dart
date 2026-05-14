import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
=======

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService.instance;

<<<<<<< HEAD
  
  // EMAIL VALIDATION 
  
  bool _isValidEmail(String email) {
    email = email.trim().toLowerCase();

    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email);
  }

 
  // USER SIGNUP
 
=======
  // 🔹 USER SIGN UP
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<String?> signUp(
    String name,
    String email,
    String password,
    String mobile,
    String location,
  ) async {
    try {
<<<<<<< HEAD
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
=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        "createdAt": FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Auth error occurred";
    } catch (e) {
      return e.toString();
    }
  }

<<<<<<< HEAD
 
  // PHARMACY SIGNUP
  
=======
  // 🔥 PHARMACY SIGN UP
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<String?> pharmacySignUp(
    String name,
    String registrationNo,
    String email,
    String password,
    String mobile,
    String location,
  ) async {
    try {
<<<<<<< HEAD
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

=======
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

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Signup failed";
    } catch (e) {
      return e.toString();
    }
  }

<<<<<<< HEAD
  
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
=======
  // 🔹 LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Login failed";
    } catch (e) {
      return e.toString();
    }
  }

<<<<<<< HEAD
  
  // LOGOUT

=======
  // 🔹 LOGOUT
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<void> logout() async {
    await _auth.signOut();
  }

<<<<<<< HEAD
  
  // CURRENT USER
  
  User? get currentUser => _auth.currentUser;
}
=======
  // 🔹 GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
