import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/plan/workout_plan_result.dart';

class WorkoutDayExercisesScreen extends StatelessWidget {
  final WorkoutDay day;
  final DateTime? date;

  const WorkoutDayExercisesScreen({super.key, required this.day, this.date});

  String _formatDate(DateTime d) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const weekdays = [
      '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return '${weekdays[d.weekday]}, ${d.day} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: light mode keeps every original literal color exactly as
    // given — isDark only branches where a value would actually break
    // against a dark background.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // CHANGED: was always const Color(0xFFF5F5F5).
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        // CHANGED: was Colors.white.
                        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          // CHANGED: was const Color(0xFFEAEAEA).
                          color: isDark ? colorScheme.outlineVariant : const Color(0xFFEAEAEA),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        // CHANGED: was const Color(0xFF1A1A2E).
                        color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day.dayName.isNotEmpty
                              ? day.dayName
                              : 'Day ${day.dayNumber}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            // CHANGED: was const Color(0xFF1A1A2E).
                            color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                            letterSpacing: -0.5,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        // NOTE: mid-tone gray, already reads fine on both
                        // light and dark — left untouched.
                        if (date != null)
                          Text(
                            _formatDate(date!),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Summary strip
            // NOTE: fixed dark-navy card regardless of theme — same
            // reasoning as the meals screen's summary strip. Its tone is
            // close enough to the elevated dark surface used elsewhere
            // that it still reads as a raised card on a dark page, so
            // nothing in this block (including white54 labels and the
            // accent value colors) needs to change.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _SummaryItem(
                      label: 'Exercises',
                      value: '${day.exercises.length}',
                      color: AppConstants.primaryColor,
                    ),
                    _divider(),
                    _SummaryItem(
                      label: 'Focus',
                      value: day.focus?.isNotEmpty == true
                          ? day.focus!
                          : '—',
                      color: const Color(0xFF3B82F6),
                    ),
                    _divider(),
                    _SummaryItem(
                      label: 'Sets',
                      value: '${day.exercises.fold<int>(0, (s, e) => s + (e.sets ?? 0))}',
                      color: const Color(0xFF10B981),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Exercise list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                itemCount: day.exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _ExerciseCard(exercise: day.exercises[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 30,
    color: Colors.white.withOpacity(0.1),
  );
}

class _SummaryItem extends StatelessWidget {
  final String label, value;
  final Color color;

  const _SummaryItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white54,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Exercise Card (expandable)
// ─────────────────────────────────────────────────────────────────────────────

class _ExerciseCard extends StatefulWidget {
  final Exercise exercise;

  const _ExerciseCard({required this.exercise});

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  Color get _muscleColor {
    switch ((widget.exercise.muscleGroup ?? '').toLowerCase()) {
      case 'chest':
        return const Color(0xFFF97316);
      case 'back':
        return const Color(0xFF3B82F6);
      case 'legs':
        return const Color(0xFF10B981);
      case 'shoulders':
        return const Color(0xFF8B5CF6);
      case 'arms':
      case 'biceps':
      case 'triceps':
        return const Color(0xFFF59E0B);
      case 'core':
      case 'abs':
        return const Color(0xFFEF4444);
      default:
        return AppConstants.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final ex = widget.exercise;

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        decoration: BoxDecoration(
          // CHANGED: was Colors.white.
          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // CHANGED: dropped entirely in dark mode — same smudge issue
              // as every other card shadow fixed so far.
              color: isDark ? Colors.transparent : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Collapsed row
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // NOTE: _muscleColor badge/icon — brand accent, untouched.
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: _muscleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (ex.sets != null) ...[
                            Text(
                              '${ex.sets}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _muscleColor,
                                fontFamily: AppConstants.fontRegular,
                                height: 1,
                              ),
                            ),
                            Text(
                              'sets',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: _muscleColor.withOpacity(0.6),
                                fontFamily: AppConstants.fontRegular,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ] else
                            Icon(Icons.fitness_center_rounded,
                                color: _muscleColor, size: 22),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ex.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            // CHANGED: was const Color(0xFF1A1A2E).
                            color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // NOTE: _muscleColor chip — brand accent, untouched.
                        if (ex.muscleGroup != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: _muscleColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ex.muscleGroup!,
                              style: TextStyle(
                                fontSize: 11,
                                color: _muscleColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.fontRegular,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // NOTE: light gray chevron — already reads fine on a
                  // dark card too, untouched.
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _expanded ? 0.5 : 0,
                    child: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFD1D5DB), size: 24),
                  ),
                ],
              ),
            ),
            // Stats pills row
            // NOTE: all _StatTag colors are brand/accent tints — untouched.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  if (ex.sets != null)
                    _StatTag(
                        label: '${ex.sets}',
                        sub: 'Sets',
                        color: _muscleColor),
                  if (ex.sets != null) const SizedBox(width: 6),
                  if (ex.reps != null)
                    _StatTag(
                        label: '${ex.reps}',
                        sub: 'Reps',
                        color: const Color(0xFF3B82F6)),
                  if (ex.reps != null) const SizedBox(width: 6),
                  if (ex.durationSeconds != null)
                    _StatTag(
                        label: '${ex.durationSeconds}s',
                        sub: 'Duration',
                        color: const Color(0xFF10B981)),
                  if (ex.durationSeconds != null) const SizedBox(width: 6),
                  if (ex.restSeconds != null)
                    _StatTag(
                        label: '${ex.restSeconds}s',
                        sub: 'Rest',
                        color: const Color(0xFF8B5CF6)),
                ],
              ),
            ),
            // Expanded details
            FadeTransition(
              opacity: _fade,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _expanded
                    ? _ExerciseDetails(exercise: ex)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTag extends StatelessWidget {
  final String label, sub;
  final Color color;

  const _StatTag(
      {required this.label, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          Text(
            sub,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.7),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseDetails extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseDetails({required this.exercise});

  // CHANGED: now takes isDark/colorScheme so the heading can avoid the
  // navy-on-dark problem — same fix as every other section title so far.
  Widget _sectionTitle(String text, bool isDark, ColorScheme colorScheme) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: isDark ? colorScheme.onSurface : const Color(0xFF1A1A2E),
      fontFamily: AppConstants.fontRegular,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final ex = exercise;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CHANGED: was const Divider(color: Color(0xFFF3F4F6)) — that's
          // a deliberately near-invisible hairline on a white card, but
          // would glare against a dark one. outlineVariant keeps the same
          // "barely there" effect on dark.
          Divider(
            color: isDark ? colorScheme.outlineVariant : const Color(0xFFF3F4F6),
            thickness: 1,
          ),
          const SizedBox(height: 10),
          if (ex.description != null && ex.description!.isNotEmpty) ...[
            _sectionTitle('Description', isDark, colorScheme),
            const SizedBox(height: 6),
            Text(
              ex.description!,
              style: TextStyle(
                fontSize: 13,
                // CHANGED: was const Color(0xFF6B7280) — too low-contrast
                // against a dark card, swapped to onSurfaceVariant.
                color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                height: 1.5,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (ex.equipment != null && ex.equipment!.isNotEmpty) ...[
            _sectionTitle('Equipment', isDark, colorScheme),
            const SizedBox(height: 6),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                // CHANGED: was const Color(0xFFF9FAFB) — same near-white
                // tile issue fixed on the ingredient row in the meals
                // screen. A faint white overlay keeps the same "one step
                // lighter than the card" effect on dark.
                color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  // CHANGED: was const Color(0xFFE5E7EB).
                  color: isDark ? colorScheme.outlineVariant : const Color(0xFFE5E7EB),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fitness_center_rounded,
                    size: 14,
                    // CHANGED: was const Color(0xFF6B7280).
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ex.equipment!,
                    style: TextStyle(
                      fontSize: 13,
                      // CHANGED: was const Color(0xFF6B7280).
                      color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF6B7280),
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (ex.difficulty != null && ex.difficulty!.isNotEmpty) ...[
            _sectionTitle('Difficulty', isDark, colorScheme),
            const SizedBox(height: 6),
            _DifficultyBadge(level: ex.difficulty!),
          ],
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String level;

  const _DifficultyBadge({required this.level});

  // NOTE: every branch here — including the 0xFF6B7280 fallback for an
  // unrecognized level string — is a mid-to-vivid tone used as a tinted
  // background/border/text combo, the same pattern left untouched
  // elsewhere (e.g. the workout day card's exercise-count chip text).
  // These already have adequate contrast against a dark card, so this
  // widget doesn't need any theme-aware changes.
  Color get _color {
    switch (level.toLowerCase()) {
      case 'easy':
      case 'beginner':
        return const Color(0xFF10B981);
      case 'medium':
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'hard':
      case 'advanced':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        level,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color,
          fontFamily: AppConstants.fontRegular,
        ),
      ),
    );
  }
}