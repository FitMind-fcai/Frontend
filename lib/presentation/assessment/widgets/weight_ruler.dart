import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class WeightPicker extends StatefulWidget {
  final Function(double) onChanged;
  final double? initialValue;
  final String unit; // 'kg' or 'lbs'

  const WeightPicker({
    Key? key,
    required this.onChanged,
    this.initialValue,
    required this.unit,
  }) : super(key: key);

  @override
  _WeightPickerState createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late double weight; // always stored internally in KG
  late ScrollController scrollController;

  double get displayWeight {
    if (widget.unit == 'lbs') return weight * 2.20462;
    return weight;
  }


  @override
  void initState() {
    super.initState();
    weight = widget.initialValue ?? 70.0; // default 70kg
    scrollController = ScrollController(
      initialScrollOffset: (weight - 10) * 40,
    );
  }

  @override
  void didUpdateWidget(covariant WeightPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Do NOT change scroll offset on unit change.
    // Only rebuild to display converted weight.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Weight display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${displayWeight.toInt()}',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1,
              ),
            ),
            Text(
              widget.unit,
              style: TextStyle(
                fontSize: 36,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Scale ruler
        SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Container(
                  width: 16,
                  height: 116,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  setState(() {
                    double screenWidth = MediaQuery.of(context).size.width;
                    double offset = scrollController.offset + screenWidth / 2 - 20;
                    double value = 10 + (offset / 40);
                    weight = value; // always store kg internally
                  });
                  widget.onChanged(weight);
                  return true;
                },
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 291, // 10kg → 300kg
                  itemBuilder: (context, index) {
                    double kgValue = 10 + index.toDouble();

                    // Determine major tick based on unit
                    bool isMajor;
                    String labelText;

                    if (widget.unit == 'kg') {
                      isMajor = kgValue % 5 == 0;
                      labelText = '${kgValue.toInt()}';
                    } else {
                      // For lbs, show major ticks at multiples of 10 lbs
                      double lbsValue = kgValue * 2.20462;
                      isMajor = (lbsValue / 10).round() * 10 == lbsValue.round();
                      labelText = '${lbsValue.toInt()}';
                    }

                    return Container(
                      width: 40, // same spacing as kg
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isMajor)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                labelText,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppConstants.fontRegular,
                                ),
                              ),
                            ),
                          Container(
                            width: isMajor ? 4 : 2,
                            height: isMajor ? 56 : 24,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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