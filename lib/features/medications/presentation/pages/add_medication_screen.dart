import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/medication_model.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final List<TimeOfDay> _selectedTimes = [];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final isArabic = context.isArabic;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryDark,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.primaryDark,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryDark),
          ),
        ),
        child: Directionality(
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
      ),
    );
    if (picked != null && mounted) {
      ctrl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {});
    }
  }

  Future<void> _addTime() async {
    final isArabic = context.isArabic;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryDark,
            onPrimary: AppColors.white,
            surface: AppColors.white,
            onSurface: AppColors.primaryDark,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryDark),
          ),
        ),
        child: Directionality(
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedTimes.add(picked));
    }
  }

  void _removeTime(int index) =>
      setState(() => _selectedTimes.removeAt(index));

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('pleaseEnterMedName')),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r)),
        ),
      );
      return;
    }
    final times = _selectedTimes.isEmpty
        ? ['08:00']
        : _selectedTimes.map(_formatTime).toList();
    Navigator.pop(
      context,
      Medication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        scheduleTimes: times,
        startDate: _startDateController.text.trim().isEmpty
            ? '--/--/----'
            : _startDateController.text.trim(),
        endDate: _endDateController.text.trim().isEmpty
            ? '--/--/----'
            : _endDateController.text.trim(),
        remainingQuantity:
            int.tryParse(_quantityController.text.trim()) ?? 0,
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
            _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FormField(
                      label: context.tr('medicationName'),
                      controller: _nameController,
                      hint: context.tr('enterMedicationName'),
                    ),
                    SizedBox(height: 18.h),
                    _FormField(
                      label: context.tr('dosage'),
                      controller: _dosageController,
                      hint: context.tr('dosageExample'),
                    ),
                    SizedBox(height: 18.h),
                    _TimePickerSection(
                      sectionLabel: context.tr('doseTimes'),
                      addLabel: context.tr('addTime'),
                      emptyText: context.tr('noTimesAdded'),
                      selectedTimes: _selectedTimes,
                      onAdd: _addTime,
                      onRemove: _removeTime,
                      formatTime: _formatTime,
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DateField(
                            label: context.tr('startDate'),
                            controller: _startDateController,
                            hint: context.tr('dateFormat'),
                            onTap: () =>
                                _pickDate(_startDateController),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _DateField(
                            label: context.tr('endDate'),
                            controller: _endDateController,
                            hint: context.tr('dateFormat'),
                            onTap: () =>
                                _pickDate(_endDateController),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    _FormField(
                      label: context.tr('pillsAvailable'),
                      controller: _quantityController,
                      hint: context.tr('pillsExample'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 36.h),
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                          elevation: 3,
                          shadowColor: AppColors.primaryDark
                              .withValues(alpha: 0.35),
                        ),
                        child: Text(
                          context.tr('saveMedication'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
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

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
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
          const Spacer(),
          SvgPicture.asset(AppAssets.logo, width: 52.w),
        ],
      ),
    );
  }
}

// ── Labelled text field ───────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          textDirection: context.appTextDirection,
          style: TextStyle(fontSize: 15.sp, color: AppColors.primaryDark),
          decoration: _inputDecoration(hint, isArabic: isArabic),
        ),
      ],
    );
  }
}

// ── Date picker field ─────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              readOnly: true,
              style:
                  TextStyle(fontSize: 13.sp, color: AppColors.primaryDark),
              decoration: _inputDecoration(hint, isArabic: isArabic).copyWith(
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: AppColors.hintText),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 18.sp,
                  color: AppColors.borderBlue,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Time picker section ───────────────────────────────────────────────────────

class _TimePickerSection extends StatelessWidget {
  final String sectionLabel;
  final String addLabel;
  final String emptyText;
  final List<TimeOfDay> selectedTimes;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final String Function(TimeOfDay) formatTime;

  const _TimePickerSection({
    required this.sectionLabel,
    required this.addLabel,
    required this.emptyText,
    required this.selectedTimes,
    required this.onAdd,
    required this.onRemove,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.accentCyan,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: AppColors.white, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      addLabel,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Text(
              sectionLabel,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 52.h),
          padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: AppColors.borderBlue.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: selectedTimes.isEmpty
              ? Align(
                  alignment: context.isArabic
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    emptyText,
                    style: TextStyle(
                        fontSize: 13.sp, color: AppColors.hintText),
                  ),
                )
              : Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  alignment: context.isArabic
                      ? WrapAlignment.end
                      : WrapAlignment.start,
                  children: List.generate(
                    selectedTimes.length,
                    (i) => _TimeChip(
                      label: formatTime(selectedTimes[i]),
                      onDelete: () => onRemove(i),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Time chip ─────────────────────────────────────────────────────────────────

class _TimeChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const _TimeChip({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.accentCyan, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, size: 14.sp, color: AppColors.red),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ── InputDecoration helper ────────────────────────────────────────────────────

InputDecoration _inputDecoration(String hint, {bool isArabic = true}) =>
    InputDecoration(
      hintText: hint,
      hintTextDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.hintText),
      contentPadding:
          EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide: BorderSide(
          color: AppColors.borderBlue.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.r),
        borderSide:
            BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      filled: true,
      fillColor: AppColors.white,
    );
