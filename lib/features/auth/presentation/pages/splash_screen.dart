import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/background_decoration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Guard: navigation fires exactly once even if the status listener
  // somehow fires more than once.
  bool _navigated = false;

  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // One full rotation in 2.5 s, eased for an elegant feel.
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    );

    // Listen for completion BEFORE calling forward() so the callback
    // is guaranteed to be registered when the status fires.
    _rotationController.addStatusListener(_onAnimationStatus);

    // Start the single-shot rotation.
    _rotationController.forward();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _navigateToLogin();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    // Guard: skip if widget is unmounted OR we already navigated.
    if (!mounted || _navigated) return;
    _navigated = true;
    // pushReplacement removes the splash from the stack entirely.
    // The user can never return to it via the back button.
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundDecoration(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 64.h),
              RotationTransition(
                turns: _rotationAnimation,
                child: const AppLogo(),
              ),
              SizedBox(height: 20.h),
              Text(
                'تنظيم دوائك... بداية راحتك',
                style: AppTextStyles.tagline,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
              // Illustration fills all remaining vertical space, keeping it
              // bottom-aligned and as large as the device allows.
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: SvgPicture.asset(
                      AppAssets.group,
                      // Width fills the screen; height scales by aspect ratio.
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
