import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class BackgroundDecoration extends StatelessWidget {
  final Widget child;

  const BackgroundDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          // Top-left large circle
          Positioned(
            top: -size.width * 0.25,
            left: -size.width * 0.25,
            child: _circle(size.width * 0.6),
          ),
          // Bottom-left medium circle
          Positioned(
            bottom: size.height * 0.08,
            left: -size.width * 0.15,
            child: _circle(size.width * 0.38),
          ),
          // Bottom-right small circle
          Positioned(
            bottom: size.height * 0.18,
            right: -size.width * 0.08,
            child: _circle(size.width * 0.22),
          ),
          // Top-right tiny dot circle
          Positioned(
            top: size.height * 0.22,
            right: size.width * 0.08,
            child: _dotCircle(size.width * 0.06),
          ),
          // Left mid dot circle
          Positioned(
            top: size.height * 0.42,
            left: size.width * 0.06,
            child: _dotCircle(size.width * 0.05),
          ),
          child,
        ],
      ),
    );
  }

  Widget _circle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.circleOutline, width: 1.5),
      ),
    );
  }

  Widget _dotCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.circleOutline,
      ),
    );
  }
}
