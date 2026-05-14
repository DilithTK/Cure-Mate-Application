import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/firestore_service.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../core/theme/color.dart';
import 'edit_profile_screen.dart';
import '../auth/login_screen.dart';
<<<<<<< HEAD
import '../../screens/splash/role_selection_screen.dart';
=======
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirestoreService.instance;
    final authService = AuthService();

    if (user == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF6C8E8B),
      body: SafeArea(
        child: FutureBuilder(
          future: firestore.getUser(user.uid),
          builder: (context, snapshot) {
<<<<<<< HEAD
            
=======
            // 🔄 Loading
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

<<<<<<< HEAD
            
=======
            // ❌ Error
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading profile"));
            }

<<<<<<< HEAD
            
=======
            // ❌ No data
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No user data found"));
            }

<<<<<<< HEAD
            
=======
            // ✅ Data
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              children: [
                const SizedBox(height: 20),

                // Header
                const Text(
                  "My Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          AssetImage('assets/images/user_avatar.png'),
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.white, width: 3),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

<<<<<<< HEAD
                //  Name FROM FIRESTORE
=======
                // 👤 Name (FROM FIRESTORE)
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                Text(
                  data['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

<<<<<<< HEAD
                
=======
                // 📧 Email (FROM FIRESTORE)
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                Text(
                  data['email'] ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 40),

<<<<<<< HEAD
               
=======
                // Buttons
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildPrimaryButton(context),
                      const SizedBox(height: 16),
                      _buildSecondaryButton(),
                      const SizedBox(height: 16),

<<<<<<< HEAD
                      //  LOGOUT BUTTON
=======
                      // 🔥 LOGOUT BUTTON
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
                      _buildLogoutButton(context, authService),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

<<<<<<< HEAD
  //  Edit Profile
=======
  // ✏️ Edit Profile
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Widget _buildPrimaryButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EditProfileScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2F6BFF), Color(0xFF3D7BFF)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  //  Orders
=======
  // 📦 Orders
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Widget _buildSecondaryButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined),
          SizedBox(width: 10),
          Text(
            "My Orders",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  //  LOGOUT
=======
  // 🔥 LOGOUT
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Widget _buildLogoutButton(
      BuildContext context, AuthService authService) {
    return InkWell(
      onTap: () async {
        await authService.logout();

        Navigator.pushAndRemoveUntil(
          context,
<<<<<<< HEAD
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
=======
          MaterialPageRoute(builder: (_) => const LoginScreen()),
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
          (route) => false,
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}