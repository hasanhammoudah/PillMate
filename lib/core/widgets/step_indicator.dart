import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class StepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final String subtitle;

  const StepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector is active only when BOTH adjacent circles are active.
              // The right-side circle displayStep = totalSteps - (index ~/ 2).
              // It is active when that displayStep <= currentStep.
              final lineStep = index ~/ 2 + 1;
              final isActive = (totalSteps - lineStep + 1) <= currentStep;
              return Container(
                width: 40.w,
                height: 2.h,
                color: isActive ? AppColors.stepActive : AppColors.stepInactive,
              );
            }
            final step = index ~/ 2 + 1;
            // Steps count from right: step 1 is rightmost
            final displayStep = totalSteps - step + 1;
            final isActive = displayStep <= currentStep;
            return _StepCircle(
              step: displayStep,
              isActive: isActive,
            );
          }),
        ),
        SizedBox(height: 6.h),
        Text(subtitle, style: AppTextStyles.stepSubtitle),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int step;
  final bool isActive;

  const _StepCircle({required this.step, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.stepActive : AppColors.stepInactive,
      ),
      alignment: Alignment.center,
      child: Text(
        '$step',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
