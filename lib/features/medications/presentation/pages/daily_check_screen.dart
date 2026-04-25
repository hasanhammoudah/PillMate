import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
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
          'تم تسجيل تناول ${_medications[index].name}',
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.cardBg,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top bar ───────────────────────────────────────────
              _DailyTopBar(),

              // ── Scrollable body ───────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    children: [
                      // Logo – centered
                      Center(
                        child:
                            SvgPicture.asset(AppAssets.logo, width: 130.w),
                      ),
                      SizedBox(height: 20.h),

                      // Medications container
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
                          itemBuilder: (_, index) => _DailyMedicationTile(
                            medication: _medications[index],
                            onTaken: () => _markTaken(index),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom navigation ─────────────────────────────────
              const _BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
// RTL: MainAxisAlignment.start → logout button visually on the RIGHT.

class _DailyTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryDark,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        // In RTL, start = RIGHT side — logout button anchored to the right.
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.login, (_) => false),
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'تسجيل الخروج',
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

// ── Individual daily medication tile ─────────────────────────────────────────
// RTL layout: [medication name + times → RIGHT] [شربت الدواء button → LEFT]

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
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        // RTL Row: first child → RIGHT, last child → LEFT.
        children: [
          // RIGHT side: medication name + scheduled times
          Expanded(
            child: Column(
              // CrossAxisAlignment.start in RTL = anchored to the RIGHT
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  timesLabel,
                  textAlign: TextAlign.right,
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

          // LEFT side: action button
          ElevatedButton(
            onPressed: medication.takenToday ? null : onTaken,
            style: ElevatedButton.styleFrom(
              backgroundColor: medication.takenToday
                  ? Colors.grey.shade400
                  : AppColors.green,
              disabledBackgroundColor: Colors.grey.shade400,
              padding:
                  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: medication.takenToday ? 0 : 2,
              shadowColor: AppColors.green.withValues(alpha: 0.35),
            ),
            child: Text(
              medication.takenToday ? 'تم ✓' : 'شربت الدواء',
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

// ── Bottom navigation bar ─────────────────────────────────────────────────────
// RTL order: ادويتي (RIGHT / first child) — المراكز الصحية (LEFT / last child)

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
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
          // RTL first child → visually RIGHT: ادويتي (primary action)
          Expanded(
            child: _BottomNavCard(
              label: 'ادويتي',
              icon: Icons.medication_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MedicationListScreen(),
                ),
              ),
            ),
          ),

          SizedBox(width: 16.w),

          // RTL last child → visually LEFT: المراكز الصحية
          Expanded(
            child: _BottomNavCard(
              label: 'المراكز\nالصحية',
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
