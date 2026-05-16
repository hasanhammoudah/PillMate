import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/auth_local_service.dart';
import '../../../family/presentation/pages/family_list_screen.dart';
import '../../../health_centers/presentation/pages/health_centers_screen.dart';
import '../../../medications/presentation/pages/daily_check_screen.dart';
import '../../../medications/presentation/pages/medication_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = '';
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final service = AuthLocalService();
    final name = await service.getUserName();
    final loggedIn = await service.isLoggedIn();
    if (mounted) {
      setState(() {
        _userName = name;
        _isLoggedIn = loggedIn;
      });
    }
  }

  Future<void> _logout() async {
    await AuthLocalService().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(
              userName: _userName,
              isLoggedIn: _isLoggedIn,
              onLogout: _logout,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  children: [
                    Center(
                      child:
                          Image.asset(
                            'assets/images/Untitled-3-01.png',
                            width: 150.w,
                            fit: BoxFit.contain,
                          ),
                    ),
                    SizedBox(height: 28.h),
                    _OutlinedMenuButton(
                      label: context.tr('upcomingMedications'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DailyCheckScreen()),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _NavCard(
                                label: context.tr('myMedications'),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const MedicationListScreen()),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _NavCard(
                                label: context.tr('myFamily'),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const FamilyListScreen()),
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _NavCard(
                                label: context.tr('healthCentersNav'),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const HealthCentersScreen()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          flex: 10,
                          child: Image.asset(
                            AppAssets.elderlyMan,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String userName;
  final bool isLoggedIn;
  final VoidCallback onLogout;

  const _TopBar({
    required this.userName,
    required this.isLoggedIn,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDark,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User name (RTL: right / LTR: left)
          Flexible(
            child: Text(
              userName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Settings icon
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              // Auth button
              GestureDetector(
                onTap: isLoggedIn
                    ? onLogout
                    : () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (_) => false,
                        ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    isLoggedIn
                        ? context.tr('logout')
                        : context.tr('loginBtn'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Outlined button ───────────────────────────────────────────────────────────

class _OutlinedMenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedMenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryDark, width: 1.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}

// ── Nav card ──────────────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavCard({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.navCard,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.28),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
