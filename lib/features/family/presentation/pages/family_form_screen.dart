import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/rounded_input_field.dart';
import '../../domain/models/family_member_model.dart';

// ── Screen 4 & 6: Family Form / Add Member ────────────────────────────────────
// Three pill-shaped input fields. Returns a FamilyMember on save.

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
          content: const Text(
            'يرجى إدخال اسم الفرد',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.cardBg,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              // ── Main content ──────────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppScreenHeader(
                    title: 'قائمة عائلتي',
                    addLabel: '+ اضافة فرد',
                    onAdd: _save,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      child: Column(
                        children: [
                          // اسم الفرد
                          RoundedInputField(
                            controller: _nameController,
                            hint: 'اسم الفرد',
                          ),
                          SizedBox(height: 20.h),

                          // رقم الهاتف
                          RoundedInputField(
                            controller: _phoneController,
                            hint: 'رقم الهاتف',
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20.h),

                          // صلة القرابة
                          RoundedInputField(
                            controller: _relationshipController,
                            hint: 'صلة القرابة',
                          ),
                          SizedBox(height: 36.h),

                          // حفظ button
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
                                'حفظ',
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

              // ── Elderly woman illustration (fixed, bottom-right) ──────────
              Positioned(
                right: 0,
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
      ),
    );
  }
}
