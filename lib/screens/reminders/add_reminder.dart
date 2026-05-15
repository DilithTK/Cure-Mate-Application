import 'package:flutter/material.dart';
import '../../core/theme/color.dart';
import '../../models/reminder_model.dart';
import '../../core/services/notification_service.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();

  TimeOfDay? selectedTime;
  String selectedFrequency = "Daily";

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  void _saveReminder() async {
    if (_medicineController.text.isEmpty ||
        _dosageController.text.isEmpty ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final now = DateTime.now();

    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final reminder = ReminderModel(
      title: _medicineController.text,
      time: scheduledDate,
      dosage: _dosageController.text,
      frequency: selectedFrequency,
    );

    await NotificationService.scheduleReminder(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: "Medicine Reminder 💊",
      body:
          "${reminder.title} - ${reminder.dosage} (${reminder.frequency})",
      dateTime: scheduledDate,
    );

    if (!mounted) return;

    Navigator.pop(context, reminder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6FA5A8), // top color
              Color(0xFFE4F1F2), // bottom color
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Add Reminder",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// MEDICINE NAME
                _label("Medicine Name"),
                _input(
                  controller: _medicineController,
                  hint: "e.g. Amoxicillin",
                ),

                const SizedBox(height: 20),

                /// DOSAGE + TIME
                _label("Dosage & Time"),
                Row(
                  children: [
                    Expanded(
                      child: _input(
                        controller: _dosageController,
                        hint: "e.g. 500mg",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickTime,
                        child: _input(
                          hint: selectedTime == null
                              ? "Select time"
                              : selectedTime!.format(context),
                          icon: Icons.access_time,
                          enabled: false,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                /// FREQUENCY
                _label("Frequency"),
                Row(
                  children: [
                    _frequencyButton("Daily"),
                    _frequencyButton("Weekly"),
                    _frequencyButton("As Needed"),
                  ],
                ),

                const SizedBox(height: 40),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E8E83),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _saveReminder,
                    child: const Text(
                      "Save Reminder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );

  Widget _input({
    required String hint,
    TextEditingController? controller,
    IconData? icon,
    bool enabled = true,
  }) =>
      TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: icon != null ? Icon(icon) : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget _frequencyButton(String value) {
    final bool isSelected = selectedFrequency == value;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedFrequency = value;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFB8F1EC) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color:
                      isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
