import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';

/// Empty-state view shown in the medication list when no medications exist.
class EmptyMedicationView extends StatelessWidget {
  final VoidCallback onAddFirst;

  const EmptyMedicationView({super.key, required this.onAddFirst});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        // Primary CTA
        Center(
          child: ElevatedButton.icon(
            onPressed: onAddFirst,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'اضافة اول دواء',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              padding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              elevation: 3,
              shadowColor: AppColors.accentCyan.withValues(alpha: 0.4),
            ),
          ),
        ),
        const Spacer(),
        // Illustration
        SvgPicture.asset(
          AppAssets.frame2,
          width: 180.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
}
