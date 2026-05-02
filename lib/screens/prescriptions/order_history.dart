import 'package:flutter/material.dart';
import '../../core/theme/color.dart';
import '../../models/myorder_model.dart';


class MyPrescriptionsScreen extends StatelessWidget {
   const MyPrescriptionsScreen({super.key});

  // Sample orders
  static List<Order> orders = [
    Order(
      id: "ORD12345",
      date: "2026-03-10 10:15 AM",
      status: "Delivered",
      items: ["Paracetamol 500mg", "Vitamin C 1000mg"],
    ),
    Order(
      id: "ORD12346",
      date: "2026-03-08 02:30 PM",
      status: "Pending",
      items: ["Cough Syrup", "Zinc Tablets"],
    ),
    Order(
      id: "ORD12347",
      date: "2026-03-05 11:45 AM",
      status: "Cancelled",
      items: ["Ibuprofen 200mg"],
    ),
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "Delivered":
        return Icons.check_circle_outline;
      case "Pending":
        return Icons.hourglass_bottom;
      case "Cancelled":
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.background,
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.id,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Icon(
                              _statusIcon(order.status),
                              color: _statusColor(order.status),
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              order.status,
                              style: TextStyle(
                                  color: _statusColor(order.status),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Date
                    Text(
                      order.date,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 10),

                    // Items
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: order.items
                          .map(
                            (item) => Chip(
                              label: Text(item),
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              labelStyle: const TextStyle(
                                  color: AppColors.primary, fontSize: 12),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 10),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // TODO: View order details
                          },
                          icon: const Icon(Icons.visibility, size: 18),
                          label: const Text("View"),
                        ),
                        const SizedBox(width: 10),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Reorder
                          },
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text("Reorder"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}