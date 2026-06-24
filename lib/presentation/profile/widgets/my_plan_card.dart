import 'package:easy_localization/easy_localization.dart';
import 'package:fitmind/presentation/plan/screens/my_plans/my_plans_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class MyPlanCard extends StatelessWidget {
  const MyPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar'; // Check if the current locale is Arabic (RTL)
    return Container(
      width: double.infinity,
      height: 240,
      padding: const EdgeInsets.all(16),
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
              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'my_plans.title'.tr(),
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,fontFamily: AppConstants.fontRegular),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MyPlansScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: AppConstants.primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Transform.flip(
                          flipX: isRtl,
                          child: ImageIcon(
                            AssetImage("assets/images/Monotone arrow right.png"),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

            ],
          ),

        ],
      ),
    );
  }
}