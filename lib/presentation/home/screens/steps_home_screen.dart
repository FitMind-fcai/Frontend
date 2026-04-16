import 'dart:math';
import 'package:flutter/material.dart';

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

  final int totalSteps = 2574;
  final int goalSteps = 10000;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Steps Taken',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
        centerTitle: true,

      ),
      body: Padding(
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
                    painter: StepsRingPainter(progress: _animation.value),
                    child: Center(
                      child: Icon(Icons.directions_walk, size: 40, color: Colors.black87),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Step count
            Text(
              '${totalSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: AppConstants.fontRegular,
                color: Colors.black87,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'total steps',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
                fontWeight: FontWeight.w700,
                fontFamily: AppConstants.fontRegular
              ),
            ),

            const SizedBox(height: 48),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StatItem(icon: Icons.local_fire_department, value: '578', label: 'kcal', color: Color(0xFFFF6B00)),
                _StatItem(icon: Icons.location_on_outlined, value: '7.5', label: 'kilometer', color: Color(0xFF6B7280)),
                _StatItem(icon: Icons.timer_outlined, value: '25', label: 'minute', color: Color(0xFF3B82F6)),
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
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
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

  StepsRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 28.0;
    final gap = 10.0;

    final rings = [
      _RingConfig(0,                       0.70, const Color(0xFFFF6B00)),
      _RingConfig((strokeWidth + gap),     0.45, const Color(0xFF374151)),
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
        ..color = Colors.grey.shade200
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
  bool shouldRepaint(StepsRingPainter old) => old.progress != progress;
}

class _RingConfig {
  final double inset;
  final double fraction;
  final Color color;
  const _RingConfig(this.inset, this.fraction, this.color);
}