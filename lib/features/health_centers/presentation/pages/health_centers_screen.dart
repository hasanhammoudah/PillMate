import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../data/services/health_center_local_service.dart';
import '../../domain/models/health_center_model.dart';
import '../widgets/health_center_card.dart';
import 'health_center_form_screen.dart';

class HealthCentersScreen extends StatefulWidget {
  const HealthCentersScreen({super.key});

  @override
  State<HealthCentersScreen> createState() => _HealthCentersScreenState();
}

class _HealthCentersScreenState extends State<HealthCentersScreen> {
  final _service = HealthCenterLocalService();
  final List<HealthCenter> _centers = [];
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
        _centers.addAll(items);
        _loaded = true;
      });
    }
  }

  Future<void> _addCenter(HealthCenter center) async {
    await _service.add(center);
    setState(() => _centers.add(center));
  }

  Future<void> _deleteCenter(String id) async {
    await _service.delete(id);
    setState(() => _centers.removeWhere((c) => c.id == id));
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push<HealthCenter>(
      context,
      MaterialPageRoute(builder: (_) => const HealthCenterFormScreen()),
    );
    if (result != null) await _addCenter(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppScreenHeader(
              title: context.tr('healthCentersList'),
              addLabel: context.tr('addCenter'),
              onAdd: _navigateToAdd,
            ),

            Expanded(
              child: !_loaded
                  ? const Center(child: CircularProgressIndicator())
                  : _centers.isEmpty
                      ? _EmptyBody(onAddFirst: _navigateToAdd)
                      : _FilledList(
                          centers: _centers,
                          onDelete: _deleteCenter,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  final VoidCallback onAddFirst;

  const _EmptyBody({required this.onAddFirst});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 22.h),
          Text(
            context.tr('noHealthCenters'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryDark,
            ),
          ),
          SizedBox(height: 22.h),
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
                  context.tr('addFirstCenter'),
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
                width: 160.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Filled list ────────────────────────────────────────────────────────────────

class _FilledList extends StatelessWidget {
  final List<HealthCenter> centers;
  final void Function(String id) onDelete;

  const _FilledList({required this.centers, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: centers.length,
      itemBuilder: (_, index) => HealthCenterCard(
        center: centers[index],
        onDelete: () => onDelete(centers[index].id),
      ),
    );
  }
}
