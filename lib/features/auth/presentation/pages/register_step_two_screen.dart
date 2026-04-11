import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../widgets/register_header.dart';
import '../widgets/register_illustration.dart';

class RegisterStepTwoScreen extends StatelessWidget {
  const RegisterStepTwoScreen({super.key});

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
                  currentStep: 2,
                  stepTitle: 'معلومات الطوارئ',
                  // Arrow is a FORWARD button → go to next step
                  onArrowTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(label: 'الاسم بالكامل'),
                        SizedBox(height: 14.h),
                        AppTextField(
                          label: 'رقم الهاتف',
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 14.h),
                        AppTextField(
                          label: 'الامراض المزمنة',
                          maxLines: 5,
                          height: 130.h,
                        ),
                        SizedBox(height: 28.h),
                        AppPrimaryButton(
                          label: 'التالي',
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.registerStep3,
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
