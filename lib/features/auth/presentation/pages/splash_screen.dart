import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/services/auth_local_service.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/background_decoration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _navigated = false;

  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _rotationController.addStatusListener(_onAnimationStatus);
    _rotationController.forward();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _checkAndNavigate();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _checkAndNavigate() async {
    if (!mounted || _navigated) return;
    _navigated = true;
    final registered = await AuthLocalService().isRegistered();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      registered ? AppRoutes.welcomeStart : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 64.h),
              const AppLogo(),
              SizedBox(height: 20.h),
              Text(
                'تنظيم دوائك... بداية راحتك',
                style: AppTextStyles.tagline,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: SvgPicture.asset(
                      AppAssets.group,
                      width: 1.sw,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
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
