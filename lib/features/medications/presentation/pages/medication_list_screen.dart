import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/services/reminder_service.dart';
import '../../data/services/medication_local_service.dart';
import '../../domain/models/medication_model.dart';
import '../widgets/medication_card.dart';
import 'add_medication_screen.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final _service = MedicationLocalService();
  final List<Medication> _medications = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _service.getAll();
    if (mounted) {
      setState(() {
        _medications.addAll(items);
        _loaded = true;
      });
    }
  }

  Future<void> _addMedication(Medication med) async {
    // ── Debug trace ─────────────────────────────────────────────────────────
    debugPrint('');
    debugPrint('==============================');
    debugPrint('MEDICINE SAVED');
    debugPrint('  Name    : ${med.name}');
    debugPrint('  Dosage  : ${med.dosage}');
    debugPrint('  Times   : ${med.scheduleTimes}');
    debugPrint('  ID      : ${med.id}');
    debugPrint('  Now     : ${DateTime.now()}');
    debugPrint('==============================');
    debugPrint('');

    await _service.add(med);
    debugPrint('[MedList] ✅ Saved to storage');

    debugPrint('[MedList] CALLING SCHEDULE REMINDER...');
    try {
      await ReminderService.instance.scheduleForMedication(med);
      debugPrint('[MedList] ✅ scheduleForMedication complete');
    } catch (e, st) {
      debugPrint('[MedList] ❌ scheduleForMedication FAILED: $e');
      debugPrint('$st');
    }

    setState(() => _medications.add(med));
  }

  Future<void> _deleteMedication(String id) async {
    final idx = _medications.indexWhere((m) => m.id == id);
    if (idx != -1) {
      await ReminderService.instance.cancelForMedication(_medications[idx]);
    }
    await _service.delete(id);
    setState(() => _medications.removeWhere((m) => m.id == id));
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push<Medication>(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
    );
    if (result != null) await _addMedication(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onAdd: _navigateToAdd),
            Expanded(
              child: !_loaded
                  ? const Center(child: CircularProgressIndicator())
                  : _medications.isEmpty
                      ? _EmptyBody(onAddFirst: _navigateToAdd)
                      : _FilledList(
                          medications: _medications,
                          onDelete: _deleteMedication,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onAdd;

  const _Header({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    context.isArabic
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_back_ios_new,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  context.tr('medicationList'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              SvgPicture.asset(AppAssets.logo, width: 52.w),
            ],
          ),
          SizedBox(height: 14.h),
          Center(
            child: GestureDetector(
              onTap: onAdd,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 22.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  context.tr('addMedication'),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  final VoidCallback onAddFirst;

  const _EmptyBody({required this.onAddFirst});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Text(
          context.tr('noMedications'),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: GestureDetector(
            onTap: onAddFirst,
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.accentCyan,
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                context.tr('addFirstMedication'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              AppAssets.elderlyWoman,
              width: 150.w,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Filled list ───────────────────────────────────────────────────────────────

class _FilledList extends StatelessWidget {
  final List<Medication> medications;
  final void Function(String id) onDelete;

  const _FilledList({required this.medications, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: medications.length,
      itemBuilder: (_, index) => MedicationCard(
        medication: medications[index],
        onDelete: () => onDelete(medications[index].id),
      ),
    );
  }
}
