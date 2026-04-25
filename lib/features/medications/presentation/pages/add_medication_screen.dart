import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_assets.dart';
import '../../../../app/theme/app_colors.dart';
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

  // Selected dose times — displayed as chips
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

  // ── Date picker ─────────────────────────────────────────────────

  Future<void> _pickDate(TextEditingController ctrl) async {
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
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryDark),
          ),
        ),
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
    if (picked != null && mounted) {
      ctrl.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      setState(() {});
    }
  }

  // ── Time picker ─────────────────────────────────────────────────

  Future<void> _addTime() async {
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
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryDark),
          ),
        ),
        child: Directionality(textDirection: TextDirection.rtl, child: child!),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedTimes.add(picked));
    }
  }

  void _removeTime(int index) => setState(() => _selectedTimes.removeAt(index));

  // ── Format TimeOfDay as HH:mm ────────────────────────────────────

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  // ── Save ─────────────────────────────────────────────────────────

  void _save() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'يرجى إدخال اسم الدواء',
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
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
        remainingQuantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────

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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  // CrossAxisAlignment.start = RIGHT in RTL
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم الدواء
                    _FormField(
                      label: 'اسم الدواء',
                      controller: _nameController,
                      hint: 'أدخل اسم الدواء',
                    ),
                    SizedBox(height: 18.h),

                    // الجرعة
                    _FormField(
                      label: 'الجرعة',
                      controller: _dosageController,
                      hint: 'مثال: 500 ملغ',
                    ),
                    SizedBox(height: 18.h),

                    // مواعيد الجرعات — time-picker section
                    _TimePickerSection(
                      selectedTimes: _selectedTimes,
                      onAdd: _addTime,
                      onRemove: _removeTime,
                      formatTime: _formatTime,
                    ),
                    SizedBox(height: 18.h),

                    // Dates row
                    // In RTL: children[0] = visually RIGHT  → تاريخ البداية
                    //          children[1] = visually LEFT   → تاريخ النهاية
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DateField(
                            label: 'تاريخ البداية',
                            controller: _startDateController,
                            onTap: () => _pickDate(_startDateController),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _DateField(
                            label: 'تاريخ النهاية',
                            controller: _endDateController,
                            onTap: () => _pickDate(_endDateController),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // كم حبة من الدواء متوفرة؟
                    _FormField(
                      label: 'كم حبة من الدواء متوفرة؟',
                      controller: _quantityController,
                      hint: 'مثال: 30',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 36.h),

                    // حفظ الدواء
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
                          shadowColor: AppColors.primaryDark.withValues(
                            alpha: 0.35,
                          ),
                        ),
                        child: Text(
                          'حفظ الدواء',
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
// RTL: children[0] = visually RIGHT = back arrow
//       Spacer
//       children[-1] = visually LEFT = logo

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // RIGHT side (RTL start): back arrow
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
              // arrow_forward_ios points RIGHT — correct RTL back direction
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.white,
                size: 18.sp,
              ),
            ),
          ),
          const Spacer(),
          // LEFT side (RTL end): logo
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
    return Column(
      // CrossAxisAlignment.start = RIGHT in RTL → labels anchored to the right
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textDirection: TextDirection.rtl,
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
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 15.sp, color: AppColors.primaryDark),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }
}

// ── Date picker field ─────────────────────────────────────────────────────────

class _DateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // CrossAxisAlignment.start = RIGHT in RTL
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textDirection: TextDirection.rtl,
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
              textAlign: TextAlign.right,
              readOnly: true,
              style: TextStyle(fontSize: 13.sp, color: AppColors.primaryDark),
              decoration: _inputDecoration('DD/MM/YYYY').copyWith(
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.hintText,
                ),
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
  final List<TimeOfDay> selectedTimes;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final String Function(TimeOfDay) formatTime;

  const _TimePickerSection({
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
        // Row: label (right) + add button (left)
        Row(
          children: [
            // LEFT (RTL end): "+ اضافة موعد" button
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
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
                      'اضافة موعد',
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
            // RIGHT (RTL start): label
            Text(
              'مواعيد الجرعات',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // Container that holds either chips or the hint
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 52.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                  alignment: Alignment.centerRight,
                  child: Text(
                    'لم يتم إضافة مواعيد بعد',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.hintText,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  alignment: WrapAlignment.end,
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

// ── Single time chip ──────────────────────────────────────────────────────────

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
          // Delete icon (visually LEFT in RTL = end of chip)
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

// ── Shared InputDecoration helper ─────────────────────────────────────────────

InputDecoration _inputDecoration(String hint) => InputDecoration(
  hintText: hint,
  hintTextDirection: TextDirection.rtl,
  hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.hintText),
  contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(28.r),
    borderSide: BorderSide(
      color: AppColors.borderBlue.withValues(alpha: 0.5),
      width: 1.5,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(28.r),
    borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
  ),
  filled: true,
  fillColor: AppColors.white,
);
