import 'package:flutter/material.dart';
import '../core/theme/color.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool useImage;

  const AppBackground({
    super.key,
    required this.child,
    this.useImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: useImage
            ? null
            : AppColors.backgroundGradient,
        image: useImage
            ? const DecorationImage(
                image: AssetImage('assets/images/BackgroundImage.png'),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}