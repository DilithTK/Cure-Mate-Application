import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/color.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../core/services/firestore_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final firestore = FirestoreService.instance;
  final user = FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

<<<<<<< HEAD
  //  LOAD EXISTING DATA FROM FIRESTORE
=======
  // 🔥 LOAD EXISTING DATA FROM FIRESTORE
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<void> loadUserData() async {
    if (user == null) return;

    final doc = await firestore.getUser(user!.uid);

    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      _nameController.text = data['name'] ?? '';
      _emailController.text = data['email'] ?? '';
      _mobileController.text = data['mobile'] ?? '';
      _locationController.text = data['location'] ?? '';

      setState(() {});
    }
  }

<<<<<<< HEAD
  //  SAVE UPDATED DATA
=======
  // 🔥 SAVE UPDATED DATA
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
  Future<void> _saveProfile() async {
    if (user == null) return;

    setState(() => isLoading = true);

    await firestore.updateUser(user!.uid, {
      'name': _nameController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'location': _locationController.text.trim(),
    });

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
            ),
            const SizedBox(height: 16),

<<<<<<< HEAD
           
=======
            // 👤 Name
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            CustomTextField(
              "Full Name",
              controller: _nameController,
            ),
            const SizedBox(height: 16),

<<<<<<< HEAD
            
=======
            // 📧 Email (read only)
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            CustomTextField(
              "Email",
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

<<<<<<< HEAD
            
=======
            // 📱 Mobile
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            CustomTextField(
              "Mobile",
              controller: _mobileController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

<<<<<<< HEAD
            
=======
            // 📍 Location
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            CustomTextField(
              "Location",
              controller: _locationController,
            ),
            const SizedBox(height: 24),

<<<<<<< HEAD
            
=======
            // 🔥 Save button
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
            CustomButton(
              isLoading ? "Saving..." : "Save Changes",
              onPressed: isLoading ? null : _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}