import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = LocaleNotifierWidget.of(context);
    final isArabic = context.isArabic;

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SettingsHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Language section label
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.h,
                        right: isArabic ? 4.w : 0,
                        left: isArabic ? 0 : 4.w,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language_rounded,
                            color: AppColors.primaryDark,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.tr('language'),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Language selector card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _LanguageTile(
                            label: context.tr('arabic'),
                            nativeLabel: 'العربية',
                            flag: '🇸🇦',
                            isSelected: isArabic,
                            isFirst: true,
                            onTap: () => provider.setLocale(const Locale('ar')),
                          ),
                          Divider(
                            height: 1,
                            indent: 20.w,
                            endIndent: 20.w,
                            color: AppColors.borderBlue.withValues(alpha: 0.12),
                          ),
                          _LanguageTile(
                            label: context.tr('english'),
                            nativeLabel: 'English',
                            flag: '🇬🇧',
                            isSelected: !isArabic,
                            isFirst: false,
                            onTap: () => provider.setLocale(const Locale('en')),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Info note
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.accentCyan.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accentCyan,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              context.tr('chooseLanguage'),
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.borderBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
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
                context.isArabic
                    ? Icons.arrow_forward_ios
                    : Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: 18.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              context.tr('settings'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
          ),
          SvgPicture.asset(AppAssets.logo, width: 52.w),
        ],
      ),
    );
  }
}

// ── Language option tile ──────────────────────────────────────────────────────

class _LanguageTile extends StatelessWidget {
  final String label;
  final String nativeLabel;
  final String flag;
  final bool isSelected;
  final bool isFirst;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.nativeLabel,
    required this.flag,
    required this.isSelected,
    required this.isFirst,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDark.withValues(alpha: 0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? Radius.circular(20.r) : Radius.zero,
            bottom: isFirst ? Radius.zero : Radius.circular(20.r),
          ),
        ),
        child: Row(
          children: [
            // Flag
            Text(flag, style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 14.w),

            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeLabel,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  if (label != nativeLabel)
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.borderBlue,
                      ),
                    ),
                ],
              ),
            ),

            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryDark : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.borderBlue.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: AppColors.white, size: 14.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
