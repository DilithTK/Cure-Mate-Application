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
    final p = data.data() as Map<String, dynamic>;

    final status = p['status'] ?? 'Pending';

    final isPending = status == "Pending";

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          children: [

            // TOP
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                Text(
                  data.id,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: isPending
                        ? AppColors.warning
                            .withOpacity(0.15)
                        : AppColors.success
                            .withOpacity(0.15),

                    borderRadius:
                        BorderRadius.circular(30),
                  ),

                  child: Text(
                    status,

                    style: TextStyle(
                      fontWeight: FontWeight.w600,

                      color: isPending
                          ? AppColors.warning
                          : AppColors.success,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color:
                        AppColors.secondary,

                    borderRadius:
                        BorderRadius.circular(14),
                  ),

                  child: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        p['patientName'] ??
                            'Unknown Patient',

                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        p['date'] ?? 'No Date',

                        style: const TextStyle(
                          color:
                              AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  p['time'] ?? '',

                  style: const TextStyle(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}