import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/auth_local_service.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../../../../core/widgets/password_field.dart';
import '../widgets/register_header.dart';
import '../widgets/register_illustration.dart';

class RegisterStepThreeScreen extends StatefulWidget {
  const RegisterStepThreeScreen({super.key});

  @override
  State<RegisterStepThreeScreen> createState() =>
      _RegisterStepThreeScreenState();
}

class _RegisterStepThreeScreenState extends State<RegisterStepThreeScreen> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onFinish() async {
    final name = _usernameController.text.trim();
    await AuthLocalService().setRegistered(
      userName: name.isEmpty ? context.tr('defaultUser') : name,
    );
    if (!mounted) return;
    Navigator.pushNamed(context, AppRoutes.welcomeStart);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  stepTitle: context.tr('accountInfo'),
                  onArrowTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.only(
                          bottom: keyboardHeight > 0
                              ? keyboardHeight + 16.h
                              : 118.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              label: context.tr('username'),
                              controller: _usernameController,
                            ),
                            SizedBox(height: 14.h),
                            PasswordField(label: context.tr('password')),
                            SizedBox(height: 14.h),
                            PasswordField(
                                label: context.tr('confirmPassword')),
                            SizedBox(height: 28.h),
                            AppPrimaryButton(
                              label: context.tr('next'),
                              onPressed: _onFinish,
                            ),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                            child: const RegisterIllustration()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
