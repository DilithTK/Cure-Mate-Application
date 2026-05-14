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
<<<<<<< HEAD
  final registrationController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final locationController = TextEditingController();

  bool agree = false;
=======

  final registrationController = TextEditingController();

  final emailController = TextEditingController();

  final mobileController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final locationController = TextEditingController();

  bool agree = false;

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  bool isLoading = false;

  final AuthService _authService = AuthService();

<<<<<<< HEAD
 
  // EMAIL VALIDATION
 
  bool isValidEmail(String email) {
    final regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return regex.hasMatch(email.trim());
  }

 
  Future<void> signupPharmacy() async {
    try {
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
        showMsg("Please enter valid email (example@gmail.com)");
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
        nameController.text,
        registrationController.text,
        email,
        password,
        mobileController.text,
        locationController.text,
      );

      setState(() => isLoading = false);

      if (result == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>  PharmacyDashboardScreen(),
          ),
          (route) => false,
        );
      } else {
        showMsg(result);
      }
    } catch (e) {
      setState(() => isLoading = false);
      showMsg("Error: $e");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  @override
  void dispose() {
    nameController.dispose();
<<<<<<< HEAD
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
=======

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

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
<<<<<<< HEAD
            colors: [Color(0xFF6D9EA0), Color(0xFFD4E2E1)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
=======

            colors: [Color(0xFF6D9EA0), Color(0xFFD4E2E1)],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            child: Column(
              children: [
                const SizedBox(height: 20),

<<<<<<< HEAD
                Image.asset("assets/images/logo.png", height: 100),

                const SizedBox(height: 15),

                const Text(
                  "Pharmacy Sign Up",
                  style: TextStyle(
                    fontSize: 28,
=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),

<<<<<<< HEAD
                const SizedBox(height: 30),

                buildField("Pharmacy Name", nameController),
                buildField("Registration Number", registrationController),
                buildField(
                  "Email Address",
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                buildField(
                  "Mobile Number",
                  mobileController,
                  keyboardType: TextInputType.phone,
                ),
                buildField("Password", passwordController, isPassword: true),
                buildField(
                    "Confirm Password", confirmPasswordController,
                    isPassword: true),
                buildField("Location", locationController),

                const SizedBox(height: 10),

=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                Row(
                  children: [
                    Checkbox(
                      value: agree,
<<<<<<< HEAD
                      onChanged: (v) =>
                          setState(() => agree = v ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        "I agree to Terms & Conditions",
=======

                      onChanged: (v) {
                        setState(() {
                          agree = v ?? false;
                        });
                      },
                    ),

                    const Expanded(
                      child: Text(
                        "I agree to the Terms & Conditions.",

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

<<<<<<< HEAD
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5D8D90),
                    ),
                    onPressed: isLoading ? null : signupPharmacy,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
=======
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

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
<<<<<<< HEAD
=======

                const SizedBox(height: 30),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
              ],
            ),
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
 
  Widget buildField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
