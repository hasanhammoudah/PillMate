import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.cardBg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar ──────────────────────────────────────────────
              _TopBar(
                userName: _userName,
                isLoggedIn: _isLoggedIn,
                onLogout: _logout,
              ),

              // ── Body ─────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    children: [
                      // Logo
                      Center(
                        child: SvgPicture.asset(AppAssets.logo, width: 150.w),
                      ),

                      SizedBox(height: 28.h),

                      // "الادوية القادمة" outlined button
                      _OutlinedMenuButton(
                        label: 'الادوية القادمة',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DailyCheckScreen()),
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // Cards + illustration row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // RIGHT column (RTL start): 3 stacked nav cards
                          Expanded(
                            flex: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _NavCard(
                                  label: 'ادويتي',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const MedicationListScreen()),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                _NavCard(
                                  label: 'عائلتي',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const FamilyListScreen()),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                _NavCard(
                                  label: 'المراكز\nالصحية',
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

                          // LEFT column (RTL end): illustration
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
      ),
    );
  }
}

// ── Top bar ──────────────────────────────────────────────────────────────────
// RTL layout:
//   RIGHT: user name
//   LEFT:  تسجيل الدخول button

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
          // RTL first child → visually RIGHT: user name
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

          SizedBox(width: 8.w),

          // RTL last child → visually LEFT: auth button
          GestureDetector(
            onTap: isLoggedIn
                ? onLogout
                : () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (_) => false,
                    ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.accentCyan,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
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
    );
  }
}

// ── Outlined "الادوية القادمة" button ─────────────────────────────────────────

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

// ── Dark navy navigation card ─────────────────────────────────────────────────

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
