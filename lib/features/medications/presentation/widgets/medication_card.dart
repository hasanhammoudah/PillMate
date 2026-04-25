import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/models/medication_model.dart';
import 'time_pill_widget.dart';

/// Card shown in the Medication List screen.
/// Fully RTL – all content anchored to the right side, matching the Arabic reference.
class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderBlue.withValues(alpha: 0.45), width: 1.5),
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
          // ── Header row: medication name (right) + delete icon (left) ─
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
              // RTL Row: first child = rightmost, last child = leftmost.
              // We want: name on the RIGHT, delete button on the LEFT.
              children: [
                // RTL first child → visually RIGHT: medication name
                Expanded(
                  child: Text(
                    medication.name,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // RTL last child → visually LEFT: red delete button
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

          // ── Dosage / instructions ─────────────────────────────────
          if (medication.dosage.isNotEmpty) ...[
            _divider(),
            _section(
              label: 'الجرعة',
              content: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  medication.dosage,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ],

          _divider(),

          // ── Dose schedule ─────────────────────────────────────────
          _section(
            label: 'مواعيد الجرعات',
            content: Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              // In RTL, WrapAlignment.start = anchored to the RIGHT side
              alignment: WrapAlignment.start,
              textDirection: TextDirection.rtl,
              children: medication.scheduleTimes
                  .map((t) => TimePillWidget(time: t))
                  .toList(),
            ),
          ),

          _divider(),

          // ── Treatment period ──────────────────────────────────────
          _section(
            label: 'فترة العلاج',
            content: Row(
              // In RTL, MainAxisAlignment.start = pushed to the RIGHT
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // RTL reading order (right → left): من [start] الى [end]
                Text(
                  'من',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.borderBlue,
                  ),
                ),
                SizedBox(width: 8.w),
                _infoChip(medication.startDate),
                SizedBox(width: 8.w),
                Text(
                  'الى',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.borderBlue,
                  ),
                ),
                SizedBox(width: 8.w),
                _infoChip(medication.endDate),
              ],
            ),
          ),

          _divider(),

          // ── Remaining quantity ────────────────────────────────────
          _section(
            label: 'الكمية المتبقية',
            content: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${medication.remainingQuantity} حبة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.borderBlue.withValues(alpha: 0.15),
        indent: 14,
        endIndent: 14,
      );

  /// Section with a right-anchored label followed by its content.
  /// CrossAxisAlignment.start in RTL = right-aligned.
  Widget _section({required String label, required Widget content}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // start = RIGHT in RTL
        children: [
          Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 8.h),
          content,
        ],
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderBlue.withValues(alpha: 0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
