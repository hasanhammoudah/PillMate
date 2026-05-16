import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../../../core/widgets/rounded_input_field.dart';
import '../../domain/models/health_center_model.dart';

class HealthCenterFormScreen extends StatefulWidget {
  const HealthCenterFormScreen({super.key});

  @override
  State<HealthCenterFormScreen> createState() => _HealthCenterFormScreenState();
}

class _HealthCenterFormScreenState extends State<HealthCenterFormScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr('pleaseEnterCenterName'),
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
      HealthCenter(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        specialty: _specialtyController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
                  title: context.tr('addHealthCenter'),
                  addLabel: context.tr('saveCenter'),
                  onAdd: _save,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      20.h,
                      20.w,
                      keyboardHeight > 0 ? keyboardHeight + 20.h : 170.h,
                    ),
                    child: Column(
                      children: [
                        RoundedInputField(
                          controller: _nameController,
                          hint: context.tr('healthCenterName'),
                        ),
                        SizedBox(height: 20.h),
                        RoundedInputField(
                          controller: _addressController,
                          hint: context.tr('address'),
                        ),
                        SizedBox(height: 20.h),
                        RoundedInputField(
                          controller: _phoneController,
                          hint: context.tr('phoneNumber'),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 20.h),
                        RoundedInputField(
                          controller: _specialtyController,
                          hint: context.tr('specialty'),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 0,
              right: context.isArabic ? 0 : null,
              left: context.isArabic ? null : 0,
              child: IgnorePointer(
                child: Image.asset(
                  AppAssets.elderlyWoman,
                  height: 165.h,
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
