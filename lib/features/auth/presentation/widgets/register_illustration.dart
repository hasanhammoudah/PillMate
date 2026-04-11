import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';

/// Elderly female character pinned to the physical bottom-right of each
/// register screen.  Wrapped in a fixed-height SizedBox so it can never
/// cause overflow regardless of device height.
class RegisterIllustration extends StatelessWidget {
  const RegisterIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      width: double.infinity,
      child: Align(
        // Physical bottom-right — correct for Arabic/RTL UIs where the
        // illustration is always in the bottom-right corner.
        alignment: Alignment.bottomRight,
        child: SvgPicture.asset(
          AppAssets.frame2,
          height: 110.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
