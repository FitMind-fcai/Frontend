import 'package:fitmind/presentation/home/screens/calorie_home_screen.dart';
import 'package:fitmind/presentation/home/screens/score_home_screen.dart';
import 'package:fitmind/presentation/home/screens/steps_home_screen.dart';
import 'package:fitmind/presentation/home/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/manager/auth_bloc.dart';
import '../../authentication/widgets/common_button.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/bnb_custom_painter.dart';
import '../widgets/fitness_metric_card.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_fb.dart';
import '../widgets/meal_card.dart';
import '../widgets/workout_highlight_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomePage(),
    const Center(child: Text('Workout')),
    const Center(child: Text('Nutrition')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[100],
      body: _pages[_selectedIndex],
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

// ── Home page content ─────────────────────────────────────────────────────────
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeAppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppConstants.verticalSpaceM,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fitness Metrics',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: AppConstants.fontRegular),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All',
                          style: TextStyle(
                              color: AppConstants.primaryColor,
                              fontFamily: AppConstants.fontRegular)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Horizontal scrolling metric cards
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>ScorePage() ),
                        ),

                        child: const MetricCard(
                          title: 'Score',
                          value: '88%',
                          color: AppConstants.primaryColor,
                          icon: Icons.add,
                          graphImage:
                              AssetImage('assets/images/bar_chart_orange.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StepsTakenPage()),
                        ),

                        child: const MetricCard(
                          title: 'Steps taken',
                          value: '12,540',
                          color: Colors.blue,
                          icon: Icons.directions_run,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CalorieStatsPage()),
                        ),
                        child: const MetricCard(
                          title: 'Calories',
                          value: '1,240',
                          color: Colors.grey,
                          icon: Icons.local_fire_department,
                          fallbackIcon: Icons.local_fire_department_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                AppConstants.verticalSpaceL,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Workouts',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert)),
                  ],
                ),
                const WorkoutHighlightCard(),

                const SizedBox(height: 25),

// --- Diet & Nutrition Section ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Diet & Nutrition',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                        onPressed: () {},
                        child: const Text('See All',
                            style: TextStyle(color: Colors.orange))),
                  ],
                ),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: [
                      MealCard(
                          title: 'Salad & Egg', kcal: '548kcal', time: '20min'),
                      MealCard(
                          title: 'Salad & Egg', kcal: '548kcal', time: '20min'),
                    ],
                  ),
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
  }
}
