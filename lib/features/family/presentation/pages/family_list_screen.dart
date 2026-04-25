import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_screen_header.dart';
import '../../data/services/family_local_service.dart';
import '../../domain/models/family_member_model.dart';
import 'family_form_screen.dart';

class FamilyListScreen extends StatefulWidget {
  const FamilyListScreen({super.key});

  @override
  State<FamilyListScreen> createState() => _FamilyListScreenState();
}

class _FamilyListScreenState extends State<FamilyListScreen> {
  final _service = FamilyLocalService();
  final List<FamilyMember> _members = [];
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
        _members.addAll(items);
        _loaded = true;
      });
    }
  }

  Future<void> _addMember(FamilyMember member) async {
    await _service.add(member);
    setState(() => _members.add(member));
  }

  Future<void> _deleteMember(String id) async {
    await _service.delete(id);
    setState(() => _members.removeWhere((m) => m.id == id));
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push<FamilyMember>(
      context,
      MaterialPageRoute(builder: (_) => const FamilyFormScreen()),
    );
    if (result != null) await _addMember(result);
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
              AppScreenHeader(
                title: 'قائمة عائلتي',
                addLabel: '+ اضافة فرد',
                onAdd: _navigateToAdd,
              ),

              Expanded(
                child: !_loaded
                    ? const Center(child: CircularProgressIndicator())
                    : _members.isEmpty
                        ? _EmptyBody(onAddFirst: _navigateToAdd)
                        : _FilledList(
                            members: _members,
                            onDelete: _deleteMember,
                          ),
              ),
            ],
          ),
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
            'سيتم تنبيه عائلتك عندما لا تشرب الدواء في موعده',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.borderBlue,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'لم تقم بإضافة أي فرد من العائلة بعد',
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
                  '+ اضافة اول فرد',
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
  final List<FamilyMember> members;
  final void Function(String id) onDelete;

  const _FilledList({required this.members, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      itemCount: members.length,
      itemBuilder: (_, index) => FamilyCard(
        member: members[index],
        onDelete: () => onDelete(members[index].id),
      ),
    );
  }
}

// ── Family member card ─────────────────────────────────────────────────────────

class FamilyCard extends StatelessWidget {
  final FamilyMember member;
  final VoidCallback onDelete;

  const FamilyCard({
    super.key,
    required this.member,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderBlue.withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Top row: name (right) + delete (left) ──────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(child: _InfoBox(text: member.name)),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _divider(),

          // ── Phone ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: _InfoBox(text: member.phone),
          ),

          _divider(),

          // ── Relationship ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: _InfoBox(text: member.relationship),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.borderBlue.withValues(alpha: 0.15),
        indent: 12,
        endIndent: 12,
      );
}

// ── Light-blue info section box ───────────────────────────────────────────────

class _InfoBox extends StatelessWidget {
  final String text;

  const _InfoBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}
