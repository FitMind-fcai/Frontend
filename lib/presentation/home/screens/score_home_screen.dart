import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_constants.dart';
import 'package:easy_localization/easy_localization.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
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
                          'score.radar_calorie'.tr(),
                          'score.radar_bmi'.tr(),
                          'score.radar_bpm'.tr(),
                          'score.radar_hydration'.tr(),
                          'score.radar_sleep'.tr(),
                          'score.radar_steps'.tr(),
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
                          dataEntries: const [
                            RadarEntry(value: 85), RadarEntry(value: 70),
                            RadarEntry(value: 50), RadarEntry(value: 60),
                            RadarEntry(value: 75), RadarEntry(value: 80),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.orange.withOpacity(0.08),
                          borderColor: AppConstants.primaryColor,
                          borderWidth: 2.5,
                          entryRadius: 0,
                          dataEntries: const [
                            RadarEntry(value: 60), RadarEntry(value: 30),
                            RadarEntry(value: 80), RadarEntry(value: 95),
                            RadarEntry(value: 85), RadarEntry(value: 70),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.blue.withOpacity(0.08),
                          borderColor: Colors.blue,
                          borderWidth: 2.5,
                          entryRadius: 0,
                          dataEntries: const [
                            RadarEntry(value: 55), RadarEntry(value: 45),
                            RadarEntry(value: 35), RadarEntry(value: 30),
                            RadarEntry(value: 40), RadarEntry(value: 50),
                          ],
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
                  tween: Tween<double>(begin: 0, end: 88),
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