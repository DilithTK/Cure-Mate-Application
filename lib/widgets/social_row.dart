import 'package:flutter/material.dart';

class SocialRow extends StatelessWidget {
  const SocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.facebook, size: 32, color: Colors.blue),
        Icon(Icons.g_mobiledata, size: 40, color: Colors.red),
        Icon(Icons.apple, size: 32, color: Colors.black),
      ],
    );
  }
}