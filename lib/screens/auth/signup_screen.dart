import 'package:flutter/material.dart';
import '../../core/theme/color.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_row.dart';
import '../../core/services/firebase_auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool agreeTerms = false;
  bool isLoading = false;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final AuthService _authService = AuthService();

  // SIGNUP FUNCTION
  void signUpUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    String? result = await _authService.signUp(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      mobileController.text.trim(),
      locationController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
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
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: ListView(
          children: [
            const SizedBox(height: 60),

            Center(
              child: Image.asset(
                "assets/images/logo.png",
                height: 100,
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),

            const SizedBox(height: 30),

            CustomTextField("Full Name", controller: nameController),
            const SizedBox(height: 15),

            CustomTextField("Email Address", controller: emailController),
            const SizedBox(height: 15),

            CustomTextField("Mobile Number", controller: mobileController),
            const SizedBox(height: 15),

            CustomTextField(
              "Password",
              isPassword: true,
              controller: passwordController,
            ),
            const SizedBox(height: 15),

            CustomTextField(
              "Confirm Password",
              isPassword: true,
              controller: confirmPasswordController,
            ),
            const SizedBox(height: 15),

            CustomTextField("Location", controller: locationController),

            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: agreeTerms,
                  onChanged: (val) {
                    setState(() {
                      agreeTerms = val ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
                const Expanded(
                  child: Text(
                    "I agree to the Terms & Conditions",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            CustomButton(
              isLoading ? "Loading..." : "Sign Up",
              onPressed: (agreeTerms && !isLoading) ? signUpUser : null,
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Already have an account? Log In",
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const SocialRow(),
          ],
        ),
      ),
    );
  }
}