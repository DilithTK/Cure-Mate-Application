import 'package:flutter/material.dart';
import '../../Phamacist/pharmacy_dashboard.dart';
import 'package:curemate_app/core/services/firebase_auth_service.dart';

class PharmacySignupScreen extends StatefulWidget {
  const PharmacySignupScreen({super.key});

  @override
  State<PharmacySignupScreen> createState() =>
      _PharmacySignupScreenState();
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

  bool isValidEmail(String email) {
    final regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return regex.hasMatch(email.trim());
  }

  Future<void> signupPharmacy() async {
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (nameController.text.isEmpty ||
        registrationController.text.isEmpty ||
        email.isEmpty ||
        mobileController.text.isEmpty ||
        password.isEmpty ||
        locationController.text.isEmpty) {
      showMsg("Please fill all fields");
      return;
    }

    if (!isValidEmail(email)) {
      showMsg("Invalid email format");
      return;
    }

    if (password.length < 6) {
      showMsg("Password must be at least 6 characters");
      return;
    }

    if (password != confirmPassword) {
      showMsg("Passwords do not match");
      return;
    }

    if (!agree) {
      showMsg("Please accept Terms & Conditions");
      return;
    }

    setState(() => isLoading = true);

    String? result = await _authService.pharmacySignUp(
      nameController.text.trim(),
      registrationController.text.trim(),
      email,
      password,
      mobileController.text.trim(),
      locationController.text.trim(),
    );

    if (!mounted) return;

    setState(() => isLoading = false);

    if (result == null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const PharmacyDashboardScreen(),
        ),
        (route) => false,
      );
    } else {
      showMsg(result);
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                Image.asset("assets/images/logo.png", height: 100),

                const SizedBox(height: 15),

                const Text(
                  "Pharmacy Sign Up",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 25),

                buildField("Pharmacy Name", nameController),
                buildField("Registration Number", registrationController),
                buildField("Email", emailController),
                buildField("Mobile", mobileController),
                buildField("Password", passwordController, isPassword: true),
                buildField(
                    "Confirm Password", confirmPasswordController,
                    isPassword: true),
                buildField("Location", locationController),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Checkbox(
                      value: agree,
                      onChanged: (v) =>
                          setState(() => agree = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        "I agree to Terms & Conditions",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : signupPharmacy,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up"),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
