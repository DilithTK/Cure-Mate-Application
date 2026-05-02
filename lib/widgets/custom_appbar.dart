import 'package:flutter/material.dart';
import '../core/theme/color.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBellTap;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBellTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,

      // 🟢 Logo + Title
      title: Row(
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 26,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // 🔔 Bell + ☰ Menu
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: onBellTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Notifications clicked"),
                  ),
                );
              },
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: onMenuTap ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Menu clicked"),
                  ),
                );
              },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}