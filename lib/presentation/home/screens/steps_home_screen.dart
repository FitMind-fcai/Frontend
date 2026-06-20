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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // CHANGED: was Colors.white — now follows the active theme's surface.
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            // CHANGED: was Colors.black87 — now onSurface.
            color: colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Steps Taken',
          style: TextStyle(
            // CHANGED: was Colors.black87 — now onSurface.
            color: colorScheme.onSurface,
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
                    painter: StepsRingPainter(
                      progress: _animation.value,
                      // CHANGED: passing theme-derived colors into the
                      // painter, since CustomPainter has no BuildContext
                      // of its own to call Theme.of() with.
                      trackColor: colorScheme.surfaceContainerHighest,
                      // CHANGED: the middle ring (0xFF374151, a dark slate)
                      // reads as a muted neutral on white but would blend
                      // into a near-black background. Flip to a light gray
                      // in dark mode so it stays legible against the track.
                      middleRingColor: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF374151),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_walk,
                        size: 40,
                        // CHANGED: was Colors.black87 — now onSurface.
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
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                fontFamily: AppConstants.fontRegular,
                // CHANGED: was Colors.black87 — now onSurface.
                color: colorScheme.onSurface,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'total steps',
              style: TextStyle(
                fontSize: 20,
                // CHANGED: was Colors.grey[700] — now onSurfaceVariant.
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                fontFamily: AppConstants.fontRegular,
              ),
            ),

            const SizedBox(height: 48),

            // Stats row
            // NOTE: the three accent colors below (orange/gray/blue) are
            // left as-is — each sits behind a white icon on its own
            // colored chip, never directly on the page background, so they
            // read fine in both themes.
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
            // CHANGED: was Colors.black87 — now onSurface.
            color: colorScheme.onSurface,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            // CHANGED: was Colors.grey — now onSurfaceVariant.
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
  final Color trackColor;
  final Color middleRingColor;

  StepsRingPainter({
    required this.progress,
    required this.trackColor,
    required this.middleRingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 28.0;
    final gap = 10.0;

    final rings = [
      _RingConfig(0,                       0.70, const Color(0xFFFF6B00)),
      _RingConfig((strokeWidth + gap),     0.45, middleRingColor),
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
      // CHANGED: was Colors.grey.shade200 — now a theme-derived color so
      // the unfilled track stays visible (and visually distinct from the
      // page background) in dark mode too.
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
          old.trackColor != trackColor ||
          old.middleRingColor != middleRingColor;
}

class _RingConfig {
  final double inset;
  final double fraction;
  final Color color;
  const _RingConfig(this.inset, this.fraction, this.color);
}