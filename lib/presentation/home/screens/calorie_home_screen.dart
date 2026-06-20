import 'package:fitmind/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CalorieStatsPage extends StatefulWidget {
  const CalorieStatsPage({super.key});

  @override
  State<CalorieStatsPage> createState() => _CalorieStatsPageState();
}

class _CalorieStatsPageState extends State<CalorieStatsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // CHANGED: bars/legends used to be static `const` fields. The "Fat" color
  // (0xFF1A1A1A, near-black) reads fine on a white background but would
  // nearly disappear against a dark scaffold. Turning these into methods
  // that take BuildContext lets that one swatch flip to a light neutral in
  // dark mode while every other accent color (orange/blue/green) stays the
  // same in both themes — they're vivid enough to read against either.
  List<_BarData> _buildBars(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      _BarData(
        label: 'calorie_stats.macro_fat'.tr(),
        percent: 0.20,
        value: '20%',
        color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF1A1A1A),
        icon: Icons.egg_alt,
      ),
      _BarData(
        label: 'calorie_stats.macro_protein'.tr(),
        percent: 0.30,
        value: '30%',
        color: const Color(0xFFFF6B00),
        icon: Icons.local_drink,
      ),
      _BarData(
        label: 'calorie_stats.macro_carbs'.tr(),
        percent: 0.40,
        value: '40%',
        color: const Color(0xFF3B82F6),
        icon: Icons.restaurant,
      ),
      _BarData(
        label: 'calorie_stats.macro_other'.tr(),
        percent: 0.10,
        value: '10%',
        color: const Color(0xFF84CC16),
        icon: Icons.eco,
      ),
    ];
  }

  List<_LegendData> _buildLegends(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      _LegendData(
        label: 'calorie_stats.macro_fat'.tr(),
        amount: '201g',
        color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF1A1A1A),
      ),
      _LegendData(label: 'calorie_stats.macro_protein'.tr(), amount: '158g', color: const Color(0xFFFF6B00)),
      _LegendData(label: 'calorie_stats.macro_carbs'.tr(),amount: '11g', color: const Color(0xFF3B82F6)),
      _LegendData(label: 'calorie_stats.macro_other'.tr(), amount: '5g', color: const Color(0xFF84CC16)),
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
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
    final bars = _buildBars(context);
    final legends = _buildLegends(context);

    // Logic to find the highest/lowest percent in the current list
    final maxVal = bars.map((e) => e.percent).reduce((a, b) => a > b ? a : b);
    final minVal = bars.map((e) => e.percent).reduce((a, b) => a < b ? a : b);

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Title + Month selector ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'calorie_stats.title'.tr(),
                  style: TextStyle(

                  fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppConstants.fontRegular,
                    // CHANGED: was Colors.black87 — now onSurface.
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    // CHANGED: was Colors.grey.shade100 — now the M3 token
                    // for an elevated neutral chip, defined for both themes.
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16,
                        // CHANGED: was Colors.black54 — now onSurfaceVariant.
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Jan',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        // CHANGED: was Colors.black54 — now onSurfaceVariant.
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Bar Chart ──
            AnimatedBuilder(
              animation: _animation,
              builder: (context, _) {
                return SizedBox(
                  height: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: bars
                        .map((bar) => _AnimatedBar(
                        bar: bar,
                        progress: _animation.value,
                        maxInList: maxVal,
                        minInList: minVal))
                        .toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // ── Legend ──
            ...legends.indexed.map((entry) {
              final i = entry.$1;
              final l = entry.$2;
              return Column(
                children: [
                  _LegendRow(data: l),
                  if (i < legends.length - 1)
                    Divider(
                      // CHANGED: was Colors.grey.shade400 — now outlineVariant.
                      color: colorScheme.outlineVariant,
                      height: 1,
                      thickness: 1,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Animated Bar ─────────────────────────────────────────────────────────────
class _AnimatedBar extends StatelessWidget {
  final _BarData bar;
  final double progress;
  final double maxInList;
  final double minInList;

  const _AnimatedBar({
    required this.bar,
    required this.progress,
    required this.maxInList,
    required this.minInList,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const totalHeight = 300.0;
    const maxVisualHeight = 240.0; // The ceiling
    const minVisualHeight = 100.0; // The floor (ensure 10% is visible)

    // DYNAMIC CALCULATION:
    // If all bars are the same, or there's only one bar, default to max height
    double targetHeight;
    if (maxInList == minInList) {
      targetHeight = maxVisualHeight;
    } else {
      // Map the bar's value onto the scale between minVisualHeight and maxVisualHeight
      targetHeight = minVisualHeight +
          (bar.percent - minInList) *
              (maxVisualHeight - minVisualHeight) /
              (maxInList - minInList);
    }

    final barHeight = targetHeight * progress;

    return SizedBox(
      width: 90,
      height: totalHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 90,
            height: totalHeight,
            decoration: BoxDecoration(
              // CHANGED: was Colors.grey.shade100 — now the elevated
              // neutral token, so the unfilled "track" still reads as a
              // distinct layer against a dark scaffold.
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Container(
            width: 90,
            height: barHeight,
            decoration: BoxDecoration(
              color: bar.color,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // NOTE: this badge and the value text below sit on top of the
          // colored bar fill itself (never on the page background), so a
          // translucent white badge with a white icon/text reads fine in
          // both themes — left as-is intentionally.
          Positioned(
            bottom: barHeight - 45,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(bar.icon, color: Colors.white, size: 22),
            ),
          ),
          Positioned(
            bottom: 12,
            child: Text(
              bar.value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Legend Row ────────────────────────────────────────────────────────────────

class _LegendRow extends StatelessWidget {
  final _LegendData data;

  const _LegendRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data.label,
            style: TextStyle(
                fontSize: 18,
                // CHANGED: was Colors.black87 — now onSurface.
                color: colorScheme.onSurface,
                fontFamily: AppConstants.fontRegular),
          ),
          const Spacer(),
          Text(
            data.amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: AppConstants.fontRegular,
              // CHANGED: was Colors.grey[700] — now onSurfaceVariant.
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────

class _BarData {
  final String label;
  final double percent;
  final String value;
  final Color color;
  final IconData icon;

  const _BarData({
    required this.label,
    required this.percent,
    required this.value,
    required this.color,
    required this.icon,
  });
}

class _LegendData {
  final String label;
  final String amount;
  final Color color;

  const _LegendData(
      {required this.label, required this.amount, required this.color});
}