import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // CHANGED: added
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../manager/home_bloc.dart'; // CHANGED: added

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'score.title'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDark ? colorScheme.surface : Colors.white,
      // CHANGED: whole body now wrapped in BlocBuilder to read live score data.
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final score = state is HomeLoaded ? state.score : null;

            if (score == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'score.no_score'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () =>
                            context.read<HomeBloc>().add(const GetScoreEvent()),
                        child: Text('home.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  children: [
                    AppConstants.verticalSpaceXL,

                    /// RADAR CHART
                    SizedBox(
                      height: 400,
                      child: RadarChart(
                        RadarChartData(
                          radarShape: RadarShape.polygon,
                          tickCount: 5,
                          ticksTextStyle: const TextStyle(color: Colors.transparent),
                          gridBorderData: BorderSide(
                            color: isDark ? Colors.white24 : Colors.grey,
                            width: 1,
                          ),
                          titleTextStyle: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey,
                            fontFamily: AppConstants.fontRegular,
                            fontWeight: FontWeight.w800,
                          ),
                          getTitle: (index, angle) {
                            final titles = [
                              'score.radar_nutrition'.tr(),
                              'score.radar_strength'.tr(),
                              'score.radar_agility'.tr(),
                              'score.radar_hydration'.tr(),
                              'score.radar_sleep'.tr(),
                              'score.radar_endurance'.tr(),
                            ];
                            return RadarChartTitle(text: titles[index]);
                          },
                          dataSets: [
                            RadarDataSet(
                              fillColor: isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : Colors.black.withOpacity(0.08),
                              borderColor: isDark ? Colors.white70 : Colors.black,
                              borderWidth: 2.5,
                              entryRadius: 0,
                              // CHANGED: was const [85,70,50,60,75,80]
                              dataEntries: score.agilityRadarEntries
                                  .map((v) => RadarEntry(value: v))
                                  .toList(),
                            ),
                            RadarDataSet(
                              fillColor: Colors.orange.withOpacity(0.08),
                              borderColor: AppConstants.primaryColor,
                              borderWidth: 2.5,
                              entryRadius: 0,
                              // CHANGED: was const [60,30,80,95,85,70]
                              dataEntries: score.strengthRadarEntries
                                  .map((v) => RadarEntry(value: v))
                                  .toList(),
                            ),
                            RadarDataSet(
                              fillColor: Colors.blue.withOpacity(0.08),
                              borderColor: Colors.blue,
                              borderWidth: 2.5,
                              entryRadius: 0,
                              // CHANGED: was const [55,45,35,30,40,50]
                              dataEntries: score.enduranceRadarEntries
                                  .map((v) => RadarEntry(value: v))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    AppConstants.verticalSpaceL,
                    AppConstants.verticalSpaceL,
                    AppConstants.verticalSpaceL,

                    /// SCORE (Animated Ticker)
                    TweenAnimationBuilder<double>(
                      // CHANGED: was end: 88
                      tween: Tween<double>(begin: 0, end: score.overallScore),
                      duration: const Duration(seconds: 2),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, child) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 96,
                            fontWeight: FontWeight.w900,
                            fontFamily: AppConstants.fontRegular,
                            height: 1,
                            color: isDark ? Colors.white : null,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'score.summary_healthy'.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppConstants.fontRegular,
                        color: isDark ? Colors.white54 : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// LEGEND
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LegendItem(Colors.orange, 'score.legend_strength'.tr()),
                          LegendItem(isDark ? Colors.white70 : Colors.black, 'score.legend_agility'.tr()),
                          LegendItem(Colors.blue, 'score.legend_endurance'.tr()),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String title;

  const LegendItem(this.color, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black87,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
      ],
    );
  }
}