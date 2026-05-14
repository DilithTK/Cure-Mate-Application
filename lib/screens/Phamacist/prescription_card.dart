import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/theme/color.dart';

class PrescriptionCard extends StatelessWidget {

  final DocumentSnapshot data;
  final VoidCallback onTap;

  const PrescriptionCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final p =
        data.data() as Map<String, dynamic>;

    final patientName =
        p['patientName'] ?? "Unknown Patient";

    final status =
        p['status'] ?? "Pending";

    final timestamp = p['createdAt'];

    String formattedDate = "No Date";

    if (timestamp != null &&
        timestamp is Timestamp) {

      final date = timestamp.toDate();

      formattedDate =
          "${date.day}/${date.month}/${date.year}";
    }

    final isPending =
        status.toString().toLowerCase()
        == "pending";

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
                  Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            // ===============================
            // ICON
            // ===============================

            Container(

              padding:
                  const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.secondary,

                borderRadius:
                    BorderRadius.circular(18),
              ),

              child: const Icon(
                Icons.medical_services,
                color: AppColors.primary,
                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            // ===============================
            // DETAILS
            // ===============================

            Expanded(
              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    patientName,

                    maxLines: 1,

                    overflow:
                        TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 8),

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
                          formattedDate,

                          overflow:
                              TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: AppColors
                                .textMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ===============================
            // STATUS
            // ===============================

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