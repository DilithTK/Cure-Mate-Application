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

  Future<void> loginUser() async {

    setState(() {
      isLoading = true;
    });

    // DEMO LOADING
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
          const PharmacyDashboardScreen(),
    ),
  );
  }

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

            colors: [
              Color(0xFF6D9EA0),
              Color(0xFFBFD4D2),
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),

            child: Column(
              children: [

                const SizedBox(height: 30),

                /// LOGO

                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 120,
                  ),
                ),

                const SizedBox(height: 20),

                /// TITLE

                const Text(
                  "WELCOME",

                  style: TextStyle(
                    fontSize: 34,
                    letterSpacing: 2,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                const SizedBox(height: 50),

                /// EMAIL FIELD

                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText:
                        "Pharmacy Email Address",

                    filled: true,

                    fillColor:
                        Colors.white.withOpacity(
                      0.15,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        5,
                      ),

                      borderSide:
                          BorderSide.none,
                    ),

                    hintStyle:
                        const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// PASSWORD FIELD

                TextField(
                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: "Password",

                    filled: true,

                    fillColor:
                        Colors.white.withOpacity(
                      0.15,
                    ),

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        5,
                      ),

                      borderSide:
                          BorderSide.none,
                    ),

                    hintStyle:
                        const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// FORGOT PASSWORD

                Align(
                  alignment: Alignment.centerLeft,

                  child: TextButton(
                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const ForgotPasswordScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      "Forgot Password ?",

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN BUTTON

                SizedBox(
                  width: 180,
                  height: 45,

                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF5D8D90,
                      ),

                      disabledBackgroundColor:
                          const Color(
                        0xFF5D8D90,
                      ),
                    ),

                    onPressed:
                        isLoading
                            ? null
                            : loginUser,

                    child: Text(
                      isLoading
                          ? "Loading..."
                          : "Log In",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// SIGN UP

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    const Text(
                      "Don't have an account ? ",

                      style: TextStyle(
                        color: Colors.white,
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
                          fontWeight:
                              FontWeight.bold,
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
}