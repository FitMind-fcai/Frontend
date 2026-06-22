import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../manager_log_history/log_history_bloc.dart';
import 'log_detail_screen.dart';


class LogHistoryScreen extends StatelessWidget {
  const LogHistoryScreen({super.key});

  static const _cards = [
    _LogCard(
      category: 'meal',
      label: 'Meal Logs',
      subtitle: 'Calories & macros',
      icon: Icons.restaurant_outlined,
      color: Color(0xFFFF6B00),
    ),
    _LogCard(
      category: 'workout',
      label: 'Workout Logs',
      subtitle: 'Sets, reps & duration',
      icon: Icons.fitness_center_outlined,
      color: Color(0xFF3B82F6),
    ),
    _LogCard(
      category: 'weight',
      label: 'Weight Logs',
      subtitle: 'Body weight over time',
      icon: Icons.monitor_weight_outlined,
      color: Color(0xFF26A69A),
    ),
    _LogCard(
      category: 'sleep',
      label: 'Sleep Logs',
      subtitle: 'Hours & quality',
      icon: Icons.bedtime_outlined,
      color: Color(0xFF7E57C2),
    ),
    _LogCard(
      category: 'hydration',
      label: 'Hydration Logs',
      subtitle: 'Water intake',
      icon: Icons.water_drop_outlined,
      color: Color(0xFF29B6F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Logs',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: _cards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) => _LogCategoryTile(card: _cards[i]),
      ),
    );
  }
}

class _LogCard {
  final String category;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _LogCard({
    required this.category,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _LogCategoryTile extends StatelessWidget {
  final _LogCard card;

  const _LogCategoryTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<LogHistoryBloc>(),
            child: LogDetailScreen(category: card.category, title: card.label),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.transparent
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: card.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(card.icon, color: card.color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    card.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                      fontFamily: AppConstants.fontRegular,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}