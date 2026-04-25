import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/theme/app_assets.dart';
import '../../app/theme/app_colors.dart';

/// Reusable top header shared across all secondary screens.
///
/// RTL visual layout:
///   [cyan back-arrow button → RIGHT]  [title CENTER]  [logo LEFT]
///   [optional green add-button CENTERED below]
///
/// Must be placed inside a parent with Directionality(rtl).
class AppScreenHeader extends StatelessWidget {
  final String? title;
  final String? addLabel;
  final VoidCallback? onAdd;

  const AppScreenHeader({
    super.key,
    this.title,
    this.addLabel,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Column(
        children: [
          Row(
            children: [
              // RTL first child → visually RIGHT: cyan back button (→)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
              ),

              // CENTER: title or spacer
              if (title != null)
                Expanded(
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                )
              else
                const Spacer(),

              // RTL last child → visually LEFT: PillMate logo
              SvgPicture.asset(AppAssets.logo, width: 52.w),
            ],
          ),

          if (addLabel != null) ...[
            SizedBox(height: 14.h),
            Center(
              child: GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(22.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    addLabel!,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}
