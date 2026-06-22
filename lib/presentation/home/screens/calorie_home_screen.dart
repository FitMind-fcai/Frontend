import 'package:fitmind/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/models/home/calorie_screen_result.dart';
import '../../log/manager/log_bloc.dart';

class CalorieStatsPage extends StatefulWidget {
  const CalorieStatsPage({super.key});

  @override
  State<CalorieStatsPage> createState() => _CalorieStatsPageState();
}

class _CalorieStatsPageState extends State<CalorieStatsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // NEW: the month/date chip is now backed by real state instead of a
  // static "Jan" string, and drives which day's summary gets requested.
  DateTime _selectedDate = DateTime.now();

  static const _monthAbbr = [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _apiDateString(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    setState(() => _selectedDate = picked);
    context
        .read<LogBloc>()
        .add(LoadMealsSummaryEvent(date: _apiDateString(_selectedDate)));
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
    // NOTE: animation no longer starts immediately — it now starts once
    // real data actually arrives (see the BlocConsumer listener below),
    // so the bars don't animate to zero/placeholder values before the
    // API response lands.
    context
        .read<LogBloc>()
        .add(LoadMealsSummaryEvent(date: _apiDateString(_selectedDate)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // CHANGED: bars/legends used to be static mock data. They're now built
  // from the real MealsSummaryResult, with the same dark-mode-aware "Fat"
  // color swap as before (near-black in light, light gray in dark, since
  // accent colors like orange/blue read fine in both themes unchanged).
  // NOTE: the original mock data had a 4th "Macro" category that the API
  // doesn't return anything for — dropped here, only Fat/Protein/Carbs
  // remain. Flag if that 4th bucket was meant to map to something else.
  List<_BarData> _buildBars(BuildContext context, MealsSummaryResult s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      _BarData(
        label: 'calorie_stats.macro_fat'.tr(),
        percent: s.fatsPct / 100,
        value: '${s.fatsPct.round()}%',
        color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF1A1A1A),
        icon: Icons.egg_alt,
      ),
      _BarData(
        label: 'calorie_stats.macro_protein'.tr(),
        percent: s.proteinPct / 100,
        value: '${s.proteinPct.round()}%',
        color: const Color(0xFFFF6B00),
        icon: Icons.local_drink,
      ),
      _BarData(
        label: 'calorie_stats.macro_carbs'.tr(),
        percent: s.carbsPct / 100,
        value: '${s.carbsPct.round()}%',
        color: const Color(0xFF3B82F6),
        icon: Icons.restaurant,
      ),
    ];
  }

  List<_LegendData> _buildLegends(BuildContext context, MealsSummaryResult s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      _LegendData(
        label: 'calorie_stats.macro_fat'.tr(),
        amount: '${s.totalFatsG.toStringAsFixed(s.totalFatsG % 1 == 0 ? 0 : 1)}g',
        color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF1A1A1A),
      ),
      _LegendData(
        label: 'calorie_stats.macro_protein'.tr(),
        amount: '${s.totalProteinG.toStringAsFixed(s.totalProteinG % 1 == 0 ? 0 : 1)}g',
        color: const Color(0xFFFF6B00),
      ),
      _LegendData(
        label: 'calorie_stats.macro_carbs'.tr(),
        amount: '${s.totalCarbsG.toStringAsFixed(s.totalCarbsG % 1 == 0 ? 0 : 1)}g',
        color: const Color(0xFF3B82F6),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Title + Date selector ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'calorie_stats.title'.tr(),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppConstants.fontRegular,
                    color: colorScheme.onSurface,
                  ),
                ),
                // CHANGED: was a static "Jan" label with no behavior at
                // all. Now wrapped in a GestureDetector that opens a real
                // date picker, shows the actual selected date, and
                // re-fetches the summary for whichever day is picked.
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_monthAbbr[_selectedDate.month]} ${_selectedDate.day}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Chart + legend, driven by real data ──
            Expanded(
              child: BlocConsumer<LogBloc, LogState>(
                listener: (context, state) {
                  // Kick off the bar-growth animation the moment real data
                  // lands, instead of on initState (when there's nothing
                  // real to animate towards yet).
                  if (state is MealsSummaryLoaded) {
                    _controller.forward(from: 0);
                  }
                },
                builder: (context, state) {
                  if (state is LogLoading) {
                    return _buildLoading(colorScheme);
                  }
                  if (state is LogError) {
                    return _buildError(context, state.message, colorScheme);
                  }
                  if (state is MealsSummaryLoaded) {
                    return _buildContent(context, state.summary, colorScheme);
                  }
                  // LogInitial, or a state left over from some other
                  // LogBloc action (e.g. a meal scan) if this Bloc instance
                  // happens to be shared elsewhere — render nothing rather
                  // than guessing what to show.
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(color: colorScheme.primary),
    );
  }

  Widget _buildError(
      BuildContext context, String message, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 36),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextButton(
              // CHANGED: retry now re-requests the currently selected
              // date instead of always implicitly re-requesting "today".
              onPressed: () => context.read<LogBloc>().add(
                  LoadMealsSummaryEvent(date: _apiDateString(_selectedDate))),
              child: Text('home.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, MealsSummaryResult summary, ColorScheme colorScheme) {
    final bars = _buildBars(context, summary);
    final legends = _buildLegends(context, summary);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      .map((bar) =>
                      _AnimatedBar(bar: bar, progress: _animation.value))
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
                    color: colorScheme.outlineVariant,
                    height: 1,
                    thickness: 1,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── Animated Bar ─────────────────────────────────────────────────────────────
class _AnimatedBar extends StatelessWidget {
  final _BarData bar;
  final double progress;

  const _AnimatedBar({
    required this.bar,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const totalHeight = 300.0;
    const maxVisualHeight = 240.0;

    // CHANGED: this used to normalize each bar's height relative to the
    // other bars in the list (min/max across the set), defaulting to full
    // height whenever all bars were equal — which is exactly what happens
    // when every macro is 0% on a day with no logged meals. That made 0%
    // render as a nearly-full bar. Height is now just this bar's own
    // percent of the ceiling, with no cross-bar normalization, so 0%
    // actually renders as ~0 height.
    final clampedPercent = bar.percent.clamp(0.0, 1.0);
    final targetHeight = maxVisualHeight * clampedPercent;
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
          // CHANGED: was `bottom: barHeight - 45`, which goes negative (and
          // gets clipped by the Stack) once the bar itself is short — the
          // exact case that's now common with real 0%/low% data. Clamped
          // so the badge always has room to sit above the value text
          // instead of disappearing off the bottom edge.
          Positioned(
            bottom: (barHeight - 45).clamp(30.0, double.infinity),
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