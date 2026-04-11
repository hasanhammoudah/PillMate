import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../widgets/register_header.dart';
import '../widgets/register_illustration.dart';

class RegisterStepOneScreen extends StatelessWidget {
  const RegisterStepOneScreen({super.key});

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
                  // Arrow is a FORWARD button → go to next step
                  onArrowTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      // start = physical RIGHT in RTL → labels on right ✓
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(label: 'الاسم بالكامل'),
                        SizedBox(height: 14.h),
                        // In RTL Row, first child renders on the physical RIGHT.
                        // Reference: العمر (age) on right, الجنس (gender) on left.
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'العمر',
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(child: AppTextField(label: 'الجنس')),
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
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.registerStep2,
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
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
