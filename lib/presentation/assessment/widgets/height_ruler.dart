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
  late double height;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    // Use initial value if provided, otherwise use default
    height = widget.initialValue ?? (widget.unit == 'cm' ? 170.0 : 5.7);

    // Set initial scroll position
    double maxValue = widget.unit == 'cm' ? 250.0 : 8.0;
    scrollController = ScrollController(
      initialScrollOffset: (maxValue - height) * 40,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine min, max, and display values based on unit
    double minValue = widget.unit == 'cm' ? 100.0 : 4.0;
    double maxValue = widget.unit == 'cm' ? 250.0 : 8.0;
    int itemCount = ((maxValue - minValue) * (widget.unit == 'cm' ? 1 : 10) + 1).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Scale ruler (vertical)
        Container(
          width: 120,
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Scrollable ruler
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  setState(() {
                    double screenHeight = 400;
                    double offset = scrollController.offset + screenHeight / 2 - 20;

                    if (widget.unit == 'cm') {
                      height = maxValue - (offset / 40);
                    } else {
                      // For feet: each 0.1 increment represents 1 inch
                      double totalInches = (offset / 40);
                      height = maxValue - (totalInches / 10);
                    }
                  });

                  widget.onChanged(height);
                  return true;
                },
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    double value;
                    bool isMajor;
                    String label;

                    if (widget.unit == 'cm') {
                      value = maxValue - index;
                      isMajor = value % 10 == 0;
                      label = '${value.toInt()}';
                    } else {
                      // For feet: display every 3 inches (0.3 on the scale)
                      double inchValue = maxValue - (index / 10.0);
                      int feet = inchValue.floor();
                      int inches = ((inchValue - feet) * 10).round();
                      isMajor = inches % 3 == 0;
                      label = '$feet\'${inches}"';
                      value = inchValue;
                    }

                    return Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: isMajor ? 4 : 2,
                            width: isMajor ? 56 : 24,
                            color: Colors.grey[400],
                          ),
                          if (isMajor)
                            Padding(
                              padding: EdgeInsets.only(left: 8),
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

              // Center indicator
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

        SizedBox(width: 24),

        // Height display
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.unit == 'cm'
                  ? '${height.toInt()}'
                  : '${(height ~/ 1)}\' ${((height % 1) * 10).toInt()}"',
              style: TextStyle(
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