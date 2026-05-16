import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../widgets/register_header.dart';
import '../widgets/register_illustration.dart';

class RegisterStepTwoScreen extends StatelessWidget {
  const RegisterStepTwoScreen({super.key});

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
                  currentStep: 2,
                  stepTitle: context.tr('emergencyInfo'),
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
                            AppTextField(label: context.tr('fullName')),
                            SizedBox(height: 14.h),
                            AppTextField(
                              label: context.tr('phoneNumber'),
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 14.h),
                            AppTextField(
                              label: context.tr('chronicDiseases'),
                              maxLines: 5,
                              height: 130.h,
                            ),
                            SizedBox(height: 28.h),
                            AppPrimaryButton(
                              label: context.tr('next'),
                              onPressed: () => Navigator.pushNamed(
                                  context, AppRoutes.registerStep3),
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
