import 'package:flutter/material.dart';
import '../core/theme/color.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
<<<<<<< HEAD
  final VoidCallback? onTap; 
=======
  final VoidCallback? onTap; // optional tap callback
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
<<<<<<< HEAD
      onTap: onTap, 
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.25), 
=======
      onTap: onTap, // safely handle taps if provided
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.25), // semi-transparent white
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: AppColors.white.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 28,
<<<<<<< HEAD
                color: AppColors.primary, 
=======
                color: AppColors.primary, // use your brand color
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
<<<<<<< HEAD
                color: Colors.white, 
=======
                color: Colors.white, // matches your gradient/modern UI
>>>>>>> f4fc04c1468aff1b3df4e77ae03e18fc2e8503f0
              ),
            ),
          ],
        ),
      ),
    );
  }
}