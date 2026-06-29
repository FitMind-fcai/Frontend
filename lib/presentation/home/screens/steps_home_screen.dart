import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:health/health.dart';
import '../../../core/constants/app_constants.dart';

class StepsTakenPage extends StatefulWidget {
  const StepsTakenPage({super.key});

  @override
  State<StepsTakenPage> createState() => _StepsTakenPageState();
}

class _StepsTakenPageState extends State<StepsTakenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final Health _health = Health();

  static const int goalSteps = 10000;

  int totalSteps = 0;
  double totalCalories = 0;
  double totalDistanceKm = 0;
  int activeMinutes = 0;

  bool _isLoading = true;

  static final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
    HealthDataType.EXERCISE_TIME,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _initHealthData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initHealthData() async {
    await _health.configure();

    final hasPermissions = await _health.hasPermissions(_types);

    if (hasPermissions != true) {
      final granted = await _health.requestAuthorization(_types);
      if (!granted) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        return;
      }
    }

    await _fetchTodayData();
  }

  Future<void> _fetchTodayData() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      final steps = await _health.getTotalStepsInInterval(midnight, now) ?? 0;

      final healthData = await _health.getHealthDataFromTypes(
        types: _types,
        startTime: midnight,
        endTime: now,
      );
      final deduped = _health.removeDuplicates(healthData);

      double calories = 0;
      double distanceMeters = 0;
      int exerciseMinutes = 0;

      for (final point in deduped) {
        final value = point.value;
        if (value is! NumericHealthValue) continue;
        final numericValue = value.numericValue.toDouble();

        switch (point.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            calories += numericValue;
            break;
          case HealthDataType.DISTANCE_DELTA:
            distanceMeters += numericValue;
            break;
          case HealthDataType.EXERCISE_TIME:
            exerciseMinutes += numericValue.round();
            break;
          default:
            break;
        }
      }

      if (!mounted) return;
      setState(() {
        totalSteps = steps;
        totalCalories = calories;
        totalDistanceKm = distanceMeters / 1000;
        activeMinutes = exerciseMinutes;
        _isLoading = false;
      });
      _controller.forward();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'steps_taken.title'.tr(),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(color: colorScheme.primary),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Animated Ring Chart
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return SizedBox(
                  width: 320,
                  height: 320,
                  child: CustomPaint(
                    painter: StepsRingPainter(
                      progress: _animation.value,
                      stepsFraction:
                      (totalSteps / goalSteps).clamp(0.0, 1.0),
                      trackColor: colorScheme.surfaceContainerHighest,
                      middleRingColor: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF374151),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_walk,
                        size: 40,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Step count
            Text(
              totalSteps.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (m) => '${m[1]},'),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: AppConstants.fontRegular,
                color: colorScheme.onSurface,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'steps_taken.total_steps'.tr(),
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontFamily: AppConstants.fontRegular,
              ),
            ),

            const SizedBox(height: 48),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  icon: Icons.local_fire_department,
                  value: totalCalories.round().toString(),
                  label: 'steps_taken.unit_kcal'.tr(),
                  color: const Color(0xFFFF6B00),
                ),
                _StatItem(
                  icon: Icons.location_on_outlined,
                  value: totalDistanceKm.toStringAsFixed(1),
                  label: 'steps_taken.unit_kilometer'.tr(),
                  color: const Color(0xFF6B7280),
                ),
                _StatItem(
                  icon: Icons.timer_outlined,
                  value: activeMinutes.toString(),
                  label: 'steps_taken.unit_minute'.tr(),
                  color: const Color(0xFF3B82F6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Item Widget ──────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurfaceVariant,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
      ],
    );
  }
}

// ── Custom Ring Painter ───────────────────────────────────────────────────────

class StepsRingPainter extends CustomPainter {
  final double progress;
  final double stepsFraction;
  final Color trackColor;
  final Color middleRingColor;

  StepsRingPainter({
    required this.progress,
    required this.stepsFraction,
    required this.trackColor,
    required this.middleRingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 28.0;
    final gap = 10.0;

    final rings = [
      _RingConfig(0, stepsFraction, const Color(0xFFFF6B00)),
      _RingConfig((strokeWidth + gap), 0.45, middleRingColor),
      _RingConfig((strokeWidth + gap) * 2, 0.15, const Color(0xFF3B82F6)),
    ];

    for (final ring in rings) {
      final inset = ring.inset + strokeWidth / 2;
      final rect = Rect.fromLTWH(
        inset, inset,
        size.width - inset * 2,
        size.height - inset * 2,
      );
      final radius = Radius.circular(rect.width * 0.35);
      final rrect = RRect.fromRectAndRadius(rect, radius);
      final fullPath = Path()..addRRect(rrect);

      final metrics = fullPath.computeMetrics().toList();
      if (metrics.isEmpty) continue;
      final metric = metrics.first;
      final totalLength = metric.length;

      // Start from top-center (≈75% along the default RRect path)
      final startOffset = totalLength * 0.25;

      // ── Background track ──
      final trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.round;
      canvas.drawRRect(rrect, trackPaint);

      // ── Progress path ──
      final progressLength = totalLength * ring.fraction * progress;
      final progressPath = Path();

      final end = startOffset + progressLength;
      if (end <= totalLength) {
        progressPath.addPath(
          metric.extractPath(startOffset, end),
          Offset.zero,
        );
      } else {
        // Wrap around
        progressPath.addPath(
          metric.extractPath(startOffset, totalLength),
          Offset.zero,
        );
        progressPath.addPath(
          metric.extractPath(0, end - totalLength),
          Offset.zero,
        );
      }

      final progressPaint = Paint()
        ..color = ring.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(progressPath, progressPaint);
    }
  }

  @override
  bool shouldRepaint(StepsRingPainter old) =>
      old.progress != progress ||
          old.stepsFraction != stepsFraction ||
          old.trackColor != trackColor ||
          old.middleRingColor != middleRingColor;
}

class _RingConfig {
  final double inset;
  final double fraction;
  final Color color;
  const _RingConfig(this.inset, this.fraction, this.color);
}