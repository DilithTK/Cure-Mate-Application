import 'package:flutter/material.dart';

import '../core/theme/color.dart';
import '../../models/prescription_model.dart';

class PrescriptionCard extends StatelessWidget {

  final PrescriptionModel prescription;
  final VoidCallback onTap;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  prescription.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  prescription.date,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}