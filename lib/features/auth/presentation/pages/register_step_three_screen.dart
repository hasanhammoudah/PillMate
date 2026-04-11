import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../../../../core/widgets/password_field.dart';
import '../widgets/register_header.dart';
import '../widgets/register_illustration.dart';

class RegisterStepThreeScreen extends StatelessWidget {
  const RegisterStepThreeScreen({super.key});

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
                  currentStep: 3,
                  stepTitle: 'معلومات الحساب',
                  // Arrow is a FORWARD button → go to welcome/start screen
                  onArrowTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(label: 'اسم المستخدم'),
                        SizedBox(height: 14.h),
                        const PasswordField(label: 'الرمز السري'),
                        SizedBox(height: 14.h),
                        const PasswordField(label: 'تأكيد الرمز السري'),
                        SizedBox(height: 28.h),
                        AppPrimaryButton(
                          label: 'التالي',
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.welcomeStart,
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
