import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/medication_model.dart';
import 'medication_list_screen.dart';

class DailyCheckScreen extends StatefulWidget {
  const DailyCheckScreen({super.key});

  @override
  State<DailyCheckScreen> createState() => _DailyCheckScreenState();
}

class _DailyCheckScreenState extends State<DailyCheckScreen> {
  final List<Medication> _medications = [
    Medication(
      id: '1',
      name: 'باراسيتامول',
      dosage: '500 ملغ',
      scheduleTimes: ['08:00', '14:00'],
      startDate: '01/04/2026',
      endDate: '15/04/2026',
      remainingQuantity: 20,
    ),
    Medication(
      id: '2',
      name: 'أموكسيسيلين',
      dosage: '250 ملغ',
      scheduleTimes: ['09:00', '21:00'],
      startDate: '01/04/2026',
      endDate: '10/04/2026',
      remainingQuantity: 14,
    ),
    Medication(
      id: '3',
      name: 'ميتفورمين',
      dosage: '1000 ملغ',
      scheduleTimes: ['07:00', '13:00', '19:00'],
      startDate: '01/01/2026',
      endDate: '30/06/2026',
      remainingQuantity: 30,
    ),
    Medication(
      id: '4',
      name: 'أتورفاستاتين',
      dosage: '20 ملغ',
      scheduleTimes: ['22:00'],
      startDate: '01/03/2026',
      endDate: '01/09/2026',
      remainingQuantity: 25,
    ),
  ];

  void _markTaken(int index) {
    setState(() {
      _medications[index] = _medications[index].copyWith(takenToday: true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.tr('recordedTaking',
              args: {'name': _medications[index].name}),
        ),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      body: SafeArea(
        child: Column(
          children: [
            _DailyTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/Untitled-3-01.png',
                        width: 130.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppColors.borderBlue
                              .withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark
                                .withValues(alpha: 0.07),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 12.w),
                        itemCount: _medications.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: AppColors.borderBlue
                              .withValues(alpha: 0.15),
                        ),
                        itemBuilder: (_, index) =>
                            _DailyMedicationTile(
                          medication: _medications[index],
                          onTaken: () => _markTaken(index),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _BottomNav(),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _DailyTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDark,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                context.isArabic
                    ? Icons.arrow_forward_ios
                    : Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
          ),
          const Spacer(),
          // Logout button
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (_) => false),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                context.tr('logout'),
                style: TextStyle(
                  fontSize: 13.sp,
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

// ── Medication tile ───────────────────────────────────────────────────────────

class _DailyMedicationTile extends StatelessWidget {
  final Medication medication;
  final VoidCallback onTaken;

  const _DailyMedicationTile({
    required this.medication,
    required this.onTaken,
  });

  @override
  Widget build(BuildContext context) {
    final timesLabel = medication.scheduleTimes.join('  ،  ');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding:
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  timesLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.borderBlue,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: medication.takenToday ? null : onTaken,
            style: ElevatedButton.styleFrom(
              backgroundColor: medication.takenToday
                  ? Colors.grey.shade400
                  : AppColors.green,
              disabledBackgroundColor: Colors.grey.shade400,
              padding: EdgeInsets.symmetric(
                  horizontal: 14.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: medication.takenToday ? 0 : 2,
              shadowColor:
                  AppColors.green.withValues(alpha: 0.35),
            ),
            child: Text(
              medication.takenToday
                  ? context.tr('doneTaken')
                  : context.tr('takenMedication'),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom navigation ─────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavCard(
              label: context.tr('myMedications'),
              icon: Icons.medication_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const MedicationListScreen()),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: _BottomNavCard(
              label: context.tr('healthCentersTitle'),
              icon: Icons.local_hospital_outlined,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BottomNavCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.navCard,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 24.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
