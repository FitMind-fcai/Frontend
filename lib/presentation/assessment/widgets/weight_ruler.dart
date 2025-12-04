import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class WeightPicker extends StatefulWidget {
  final Function(double) onChanged;
  final double? initialValue;

  const WeightPicker({
    Key? key,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _WeightPickerState createState() => _WeightPickerState();
}

class _WeightPickerState extends State<WeightPicker> {
  late double weight;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    weight = widget.initialValue ?? 128.0;
    scrollController = ScrollController(
      initialScrollOffset: (weight - 10) * 40,
    );
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
              '${weight.toInt()}',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1,
              ),
            ),
            Text(
              'kg',
              style: TextStyle(
                fontSize: 36,
                fontFamily: AppConstants.fontRegular,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        SizedBox(height: 24),

        // Scale ruler
        Container(
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Scrollable ruler
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  setState(() {
                    double screenWidth = MediaQuery.of(context).size.width;
                    double offset = scrollController.offset + screenWidth / 2 - 20;
                    weight = 10 + (offset / 40);
                  });

                  widget.onChanged(weight);
                  return true;
                },
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 291, // 10kg to 300kg
                  itemBuilder: (context, index) {
                    int value = 10 + index;
                    bool isMajor = value % 3 == 0;

                    return Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (isMajor)
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                '$value',
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

              // Center indicator
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