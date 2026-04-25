import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/background_decoration.dart';
import '../../../../core/widgets/curved_start_button.dart';

class WelcomeStartScreen extends StatelessWidget {
  const WelcomeStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              const AppLogo(),
              const Spacer(),
              CurvedStartButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              const Spacer(),
              SvgPicture.asset(
                AppAssets.group,
                width: 240.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
