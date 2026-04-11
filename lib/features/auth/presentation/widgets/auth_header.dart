import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';

class AuthHeader extends StatelessWidget {
  final bool showArrow;
  final VoidCallback? onArrowTap;

  const AuthHeader({super.key, this.showArrow = false, this.onArrowTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: const AppLogo(),
        ),
        if (showArrow)
          Positioned(
            top: 12.h,
            right: 0,
            child: GestureDetector(
              onTap: onArrowTap,
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
