import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class HeightPicker extends StatefulWidget {
  final Function(double) onChanged;
  final String unit;
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
  late double heightCm;
  late FixedExtentScrollController _controller;

  static const double minCm = 100;
  static const double maxCm = 250;
  static const double itemHeight = 40;

  @override
  void initState() {
    super.initState();
    heightCm = widget.unit == 'ft' && widget.initialValue != null
        ? widget.initialValue! * 30.48
        : widget.initialValue ?? 170.0;

    _controller = FixedExtentScrollController(initialItem: (heightCm - minCm).toInt());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = (maxCm - minCm + 1).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 400,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: itemHeight,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    heightCm = minCm + index.toDouble();
                  });
                  widget.onChanged(heightCm);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    double cmValue = minCm + index.toDouble();
                    bool isMajor = cmValue % 5 == 0;

                    String label;
                    if (widget.unit == 'ft') {
                      double totalInches = cmValue / 2.54;
                      int ft = totalInches ~/ 12;
                      int inch = (totalInches % 12).round();
                      if (inch == 12) {
                        ft += 1;
                        inch = 0;
                      }
                      label = "$ft' $inch\"";
                    } else {
                      label = cmValue.toInt().toString();
                    }

                    return SizedBox(
                      height: itemHeight,
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
                  childCount: itemCount,
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

        const SizedBox(width: 24),
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
}
