import 'package:fitmind/presentation/authentication/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';

void main() => runApp(const MaterialApp(home: FeedbackPage()));

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // 1. INCREASE THIS VALUE to make the card and shadows start higher (taller)
  static const double cardHeight = 580.0; // Changed from 500.0
  static const double emojiSize = 70.0;

  final Set<String> _selectedTags = {
    'Performance',
    'Bug',
    'Crashes',
    'Navigation'
  };

  void _handleTap(String label) {
    setState(() {
      _selectedTags.contains(label)
          ? _selectedTags.remove(label)
          : _selectedTags.add(label);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:
                          const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'feedback.title'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // The Card Area
            SizedBox(
              // Wrap height matches the tallest point (main card top + half emoji)
              height: cardHeight + (emojiSize / 2),
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  // Shadow 1 (Smallest width / Highest start)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.82,
                      height: cardHeight + 25,
                      // Still offsets from the main height
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(40)),
                      ),
                    ),
                  ),
                  // Shadow 2 (Medium width / Middle start)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: cardHeight + 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(40)),
                      ),
                    ),
                  ),

                  // Main White Card
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: cardHeight,
                      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(45)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'feedback.question'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontFamily: AppConstants.fontRegular,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D3139),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Wrap(
                            spacing: 10,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildTag('Performance', Colors.indigo),
                              _buildTag('Support', Colors.green),
                              _buildTag('Bug', Colors.purple),
                              _buildTag('UI', Colors.red),
                              _buildTag('UX', Colors.teal),
                              _buildTag('Crashes', Colors.pink),
                              _buildTag('Loading', Colors.yellow),
                              _buildTag('Navigation', Colors.orange),
                              _buildTag('Leadership', Colors.lightBlue),
                              _buildTag('Pricing', Colors.blueGrey),
                            ],
                          ),
                          AppConstants.verticalSpaceXXL,
                          CommonButton(
                              title: 'feedback.submit'.tr(), onPressed: () {}),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),

                  // THE EMOJI (Fixed Calculation)
                  Positioned(
                    // This pulls the emoji up by exactly half its height from the top of the Stack
                    top: 8,
                    child: Container(
                      width: emojiSize,
                      height: emojiSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white, width: 6),
                      ),
                      child: const Icon(
                        Icons.sentiment_satisfied_alt,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    bool isSelected = _selectedTags.contains(label);
    return GestureDetector(
      onTap: () => _handleTap(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          'feedback.tag_${label.toLowerCase()}'.tr(),
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontFamily: AppConstants.fontRegular,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
