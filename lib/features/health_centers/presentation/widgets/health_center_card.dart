import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/models/health_center_model.dart';

class HealthCenterCard extends StatelessWidget {
  final HealthCenter center;
  final VoidCallback onDelete;

  const HealthCenterCard({
    super.key,
    required this.center,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderBlue.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top row: name (right) + delete (left) ──────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(child: _InfoBox(text: center.name)),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (center.address.isNotEmpty) ...[
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: _InfoBox(text: center.address),
            ),
          ],

          if (center.phone.isNotEmpty) ...[
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: _InfoBox(text: center.phone),
            ),
          ],

          if (center.specialty.isNotEmpty) ...[
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: _InfoBox(text: center.specialty),
            ),
          ],

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.borderBlue.withValues(alpha: 0.15),
        indent: 12,
        endIndent: 12,
      );
}

class _InfoBox extends StatelessWidget {
  final String text;

  const _InfoBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
