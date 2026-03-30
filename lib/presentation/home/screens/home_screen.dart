import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/manager/auth_bloc.dart';
import '../../authentication/widgets/common_button.dart';
import '../../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HomePage(),
    const Center(child: Text('Workout')),
    const Center(child: Text('Nutrition')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[100],
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        width: size.width,
        height: 95,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(size.width, 95),
              painter: _BNBCustomPainter(),
            ),

            // ── FAB ───────────────────────────────────────
            Positioned(
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
                      // Your navigation logic
                    },
                    child: const Icon(Icons.add, color: Colors.white, size: 35),
                  ),
                ),
              ),
            ),

            SizedBox(
              width: size.width,
              height: 95, //
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(icon: Icons.home_rounded, index: 0),
                  _buildNavItem(icon: Icons.fitness_center, index: 1),
                  SizedBox(width: size.width * 0.20),
                  // 👈 SizedBox instead of Container
                  _buildNavItem(icon: Icons.restaurant, index: 2),
                  _buildNavItem(icon: Icons.person, index: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(isSelected ? 12 : 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[200] : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: isSelected ? 28 : 24,
              color: isSelected ? Colors.black : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            width: isSelected ? 20 : 0,
            height: 3.5,
            constraints: const BoxConstraints(minWidth: 0),
            decoration: BoxDecoration(
              color: isSelected ? AppConstants.primaryColor : Colors
                  .transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    double width = size.width;
    double height = size.height;
    double center = width / 2;
    double cornerRadius = 30;

    double holeWidth = 100;
    double holeDepth = 48;

    // Top-left rounded corner
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Line to notch start
    path.lineTo(center - holeWidth, 0);

    // Left curve into notch
    path.cubicTo(
      center - (holeWidth * 0.5), 0,
      center - (holeWidth * 0.65), holeDepth,
      center, holeDepth,
    );

    // Right curve out of notch
    path.cubicTo(
      center + (holeWidth * 0.65), holeDepth,
      center + (holeWidth * 0.5), 0,
      center + holeWidth, 0,
    );

    // Top-right rounded corner
    path.lineTo(width - cornerRadius, 0);
    path.quadraticBezierTo(width, 0, width, cornerRadius);

    // Right side, bottom, left side
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.lineTo(0, cornerRadius);

    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 8.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ── Home page content ─────────────────────────────────────────────────────────
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
            CommonButton(
              title: 'Logout',
              onPressed: () {
                context.read<AuthBloc>().add(DeleteUserEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
