import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/rounded_input_field.dart';
import '../../domain/models/family_member_model.dart';

class FamilyFormScreen extends StatefulWidget {
  const FamilyFormScreen({super.key});

  @override
  State<FamilyFormScreen> createState() => _FamilyFormScreenState();
}

class _FamilyFormScreenState extends State<FamilyFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr('pleaseEnterMemberName'),
            textAlign: context.isArabic ? TextAlign.right : TextAlign.left,
            textDirection: context.appTextDirection,
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      FamilyMember(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? '---'
            : _phoneController.text.trim(),
        relationship: _relationshipController.text.trim().isEmpty
            ? '---'
            : _relationshipController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppScreenHeader(
                  title: context.tr('familyList'),
                  addLabel: context.tr('addMember'),
                  onAdd: _save,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      children: [
                        RoundedInputField(
                          controller: _nameController,
                          hint: context.tr('memberName'),
                        ),
                        SizedBox(height: 20.h),

                        RoundedInputField(
                          controller: _phoneController,
                          hint: context.tr('phoneNumber'),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20.h),

                        RoundedInputField(
                          controller: _relationshipController,
                          hint: context.tr('relationship'),
                        ),
                        SizedBox(height: 36.h),

                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.r),
                              ),
                              elevation: 3,
                              shadowColor: AppColors.primaryDark
                                  .withValues(alpha: 0.35),
                            ),
                            child: Text(
                              context.tr('save'),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              right: context.isArabic ? 0 : null,
              left: context.isArabic ? null : 0,
              bottom: 0,
              child: IgnorePointer(
                child: Image.asset(
                  AppAssets.elderlyWoman,
                  height: 155.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
