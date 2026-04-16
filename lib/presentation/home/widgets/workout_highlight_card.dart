import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class WorkoutHighlightCard extends StatelessWidget {
  const WorkoutHighlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87, // Placeholder for your image
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage('assets/images/workout_card.png'), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text('25min  •  ', style: TextStyle(color: Colors.white70,fontWeight: AppConstants.extraBold,fontFamily: AppConstants.fontRegular)),
                  Icon(Icons.local_fire_department, color: Colors.white70, size: 16),
                  SizedBox(width: 4),
                  Text('412kcal', style: TextStyle(color: Colors.white70,fontFamily: AppConstants.fontRegular)),
                ],
              ),
              const Spacer(),
              const Text(
                'Upper Strength 2',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontRegular),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Intense', style: TextStyle(color: Colors.white, fontSize: 12,fontWeight: AppConstants.extraBold,fontFamily: AppConstants.fontRegular)),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}