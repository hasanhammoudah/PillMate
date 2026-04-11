import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle label = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.labelText,
  );

  static TextStyle fieldHint = TextStyle(
    fontSize: 16.sp,
    color: AppColors.hintText,
  );

  static TextStyle buttonText = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  static TextStyle tagline = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static TextStyle bottomLink = TextStyle(
    fontSize: 14.sp,
    color: AppColors.primary,
  );

  static TextStyle stepSubtitle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
}
