import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

/// A wide stadium-shaped (fully-curved-ends) dark navy button used on the
/// welcome / start screen. Visually distinct from the full-width pill buttons
/// used on other screens because it is centred with breathing room on both
/// sides, giving it a pronounced curved-lens appearance.
class CurvedStartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CurvedStartButton({
    super.key,
    required this.onPressed,
    this.label = 'البدء',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260.w,
        height: 64.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.35),
            // StadiumBorder gives maximum curvature on both ends
            shape: const StadiumBorder(),
          ),
          child: Text(label, style: AppTextStyles.buttonText),
        ),
      ),
    );
  }
}
