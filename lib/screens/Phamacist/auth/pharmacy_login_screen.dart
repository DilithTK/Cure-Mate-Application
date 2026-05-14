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
<<<<<<< HEAD
  bool obscurePassword = true;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();
=======
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  Future<void> loginUser() async {

    setState(() {
      isLoading = true;
    });

<<<<<<< HEAD
=======
    // DEMO LOADING
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
    await Future.delayed(
      const Duration(seconds: 2),
    );

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
<<<<<<< HEAD
      context,
      MaterialPageRoute(
        builder: (_) =>
              PharmacyDashboardScreen(),
      ),
    );
=======
    context,

    MaterialPageRoute(
      builder: (_) =>
          const PharmacyDashboardScreen(),
    ),
  );
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
<<<<<<< HEAD
=======
      backgroundColor: Colors.transparent,

>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
<<<<<<< HEAD
              Color(0xFF7DA7A7),
              Color(0xFFDCE8E7),
=======
              Color(0xFF6D9EA0),
              Color(0xFFBFD4D2),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
<<<<<<< HEAD
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
=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
<<<<<<< HEAD
                                const ForgotPasswordScreen(),
=======
                                const PharmacySignupScreen(),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                          ),
                        );
                      },

                      child: const Text(
<<<<<<< HEAD
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
=======
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
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            ),
          ),
        ),
      ),
    );
  }
}