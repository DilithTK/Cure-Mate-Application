import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/color.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> resetPassword() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter your email")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      String email = emailController.text.trim();

      // 🔥 1. Send reset email (MAIN METHOD)
      await _auth.sendPasswordResetEmail(email: email);

      // 🔥 2. OPTIONAL: update Firestore user status (NOT password)
      QuerySnapshot userDoc = await _firestore
          .collection("users")
          .where("email", isEqualTo: email)
          .get();

      for (var doc in userDoc.docs) {
        await doc.reference.update({
          "passwordResetRequested": true,
          "lastResetRequest": FieldValue.serverTimestamp(),
        });
      }

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password reset link sent to email"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: ListView(
          children: [
            const SizedBox(height: 80),

            const Center(
              child: Text(
                "FORGOT PASSWORD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 40),

            CustomTextField(
              "Enter your email",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 25),

            CustomButton(
              isLoading ? "Sending..." : "Send Reset Link",
              onPressed: isLoading ? null : resetPassword,
            ),

            const SizedBox(height: 20),

            const Text(
              "Check your email inbox for reset link",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}