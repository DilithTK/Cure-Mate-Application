import 'package:flutter/material.dart';
import '../../core/theme/color.dart';

class FindPharmaciesScreen extends StatelessWidget {
  const FindPharmaciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Pharmacies"),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text("Find Pharmacies Screen"),
      ),
    );
  }
}