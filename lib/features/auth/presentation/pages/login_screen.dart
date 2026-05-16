import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/auth_local_service.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../../../../core/widgets/password_field.dart';
import '../widgets/auth_header.dart';
import '../widgets/elderly_couple_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      await AuthLocalService().saveUsername(username);
    }
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundDecoration(
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 28.w,
                  right: 28.w,
                  bottom: bottomInset > 0 ? bottomInset + 16.h : 196.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16.h),
                    AuthHeader(
                      onArrowTap: () => Navigator.pushNamed(
                          context, AppRoutes.registerStep1),
                    ),
                    SizedBox(height: 36.h),
                    AppTextField(
                      label: context.tr('username'),
                      controller: _usernameController,
                    ),
                    SizedBox(height: 18.h),
                    PasswordField(label: context.tr('password')),
                    SizedBox(height: 28.h),
                    AppPrimaryButton(
                      label: context.tr('login'),
                      onPressed: _onLogin,
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.registerStep1),
                        child: RichText(
                          textDirection: context.appTextDirection,
                          text: TextSpan(
                            style: AppTextStyles.bottomLink,
                            children: [
                              TextSpan(text: context.tr('noAccount')),
                              TextSpan(
                                text: context.tr('registerLink'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 180.h),
                      child: const ElderlyCoupleWidget(width: double.infinity),
                    ),
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
