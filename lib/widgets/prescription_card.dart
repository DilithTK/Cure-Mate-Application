import 'package:flutter/material.dart';

import '../core/theme/color.dart';
import '../models/prescription_model.dart';

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

    final status = prescription.status;

    final isPending =
        status.toLowerCase() == "pending";

    return InkWell(

      onTap: onTap,

      borderRadius:
          BorderRadius.circular(24),

      child: Container(

        margin:
            const EdgeInsets.only(bottom: 18),

        padding:
            const EdgeInsets.all(18),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
              BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            // =========================
            // LEFT ICON
            // =========================

            Container(

              padding:
                  const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.secondary,

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Icon(
                Icons.medical_services_rounded,
                color: AppColors.primary,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            // =========================
            // CENTER DETAILS
            // =========================

            Expanded(
              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // PATIENT NAME
                  Text(
                    prescription.patientName,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DATE ROW
                  Row(
                    children: [

                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                        color:
                            AppColors.textLight,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          prescription.date,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            color:
                                AppColors.textMedium,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // =========================
            // STATUS BADGE
            // =========================

            Container(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              decoration: BoxDecoration(

                color: isPending
                    ? AppColors.warningLight
                    : AppColors.successLight,

                borderRadius:
                    BorderRadius.circular(30),
              ),

              child: Text(
                status,

                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,

                  fontSize: 13,

                  color: isPending
                      ? AppColors.warning
                      : AppColors.success,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

