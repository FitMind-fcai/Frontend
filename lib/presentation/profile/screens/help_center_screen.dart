import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Dark Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _headerButton(
                        Icons.chevron_left, () => Navigator.pop(context)),
                    const Text(
                      'Help Center',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.fontRegular,
                      ),
                    ),
                    _headerButton(Icons.settings_outlined, () {}),
                  ],
                ),
                const SizedBox(height: 25),
                // FAQ Tab (Simplified as requested)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "FAQ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppConstants.fontRegular),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar

                  const SizedBox(height: 25),

                  // FAQ List
                  const _FaqTile(
                    question: "What is FitMind?",
                    answer:
                        "FitMind is an advanced fitness app that utilizes artificial intelligence to provide personalized training.",
                  ),
                  const _FaqTile(
                    question: "How does FitMind work?",
                    answer:
                        "It analyzes your performance data to adjust your workout intensity in real-time.",
                  ),
                  const _FaqTile(
                    question: "Is FitMind a replacement for fitness coach?",
                    answer:
                        "It acts as a digital supplement to provide 24/7 guidance alongside your professional coaching.",
                  ),
                  const _FaqTile(
                    question: "Is FitMind free to use?",
                    answer:
                        "We offer both free tier basics and premium AI features.",
                  ),
                  const _FaqTile(
                    question: "Is my data secure?",
                    answer:
                        "Yes, all health and personal data is encrypted and stored locally when possible.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final bool isInitialExpanded;

  const _FaqTile({
    required this.question,
    required this.answer,
    this.isInitialExpanded = false,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 15),
      // We use constraints to make the box feel "bigger" by default
      constraints: const BoxConstraints(minHeight: 80),
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          // Logic: If expanded, use transparent. If collapsed, show the grey border.
          color: _isExpanded ? Colors.grey[600]!:Colors.transparent ,
          width: 2,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          // This removes the splash effect that can sometimes show outside the border
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: widget.isInitialExpanded,
          onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
          // Adding vertical padding here makes the "box" feel bigger
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: Text(
            widget.question,
            style: TextStyle(
              fontSize: 16, // Slightly larger font
              fontWeight: FontWeight.bold,
              color: _isExpanded ? Colors.white : const Color(0xFF1A1A1A),
              fontFamily: AppConstants.fontRegular,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.orange : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.rotate(
              angle: _isExpanded ? 1.57 : 4.71,
              child: Image.asset(
                "assets/images/back_button.png",
                width: 32,
                height: 32,
                color: _isExpanded ? Colors.white : Colors.grey,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: _isExpanded ? Colors.white70 : Colors.black54,
                  height: 1.6,
                  fontFamily: AppConstants.fontRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
