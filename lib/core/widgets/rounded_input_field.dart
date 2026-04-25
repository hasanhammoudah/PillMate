import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/app_colors.dart';

/// Full-width pill-shaped text input field used across family and
/// health-center forms.  RTL-aware: hint and text are right-aligned.
class RoundedInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;

  const RoundedInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 15.sp,
        color: AppColors.primaryDark,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.hintText),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
        filled: true,
        fillColor: AppColors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.r),
          borderSide: BorderSide(
            color: AppColors.borderBlue.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.r),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
        ),
      ),
    );
  }
}
