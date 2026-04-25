import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/intro_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_step_one_screen.dart';
import '../../features/auth/presentation/pages/register_step_two_screen.dart';
import '../../features/auth/presentation/pages/register_step_three_screen.dart';
import '../../features/auth/presentation/pages/welcome_start_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/medications/presentation/pages/medication_list_screen.dart';
import '../../features/medications/presentation/pages/add_medication_screen.dart';
import '../../features/medications/presentation/pages/daily_check_screen.dart';
import '../../features/family/presentation/pages/family_list_screen.dart';
import '../../features/family/presentation/pages/family_form_screen.dart';
import '../../features/health_centers/presentation/pages/health_centers_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String registerStep1 = '/register/step1';
  static const String registerStep2 = '/register/step2';
  static const String registerStep3 = '/register/step3';
  static const String welcomeStart = '/welcome';
  static const String home = '/home';
  static const String medicationList = '/medications';
  static const String addMedication = '/medications/add';
  static const String dailyCheck = '/medications/daily';
  static const String familyList = '/family';
  static const String familyForm = '/family/add';
  static const String healthCenters = '/health-centers';
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
        return MaterialPageRoute(
            builder: (_) => const RegisterStepOneScreen());
      case AppRoutes.registerStep2:
        return MaterialPageRoute(
            builder: (_) => const RegisterStepTwoScreen());
      case AppRoutes.registerStep3:
        return MaterialPageRoute(
            builder: (_) => const RegisterStepThreeScreen());
      case AppRoutes.welcomeStart:
        return MaterialPageRoute(builder: (_) => const WelcomeStartScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.medicationList:
        return MaterialPageRoute(builder: (_) => const MedicationListScreen());
      case AppRoutes.addMedication:
        return MaterialPageRoute(builder: (_) => const AddMedicationScreen());
      case AppRoutes.dailyCheck:
        return MaterialPageRoute(builder: (_) => const DailyCheckScreen());
      case AppRoutes.familyList:
        return MaterialPageRoute(builder: (_) => const FamilyListScreen());
      case AppRoutes.familyForm:
        return MaterialPageRoute(builder: (_) => const FamilyFormScreen());
      case AppRoutes.healthCenters:
        return MaterialPageRoute(
            builder: (_) => const HealthCentersScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
