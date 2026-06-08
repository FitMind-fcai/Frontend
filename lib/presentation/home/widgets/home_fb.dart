import 'package:fitmind/presentation/log/screens/log_choice_screen.dart';
import 'package:fitmind/presentation/plan/screens/plan_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class Home_fb extends StatelessWidget {
  const Home_fb({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryColor.withOpacity(0.5),
                blurRadius: 15,

                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: AppConstants.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20),
            ),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LogEntryPage()),
                );
              },
            child: const Icon(Icons.add, color: Colors.white, size: 35),
          ),
        ),
      ),
    );
  }
}