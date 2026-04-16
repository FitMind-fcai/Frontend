import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_constants.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Fitmind Score',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                AppConstants.verticalSpaceXL,

                /// RADAR CHART (Static - No Changes)
                SizedBox(
                  height: 400,
                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      tickCount: 5,
                      ticksTextStyle: const TextStyle(
                        color: Colors.transparent,
                      ),
                      gridBorderData: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      titleTextStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: AppConstants.fontRegular,
                        fontWeight: FontWeight.w800,
                      ),
                      getTitle: (index, angle) {
                        const titles = [
                          "Calorie",
                          "BMI",
                          "BPM",
                          "Hydration",
                          "Sleep",
                          "Steps",
                        ];
                        return RadarChartTitle(text: titles[index]);
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: Colors.black.withOpacity(0.08),
                          borderColor: Colors.black,
                          borderWidth: 2.5,
                          entryRadius: 0,
                          dataEntries: const [
                            RadarEntry(value: 85),
                            RadarEntry(value: 70),
                            RadarEntry(value: 50),
                            RadarEntry(value: 60),
                            RadarEntry(value: 75),
                            RadarEntry(value: 80),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.orange.withOpacity(0.08),
                          borderColor: AppConstants.primaryColor,
                          borderWidth: 2.5,
                          entryRadius: 0,
                          dataEntries: const [
                            RadarEntry(value: 60),
                            RadarEntry(value: 30),
                            RadarEntry(value: 80),
                            RadarEntry(value: 95),
                            RadarEntry(value: 85),
                            RadarEntry(value: 70),
                          ],
                        ),
                        RadarDataSet(
                          fillColor: Colors.blue.withOpacity(0.08),
                          borderColor: Colors.blue,
                          borderWidth: 2.5,
                          entryRadius: 0,
                          dataEntries: const [
                            RadarEntry(value: 55),
                            RadarEntry(value: 45),
                            RadarEntry(value: 35),
                            RadarEntry(value: 30),
                            RadarEntry(value: 40),
                            RadarEntry(value: 50),
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
                      style: const TextStyle(
                        fontSize: 96,
                        fontWeight: FontWeight.w900,
                        fontFamily: AppConstants.fontRegular,
                        height: 1,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                Text(
                  "You are a healthy individual.",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppConstants.fontRegular,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 28),

                /// LEGEND
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LegendItem(Colors.orange, "STRENGTH"),
                      LegendItem(Colors.black, "AGILITY"),
                      LegendItem(Colors.blue, "ENDURANCE"),
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
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
      ],
    );
  }
}