import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class MedicationReminderScreen extends StatefulWidget {
  final String medicationName;
  final String scheduledTime;

  const MedicationReminderScreen({
    super.key,
    this.medicationName = '',
    this.scheduledTime = '',
  });

  @override
  State<MedicationReminderScreen> createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final AnimationController _glowCtrl;
  late final AnimationController _bellCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _glowAnim;
  late final Animation<double> _bellAnim;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _clockTimer;
  String _clockHM = '';
  bool _isPM = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startClock();
    _initSound();
    _triggerVibration();
  }

  void _initAnimations() {
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _bellCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _glowAnim = Tween<double>(begin: 0.15, end: 1.0).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
    _bellAnim = Tween<double>(begin: -0.15, end: 0.15).animate(
      CurvedAnimation(parent: _bellCtrl, curve: Curves.elasticInOut),
    );
  }

  void _startClock() {
    _updateTime();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    final h =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final m = now.minute.toString().padLeft(2, '0');
    if (mounted) {
      setState(() {
        _clockHM = '$h:$m';
        _isPM = now.hour >= 12;
      });
    }
  }

  Future<void> _initSound() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('audio/alert.mp3'));
    } catch (_) {}
  }

  void _triggerVibration() {
    HapticFeedback.heavyImpact();
    Future.delayed(
        const Duration(milliseconds: 350), HapticFeedback.heavyImpact);
    Future.delayed(
        const Duration(milliseconds: 700), HapticFeedback.heavyImpact);
  }

  Future<void> _stopAlerts() async {
    _pulseCtrl.stop();
    _glowCtrl.stop();
    _bellCtrl.stop();
    await _audioPlayer.stop();
  }

  void _onTakenPressed() async {
    await _stopAlerts();
    if (!mounted) return;
    _showSuccessDialog();
  }

  void _onNotYetPressed() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _RemindLaterSheet(
        onSelected: (minutes) async {
          Navigator.pop(context);
          final messenger = ScaffoldMessenger.of(context);
          final navigator = Navigator.of(context);
          final snackText = context.tr('willRemindIn',
              args: {'minutes': '$minutes'});
          final snackDir = context.appTextDirection;
          await _stopAlerts();
          if (!mounted) return;
          messenger.showSnackBar(
            SnackBar(
              content: Text(snackText, textDirection: snackDir),
              backgroundColor: AppColors.primaryDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
          );
          navigator.pop();
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(
        medicationName: widget.medicationName,
        onDone: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _glowCtrl.dispose();
    _bellCtrl.dispose();
    _clockTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1A2B3C) : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.primaryDark;
    final textSecondary =
        isDark ? Colors.white70 : AppColors.borderBlue;

    final periodLabel = context.tr(_isPM ? 'pm' : 'am');
    final currentTime = _clockHM.isEmpty ? '' : '$_clockHM $periodLabel';

    return Directionality(
      textDirection: context.appTextDirection,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                _ReminderHeader(
                  currentTime: currentTime,
                  currentTimeLabel: context.tr('currentTime'),
                  bellAnim: _bellAnim,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  cardColor: cardColor,
                ),
                SizedBox(height: 28.h),
                _EmergencyImage(
                  scaleAnim: _scaleAnim,
                  glowAnim: _glowAnim,
                ),
                SizedBox(height: 28.h),
                Text(
                  context.tr('medicineReminder'),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  context.tr('timeToTakeMed'),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                _MedicineCard(
                  name: widget.medicationName,
                  time: widget.scheduledTime,
                  dueNowLabel: context.tr('dueNow'),
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                ),
                SizedBox(height: 28.h),
                Text(
                  context.tr('didYouTakeMed'),
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                _TakenButton(
                  label: context.tr('yesTookMed'),
                  onPressed: _onTakenPressed,
                ),
                SizedBox(height: 14.h),
                _NotYetButton(
                  label: context.tr('notYet'),
                  onPressed: _onNotYetPressed,
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () async {
                    final nav = Navigator.of(context);
                    await _stopAlerts();
                    nav.pop();
                  },
                  child: Text(
                    context.tr('ignoreReminder'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.hintText,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header: current time + animated bell ────────────────────────────────────

class _ReminderHeader extends StatelessWidget {
  final String currentTime;
  final String currentTimeLabel;
  final Animation<double> bellAnim;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardColor;

  const _ReminderHeader({
    required this.currentTime,
    required this.currentTimeLabel,
    required this.bellAnim,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentTimeLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                currentTime,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: bellAnim,
            builder: (_, child) => Transform.rotate(
              angle: bellAnim.value,
              child: child,
            ),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: AppColors.red,
                size: 28.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Emergency image with pulse scale + red glow ──────────────────────────────

class _EmergencyImage extends StatelessWidget {
  final Animation<double> scaleAnim;
  final Animation<double> glowAnim;

  const _EmergencyImage({
    required this.scaleAnim,
    required this.glowAnim,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([scaleAnim, glowAnim]),
      builder: (_, child) {
        return Transform.scale(
          scale: scaleAnim.value,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.red.withValues(alpha: glowAnim.value * 0.55),
                  blurRadius: 50 * glowAnim.value,
                  spreadRadius: 12 * glowAnim.value,
                ),
                BoxShadow(
                  color: Colors.deepOrange
                      .withValues(alpha: glowAnim.value * 0.25),
                  blurRadius: 80 * glowAnim.value,
                  spreadRadius: 4 * glowAnim.value,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Image.asset(
        'assets/images/emergency.png',
        width: 200.w,
        height: 200.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

// ── Medicine name + time card ─────────────────────────────────────────────────

class _MedicineCard extends StatelessWidget {
  final String name;
  final String time;
  final String dueNowLabel;
  final Color cardColor;
  final Color textPrimary;

  const _MedicineCard({
    required this.name,
    required this.time,
    required this.dueNowLabel,
    required this.cardColor,
    required this.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.medication_rounded,
              color: AppColors.accentCyan,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.accentCyan,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              dueNowLabel,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Green gradient "Yes, I took it" button ───────────────────────────────────

class _TakenButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _TakenButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Orange outlined "Not yet" button ─────────────────────────────────────────

class _NotYetButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _NotYetButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE67E22), width: 2),
          padding: EdgeInsets.symmetric(vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        icon: Icon(
          Icons.access_time_rounded,
          color: const Color(0xFFE67E22),
          size: 20.sp,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFE67E22),
          ),
        ),
      ),
    );
  }
}

// ── Remind-later bottom sheet ─────────────────────────────────────────────────

class _RemindLaterSheet extends StatelessWidget {
  final void Function(int minutes) onSelected;

  const _RemindLaterSheet({required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.appTextDirection,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              context.tr('whenToRemind'),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),
            Text(
              context.tr('chooseReminderTime'),
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.hintText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                    child: _RemindOption(
                        minutes: 5,
                        minutesLabel: context.tr('minutes'),
                        onSelected: onSelected)),
                SizedBox(width: 16.w),
                Expanded(
                    child: _RemindOption(
                        minutes: 10,
                        minutesLabel: context.tr('minutes'),
                        onSelected: onSelected)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RemindOption extends StatelessWidget {
  final int minutes;
  final String minutesLabel;
  final void Function(int minutes) onSelected;

  const _RemindOption({
    required this.minutes,
    required this.minutesLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(minutes),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.primaryDark.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primaryDark.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.timer_outlined,
              color: AppColors.primaryDark,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              '$minutes',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
            Text(
              minutesLabel,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.borderBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Success confirmation dialog ───────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  final String medicationName;
  final VoidCallback onDone;

  const _SuccessDialog({
    required this.medicationName,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.appTextDirection,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(28.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.green,
                  size: 56.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                context.tr('wellDone'),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.tr('recordedTakingMed', args: {'name': medicationName}),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.borderBlue,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    context.tr('ok'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
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
