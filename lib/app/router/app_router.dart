import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/intro_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_step_one_screen.dart';
import '../../features/auth/presentation/pages/register_step_two_screen.dart';
import '../../features/auth/presentation/pages/register_step_three_screen.dart';
import '../../features/auth/presentation/pages/welcome_start_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String welcomeStart = '/welcome';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.intro:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.registerStep1:
        return MaterialPageRoute(builder: (_) => const RegisterStepOneScreen());
      case AppRoutes.registerStep2:
        return MaterialPageRoute(builder: (_) => const RegisterStepTwoScreen());
      case AppRoutes.registerStep3:
        return MaterialPageRoute(
            builder: (_) => const RegisterStepThreeScreen());
      case AppRoutes.welcomeStart:
        return MaterialPageRoute(builder: (_) => const WelcomeStartScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
