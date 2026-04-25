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
    // Keyboard height — 0 when closed, >0 when open.
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      // Keep scaffold full-height; we handle keyboard inset via scroll padding.
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
                  stepTitle: 'معلومات الطوارئ',
                  onArrowTap: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                // Stack lets the illustration sit fixed at the bottom while
                // the form scrolls independently above it.
                Expanded(
                  child: Stack(
                    children: [
                      // ── Scrollable form ────────────────────────────
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        // When keyboard open: pad by keyboard height so the
                        // button stays reachable above the keyboard.
                        // When closed: pad by illustration height + buffer.
                        padding: EdgeInsets.only(
                          bottom: keyboardHeight > 0
                              ? keyboardHeight + 16.h
                              : 118.h,
                        ),
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

                      // ── Fixed illustration ─────────────────────────
                      // Pinned to the bottom of the Expanded area — does NOT
                      // move when the keyboard opens.
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: const RegisterIllustration(),
                        ),
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
