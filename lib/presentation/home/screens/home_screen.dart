// lib/presentation/home/screens/home_screen.dart

import 'package:fitmind/presentation/home/screens/calorie_home_screen.dart';
import 'package:fitmind/presentation/home/screens/score_home_screen.dart';
import 'package:fitmind/presentation/home/screens/steps_home_screen.dart';
import 'package:fitmind/presentation/home/widgets/home_app_bar.dart';
import 'package:fitmind/presentation/plan/screens/my_plans/todays_workout_screen.dart';

import 'package:fitmind/presentation/profile/screens/profile_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/home/next_meal_response.dart';
import '../../log/screens/misc_log/hydration_log_screen.dart';
import '../../log/screens/misc_log/sleep_log_screen.dart';
import '../../log/screens/misc_log/weight_log_screen.dart';
import '../../plan/screens/my_plans/todays_meals_screen.dart';
import '../manager/home_bloc.dart';
import '../widgets/fitness_metric_card.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/meal_card.dart';
import '../widgets/workout_highlight_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _HomePage(),
      TodayWorkoutTab(),
      TodayMealsTab(),
      ProfileScreen(),
    ];
    context.read<HomeBloc>().add(const LoadHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
      backgroundColor: isDark ? colorScheme.surface : Colors.grey[100],
      body: _pages[_selectedIndex],
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 0 && _selectedIndex != 0) {
            context.read<HomeBloc>().add(const GetScoreEvent());
            context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());
          }
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

// ── Home page content ─────────────────────────────────────────────────────────
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppBar( score: state is HomeLoaded ? state.score?.overallScore : null,)
              ,

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppConstants.verticalSpaceM,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home.fitness_metrics'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: AppConstants.fontRegular,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ── Metric cards ────────────────────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ScorePage(),
                                ),
                              );
                              if (context.mounted) {
                                context.read<HomeBloc>().add(const GetScoreEvent());
                                context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());
                              }
                            },
                            child: MetricCard(
                              title: 'home.metric_score'.tr(),
                              value: state is HomeLoaded && state.score != null
                                  ? '${state.score!.overallScore.toInt()}%'
                                  : '--',
                              color: AppConstants.primaryColor,
                              icon: Icons.add,
                              graphImage: const AssetImage(
                                  'assets/images/bar_chart_orange.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const StepsTakenPage()),
                              );
                              if (context.mounted) {
                                context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());
                              }
                            },
                            child: MetricCard(
                              title: 'home.metric_steps'.tr(),
                              value: state is HomeLoaded && state.steps != null
                                  ? state.steps!.toString().replaceAllMapped(
                                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')
                                  : '--',
                              color: Colors.blue,
                              icon: Icons.directions_run,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const CalorieStatsPage()),
                              );
                              if (context.mounted) {
                                context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());
                              }
                            },
                            child: MetricCard(
                              title: 'home.metric_calories'.tr(),
                              value: state is HomeLoaded && state.calories != null
                                  ? '${state.calories}'
                                  : '--',                              // CHANGED: was a flat Colors.grey, which has no
                              // dark-mode equivalent. outline reads as a
                              // neutral accent in both themes.
                              color: Theme.of(context).colorScheme.outline,
                              icon: Icons.local_fire_department,
                              fallbackIcon:
                                  Icons.local_fire_department_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppConstants.verticalSpaceL,

                    // ── Workouts section ────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home.workouts_section'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (state is HomeLoading)
                      const _ShimmerBox(height: 240, radius: 25)
                    else if (state is HomeLoaded)
                      (state.workout?.hasPlan ?? false)
                          ? WorkoutHighlightCard(workout: state.workout)
                          : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          state.workout?.message.isNotEmpty == true
                              ? state.workout!.message
                              : 'workout_card.generate_plan'.tr(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    else if (state is HomeError)
                        _ErrorTile(message: state.message),

                    const SizedBox(height: 25),

                    // ── Diet & Nutrition section ────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'home.diet_nutrition_section'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 12,),

                    if (state is HomeLoading)
                      const _ShimmerBox(height: 240, radius: 25)
                    else if (state is HomeLoaded)
                      _MealCardRow(nextMeal: state.nextMeal)
                    else if (state is HomeError)
                      _ErrorTile(message: state.message),

                    const SizedBox(height: 25),

                    // ── Miscellaneous Logs section ──────────────────────────
                    Text(
                      'home.misc_logs_section'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _MiscLogCard(
                            label: 'home.log_hydration'.tr(),
                            icon: Icons.water_drop_outlined,
                            color: const Color(0xFF29B6F6),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const HydrationLogPage()),
                              );
                              if (context.mounted) {
                                context.read<HomeBloc>().add(const GetScoreEvent());
                                context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());

                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MiscLogCard(
                            label: 'home.log_sleep'.tr(),
                            icon: Icons.bedtime_outlined,
                            color: const Color(0xFF7E57C2),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SleepLogPage()),
                              );
                              if (context.mounted) {
                                context.read<HomeBloc>().add(const GetScoreEvent());
                                context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());

                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MiscLogCard(
                            label: 'home.log_weight'.tr(),
                            icon: Icons.monitor_weight_outlined,
                            color: const Color(0xFF26A69A),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const WeightLogPage()),
                              );
                              if (context.mounted) {
                                context.read<HomeBloc>().add(const GetScoreEvent());
                                context.read<HomeBloc>().add(const RefreshLiveMetricsEvent());

                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppConstants.verticalSpaceXXL,
              AppConstants.verticalSpaceXXL,
              AppConstants.verticalSpaceXXL,
              AppConstants.verticalSpaceXXL,

            ],
          ),
        );
      },
    );
  }
}

// ── Miscellaneous log card ────────────────────────────────────────────────────
class _MiscLogCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MiscLogCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          // CHANGED: was Colors.white — now follows the theme's card surface.
          color: isDark?Colors.black45:colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(

              color:
                  isDark ? Colors.transparent : Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                // CHANGED: was Colors.black87 — now follows the theme's
                // primary text color (light text on dark surfaces).
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'home.add_log_chip'.tr(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Meal card row built from real API data ────────────────────────────────────
class _MealCardRow extends StatelessWidget {
  final NextMealResponse? nextMeal;

  const _MealCardRow({required this.nextMeal});

  @override
  Widget build(BuildContext context) {
    final meal = nextMeal?.recommendedMeal;
    if (meal == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'home.no_meal_plan'.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final totalTime = meal.prepTimeMinutes + meal.cookTimeMinutes;

    return MealCard(
            title: meal.mealName,
            kcal: '${meal.calories.toInt()} ${'meal_card.kcal'.tr()}',
            time: '$totalTime ${'meal_card.min'.tr()}',
            proteinG: meal.proteinG,
            fatsG: meal.fatsG,
          );

  }
}

// ── Simple shimmer placeholder ────────────────────────────────────────────────
class _ShimmerBox extends StatelessWidget {
  final double height;
  final double radius;

  const _ShimmerBox({required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        // CHANGED: was Colors.grey[200] — surfaceContainerHighest is the
        // Material 3 token meant for exactly this "elevated neutral surface"
        // use case, and it's defined for both brightness modes.
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Inline error tile ─────────────────────────────────────────────────────────
class _ErrorTile extends StatelessWidget {
  final String message;

  const _ErrorTile({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // CHANGED: was Colors.red[50], a pastel that washes out on dark
        // backgrounds. errorContainer is Material 3's purpose-built token
        // for this and adapts correctly.
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<HomeBloc>().add(const LoadHomeEvent()),
            child: Text('home.retry'.tr()),
          ),
        ],
      ),
    );
  }
}
