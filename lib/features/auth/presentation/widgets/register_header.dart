import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/step_indicator.dart';

/// Header used on all three register screens.
/// Contains the logo (centred), a cyan back arrow (physical top-right),
/// the 3-step progress indicator, and the step subtitle.
class RegisterHeader extends StatelessWidget {
  final int currentStep;
  final String stepTitle;
  final VoidCallback? onArrowTap;

  const RegisterHeader({
    super.key,
    required this.currentStep,
    required this.stepTitle,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onArrowTap,
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
            ),
            // Wrap in LTR so Flutter does NOT auto-mirror this
            // directional icon when RTL Directionality is active.
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 22.sp,
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 12.h,
                  bottom: 8.h,
                  left: 50.w,
                  right: 50.w,
                ),
                child: const AppLogo(),
              ),

              // Physical top-right regardless of RTL
              SizedBox(height: 14.h),
              StepIndicator(
                totalSteps: 3,
                currentStep: currentStep,
                subtitle: stepTitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
