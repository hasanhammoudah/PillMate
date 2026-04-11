import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../../../../core/widgets/password_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/elderly_couple_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Height occupied by the software keyboard (0 when closed).
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardOpen = bottomInset > 0;

    return Scaffold(
      // Let the body stay full-screen; we handle keyboard inset manually.
      resizeToAvoidBottomInset: false,
      body: BackgroundDecoration(
        child: SafeArea(
          child: SingleChildScrollView(
            // Pad the bottom of the scroll content by exactly the keyboard
            // height so the last widget is never hidden behind the keyboard.
            padding: EdgeInsets.only(
              left: 28.w,
              right: 28.w,
              bottom: bottomInset + 8.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),
                AuthHeader(
                  onArrowTap: () =>
                      Navigator.pushNamed(context, AppRoutes.registerStep1),
                ),
                SizedBox(height: 36.h),
                AppTextField(label: 'اسم المستخدم'),
                SizedBox(height: 18.h),
                const PasswordField(label: 'الرمز السري'),
                SizedBox(height: 28.h),
                AppPrimaryButton(label: 'دخول', onPressed: () {}),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.registerStep1),
                    child: RichText(
                      textDirection: TextDirection.rtl,
                      text: TextSpan(
                        style: AppTextStyles.bottomLink,
                        children: const [
                          TextSpan(text: 'هل لديك حساب؟ '),
                          TextSpan(
                            text: 'تسجيل الدخول',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Hide the illustration while the keyboard is open so it
                // doesn't waste scroll space or cause bottom overflow.
                if (!keyboardOpen) ...[
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 180.h),
                      child: const ElderlyCoupleWidget(width: double.infinity),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
