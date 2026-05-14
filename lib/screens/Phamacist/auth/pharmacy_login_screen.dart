import 'package:flutter/material.dart';

import '../../Phamacist/auth/pharmacy_signup_screen.dart';
import '../../auth/ForgotPasswordScreen.dart';
import '../../Phamacist/pharmacy_dashboard.dart';

class PharmacyLoginScreen extends StatefulWidget {
  const PharmacyLoginScreen({super.key});

  @override
  State<PharmacyLoginScreen> createState() =>
      _PharmacyLoginScreenState();
}

class _PharmacyLoginScreenState
    extends State<PharmacyLoginScreen> {

  bool isLoading = false;
  bool obscurePassword = true;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  Future<void> loginUser() async {

    setState(() {
      isLoading = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
              PharmacyDashboardScreen(),
      ),
    );
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

            colors: [
              Color(0xFF7DA7A7),
              Color(0xFFDCE8E7),
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),

              child: Column(
                children: [

                  const SizedBox(height: 70),

                  

                  Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20),

                

                  const Text(
                    "WELCOME",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 40),

                 

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),

                      borderRadius:
                          BorderRadius.circular(22),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller: emailController,

                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),

                      decoration: InputDecoration(
                        hintText: "Email Address",

                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                        ),

                        border: InputBorder.none,

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 22,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),

                      borderRadius:
                          BorderRadius.circular(22),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,

                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),

                      decoration: InputDecoration(
                        hintText: "Password",

                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                        ),

                        border: InputBorder.none,

                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 22,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,

                            color: Colors.grey,
                          ),

                          onPressed: () {

                            setState(() {
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  

                  SizedBox(
                    width: double.infinity,
                    height: 65,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF6C9E9F),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),

                        elevation: 6,
                      ),

                      onPressed:
                          isLoading
                              ? null
                              : loginUser,

                      child: Text(
                        isLoading
                            ? "Loading..."
                            : "Log in",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  

                  Align(
                    alignment: Alignment.centerRight,

                    child: GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const ForgotPasswordScreen(),
                          ),
                        );
                      },

                      child: const Text(
                        "Forgot Password?",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(
                        "Don't have an account? ",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),

                      GestureDetector(
                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const PharmacySignupScreen(),
                            ),
                          );
                        },

                        child: const Text(
                          "Sign Up",

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  

                  //const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}