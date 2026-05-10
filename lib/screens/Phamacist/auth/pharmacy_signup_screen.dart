import 'package:flutter/material.dart';

import '../../Phamacist/pharmacy_dashboard.dart';
import 'package:curemate_app/core/services/firebase_auth_service.dart';

class PharmacySignupScreen extends StatefulWidget {
  const PharmacySignupScreen({super.key});

  @override
  State<PharmacySignupScreen> createState() => _PharmacySignupScreenState();
}

class _PharmacySignupScreenState extends State<PharmacySignupScreen> {
  final nameController = TextEditingController();

  final registrationController = TextEditingController();

  final emailController = TextEditingController();

  final mobileController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final locationController = TextEditingController();

  bool agree = false;

  bool isLoading = false;

  final AuthService _authService = AuthService();

  // =====================================================
  // SIGNUP FUNCTION
  // =====================================================

  void signupPharmacy() async {
    if (nameController.text.isEmpty ||
        registrationController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));

      return;
    }

    if (!agree) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please accept terms")));

      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    String? result = await _authService.pharmacySignUp(
      nameController.text.trim(),

      emailController.text.trim(),
      passwordController.text.trim(),
      mobileController.text.trim(),
      registrationController.text.trim(),
      locationController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      Navigator.pushAndRemoveUntil(
        context,

        MaterialPageRoute(builder: (_) => const PharmacyDashboardScreen()),

        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    nameController.dispose();

    registrationController.dispose();

    emailController.dispose();

    mobileController.dispose();

    passwordController.dispose();

    confirmPasswordController.dispose();

    locationController.dispose();

    super.dispose();
  }

  // =====================================================
  // UI
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [Color(0xFF6D9EA0), Color(0xFFD4E2E1)],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Column(
              children: [
                const SizedBox(height: 20),

                /// LOGO
                Center(
                  child: Image.asset("assets/images/logo.png", height: 110),
                ),

                const SizedBox(height: 20),

                /// TITLE
                const Text(
                  "Pharmacy Sign Up",

                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 35),

                /// PHARMACY NAME
                buildField("Pharmacy Name", nameController),

                const SizedBox(height: 15),

                buildField("Registration Number", registrationController),

                const SizedBox(height: 15),

                /// EMAIL
                buildField("Pharmacy Email Address", emailController),

                const SizedBox(height: 15),

                /// MOBILE
                buildField("Mobile Number", mobileController),

                const SizedBox(height: 15),

                /// PASSWORD
                buildField("Password", passwordController, isPassword: true),

                const SizedBox(height: 15),

                /// CONFIRM PASSWORD
                buildField(
                  "Confirm Password",
                  confirmPasswordController,
                  isPassword: true,
                ),

                const SizedBox(height: 15),

                /// LOCATION
                buildField("Location", locationController),

                const SizedBox(height: 15),

                /// TERMS
                Row(
                  children: [
                    Checkbox(
                      value: agree,

                      onChanged: (v) {
                        setState(() {
                          agree = v ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        "I agree to the Terms & Conditions.",

                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// SIGN UP BUTTON
                SizedBox(
                  width: 180,
                  height: 45,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D8D90),

                      disabledBackgroundColor: const Color(0xFF5D8D90),
                    ),

                    onPressed: isLoading ? null : signupPharmacy,

                    child: Text(
                      isLoading ? "Loading..." : "Sign Up",

                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// LOGIN TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Text(
                      "Already have an Account? ",

                      style: TextStyle(color: Colors.white),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: const Text(
                        "Log In",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // TEXT FIELD
  // =====================================================

  Widget buildField(
    String hint,
    TextEditingController controller, {

    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,

      obscureText: isPassword,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(color: Colors.white70),

        filled: true,

        fillColor: Colors.white.withOpacity(0.15),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
