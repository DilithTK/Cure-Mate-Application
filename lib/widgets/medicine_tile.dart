import 'package:flutter/material.dart';

import '../core/theme/color.dart';
import '../models/medicine_model.dart';

class MedicineTile extends StatefulWidget {
  final MedicineModel medicine;

  const MedicineTile({
    super.key,
    required this.medicine,
  });

  @override
  State<MedicineTile> createState() => _MedicineTileState();
}

class _MedicineTileState extends State<MedicineTile> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.medicine.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_rounded, color: AppColors.primary),
              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  "${widget.medicine.name} ${widget.medicine.dosage ?? ''}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            selected == "available"
                ? "Medicine Available"
                : "Medicine Unavailable",
            style: TextStyle(
              color: selected == "available"
                  ? AppColors.success
                  : AppColors.danger,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Radio<String>(
                value: "available",
                groupValue: selected,
                onChanged: (value) {
                  setState(() {
                    selected = value!;
                    widget.medicine.status = value; // ✅ WORKS NOW
                  });
                },
              ),
              const Text("Available"),

              Radio<String>(
                value: "unavailable",
                groupValue: selected,
                onChanged: (value) {
                  setState(() {
                    selected = value!;
                    widget.medicine.status = value; // ✅ WORKS NOW
                  });
                },
              ),
              const Text("Unavailable"),
            ],
          ),
        ],
      ),
    );
  }
}