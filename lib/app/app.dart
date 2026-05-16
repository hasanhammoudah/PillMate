import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'router/app_router.dart';
import 'theme/app_colors.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/locale_provider.dart';

class PillMateApp extends StatelessWidget {
  const PillMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = LocaleNotifierWidget.of(context);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MaterialApp(
          title: 'PillMate',
          debugShowCheckedModeBanner: false,
          locale: provider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar'), Locale('en')],
          builder: (context, widget) => Directionality(
            textDirection: provider.textDirection,
            child: widget!,
          ),
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            fontFamily: 'Cairo',
          ),
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
