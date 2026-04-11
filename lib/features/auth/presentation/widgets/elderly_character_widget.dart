import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';

/// Single elderly female character — pinned to bottom of register screens.
class ElderlyCharacterWidget extends StatelessWidget {
  final double? width;

  const ElderlyCharacterWidget({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: SvgPicture.asset(
        AppAssets.frame2,
        width: width ?? 90.w,
        fit: BoxFit.contain,
        alignment: Alignment.bottomRight,
      ),
    );
  }
}
