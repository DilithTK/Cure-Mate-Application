import 'package:flutter/material.dart'; 
import '../../core/theme/color.dart'; 
import '../../models/reminder_model.dart'; 
import 'add_reminder.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  final List<ReminderModel> reminders = [];

  void _addReminder() async {
    final result = await Navigator.push<ReminderModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddReminderScreen()),
    );

    if (result != null) {
      setState(() => reminders.add(result));
    }
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
              Color(0xFF6FA3A7),
              Color(0xFFB8D6D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Reminders",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    reminders.isEmpty
                        ? const Center(
                            child: Text("No reminders added"),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: reminders.length,
                              itemBuilder: (context, index) {
                                final r = reminders[index];
                                return _reminderCard(r);
                              },
                            ),
                          ),
                  ],
                ),
              ),

              Positioned(
                bottom: 24,
                right: 24,
                child: FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: _addReminder,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reminderCard(ReminderModel reminder) {
    final time =
        "${reminder.time.hour.toString().padLeft(2, '0')}:${reminder.time.minute.toString().padLeft(2, '0')}";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.alarm),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Switch(
            value: true,
            activeColor: AppColors.primary,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}