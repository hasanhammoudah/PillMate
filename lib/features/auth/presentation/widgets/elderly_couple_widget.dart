import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';

/// Elderly couple illustration — splash / intro / login screens.
class ElderlyCoupleWidget extends StatelessWidget {
  final double? width;

  const ElderlyCoupleWidget({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    final w = width == double.infinity ? null : (width ?? 220.w);
    return SvgPicture.asset(
      AppAssets.frame,
      width: w,
      fit: BoxFit.contain,
    );
  }
}
