import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class HeightPicker extends StatefulWidget {
  final Function(double) onChanged;
  final String unit; // 'cm' or 'ft'
  final double? initialValue;

  const HeightPicker({
    Key? key,
    required this.onChanged,
    this.unit = 'cm',
    this.initialValue,
  }) : super(key: key);

  @override
  _HeightPickerState createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  // Internally ALWAYS store height in cm
  late double heightCm;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    if (widget.unit == 'ft' && widget.initialValue != null) {
      // user gives ft, convert to cm
      heightCm = widget.initialValue! * 30.48;
    } else {
      heightCm = widget.initialValue ?? 170.0;
    }

    scrollController = ScrollController(
      initialScrollOffset: (heightCm - 100) * 40,
    );
  }

  @override
  void didUpdateWidget(covariant HeightPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Do NOT change scroll offset on unit change.
  }

  @override
  Widget build(BuildContext context) {
    const double minCm = 100;
    const double maxCm = 250;
    int itemCount = (maxCm - minCm + 1).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ---- RULER AREA ----
        SizedBox(
          width: 120,
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (mounted) {
                    setState(() {
                      double offset = scrollController.offset + 400 / 2 - 20;
                      double cmValue = minCm + (offset / 40);

                      cmValue = cmValue.clamp(minCm, maxCm);
                      heightCm = cmValue;
                    });

                    widget.onChanged(heightCm);
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: itemCount,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    double cmValue = minCm + index.toDouble();
                    bool isMajor;
                    if (widget.unit == 'ft') {
                      isMajor = cmValue % 5 == 0;
                    } else {
                      isMajor = cmValue % 5 == 0;
                    }

                    String label;
                    if (widget.unit == 'ft') {
                      double totalInches = cmValue / 2.54;
                      int ft = totalInches ~/ 12;
                      int inch = (totalInches % 12).round();

                      // Fix 12-inch rounding bug
                      if (inch == 12) {
                        ft += 1;
                        inch = 0;
                      }

                      label = "$ft' $inch\"";
                    } else {
                      label = cmValue.toInt().toString();
                    }

                    return SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            height: isMajor ? 4 : 2,
                            width: isMajor ? 56 : 24,
                            color: Colors.grey[400],
                          ),
                          if (isMajor)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ---- CENTER INDICATOR ----
              Positioned(
                child: Container(
                  height: 16,
                  width: 116,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // ---- DISPLAY AREA ----
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.unit == 'cm'
                  ? heightCm.toInt().toString()
                  : (() {
                double totalInches = heightCm / 2.54;
                int ft = totalInches ~/ 12;
                int inch = (totalInches % 12).round();

                // fix rounding overflow
                if (inch == 12) {
                  ft += 1;
                  inch = 0;
                }

                return "$ft' $inch\"";
              })(),
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1,
              ),
            ),
            if (widget.unit == 'cm')
              Text(
                'cm',
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: AppConstants.fontRegular,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}