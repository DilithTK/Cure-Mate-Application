import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../../core/theme/color.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/social_row.dart';
import '../../core/services/firebase_auth_service.dart';
import 'signup_screen.dart';
import '../auth/ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  bool isLoading = false;

  void loginUser() async {
    setState(() => isLoading = true);

    String? result = await _authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful")),
      );

<<<<<<< HEAD
      
=======
      // 🔥 NO ROLE LOGIC → DIRECT HOME
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
              child: Image.asset('assets/images/logo.png', height: 100),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "WELCOME",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ),

            const SizedBox(height: 40),

            CustomTextField(
              "Email Address",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

            CustomTextField(
              "Password",
              isPassword: true,
              controller: passwordController,
            ),

            const SizedBox(height: 20),

            CustomButton(
              isLoading ? "Loading..." : "Log in",
              onPressed: isLoading ? null : loginUser,
            ),

            const SizedBox(height: 15),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white70),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

<<<<<<< HEAD
            const SizedBox(height: 60),
=======
            const SizedBox(height: 30),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

            const SocialRow(),
          ],
        ),
      ),
    );
  }
}