import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final double? height;

  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // start = physical RIGHT in RTL
      children: [
        Text(label, style: AppTextStyles.label),
        SizedBox(height: 8.h),
        Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.input),
            border: Border.all(color: AppColors.inputBorder, width: 2),
            color: AppColors.inputFill,
          ),
          child: TextField(
            controller: controller,
            // When a fixed height container is provided, expand to fill it
            expands: height != null,
            maxLines: height != null ? null : maxLines,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textAlign: TextAlign.right,
            textAlignVertical:
                height != null ? TextAlignVertical.top : TextAlignVertical.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16.sp, color: AppColors.primary),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 14.h,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
