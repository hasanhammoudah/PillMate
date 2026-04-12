import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../widgets/register_header.dart';
import '../widgets/register_illustration.dart';

class RegisterStepOneScreen extends StatefulWidget {
  const RegisterStepOneScreen({super.key});

  @override
  State<RegisterStepOneScreen> createState() => _RegisterStepOneScreenState();
}

class _RegisterStepOneScreenState extends State<RegisterStepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, AppRoutes.registerStep2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                RegisterHeader(
                  currentStep: 1,
                  stepTitle: 'المعلومات الشخصية',
                  onArrowTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // start = physical RIGHT in RTL → labels on right ✓
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(label: 'الاسم بالكامل'),
                          SizedBox(height: 14.h),
                          // In RTL Row, first child renders on the physical RIGHT.
                          // العمر (age) on right, الجنس (gender) on left.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _AgeField(controller: _ageController),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: _GenderDropdown(
                                  value: _selectedGender,
                                  onChanged: (v) =>
                                      setState(() => _selectedGender = v),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(
                            label: 'رقم الهاتف',
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 14.h),
                          AppTextField(label: 'العنوان'),
                          SizedBox(height: 28.h),
                          AppPrimaryButton(
                            label: 'التالي',
                            onPressed: _onNext,
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ),
                const RegisterIllustration(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gender dropdown: ذكر / أنثى, validates a selection was made.
/// Styled to match [AppTextField] visually (same border, radius, fill, padding).
class _GenderDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _GenderDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire widget in RTL so the label, selected value, hint text,
    // and dropdown arrow all follow a natural Arabic right-to-left layout.
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // start = RIGHT in RTL
        children: [
          Text('الجنس', style: AppTextStyles.label),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            initialValue: value,
            onChanged: onChanged,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconEnabledColor: AppColors.primary,
            // Directionality moves the icon to the left automatically.
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.primary,
            ),
            hint: Text(
              'اختر الجنس',
              // textDirection inherited from Directionality wrapper above.
              style: TextStyle(fontSize: 16.sp, color: AppColors.hintText),
            ),
            validator: (v) => v == null ? 'يرجى اختيار الجنس' : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputFill,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide:
                    const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide:
                    const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              errorStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'ذكر', child: Text('ذكر')),
              DropdownMenuItem(value: 'أنثى', child: Text('أنثى')),
            ],
          ),
        ],
      ),
    );
  }
}

/// Age input field: numeric-only, max 3 digits, validates age ≥ 60.
/// Styled to match [AppTextField] visually (same border, radius, fill, padding).
/// Error text appears below the border (standard Flutter FormField behaviour).
class _AgeField extends StatelessWidget {
  final TextEditingController controller;

  const _AgeField({required this.controller});

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال العمر';
    }
    final age = int.tryParse(value.trim());
    if (age == null || age < 60) {
      return 'يجب أن يكون العمر 60 سنة أو أكثر';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // start = RIGHT in RTL
        children: [
          Text('العمر', style: AppTextStyles.label),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.center,
            textDirection: TextDirection.rtl,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            style: TextStyle(fontSize: 16.sp, color: AppColors.primary),
            validator: _validate,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputFill,
              // Normal state — matches AppTextField border exactly
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide:
                    const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide:
                    const BorderSide(color: AppColors.inputBorder, width: 2),
              ),
              // Error state — border turns red to signal invalid input
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.input),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              // Allow the Arabic error message to wrap so it is never clipped.
              errorMaxLines: 3,
              errorStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.red,
                fontWeight: FontWeight.w500,
                height: 1.4, // comfortable line-spacing for multi-line text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
