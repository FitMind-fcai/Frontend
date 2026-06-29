// lib/presentation/notifications/screens/coaching_messages_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/coaching_message_model.dart';
import '../manager/notification_bloc.dart';

class CoachingMessagesScreen extends StatefulWidget {
  const CoachingMessagesScreen({super.key});

  @override
  State<CoachingMessagesScreen> createState() => _CoachingMessagesScreenState();
}

class _CoachingMessagesScreenState extends State<CoachingMessagesScreen> {
  String? _selectedCategory; // null = all
  bool _unreadOnly = false;

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadCoachingMessagesEvent());
  }

  void _reload() {
    context.read<NotificationBloc>().add(
      LoadCoachingMessagesEvent(
        category: _selectedCategory,
        unreadOnly: _unreadOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = isDark ? colorScheme.surface : const Color(0xFFF8F9FB);
    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final borderColor =
    isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'notifications.title'.tr(),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textDark,
            fontFamily: AppConstants.fontRegular,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<NotificationBloc>()
                  .add(const MarkAllCoachingMessagesReadEvent());
            },
            child: Text(
              'notifications.mark_all_read'.tr(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryColor,
                fontFamily: AppConstants.fontRegular,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: borderColor),
        ),
      ),
      body: Column(
        children: [
          _buildFilterRow(isDark, colorScheme, textDark),
          Expanded(
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is CoachingMessagesLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: AppConstants.primaryColor),
                  );
                }
                if (state is CoachingMessageActionError) {
                  return _buildError(state.message, textDark);
                }
                if (state is CoachingMessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return _buildEmpty(isDark, textDark);
                  }
                  return RefreshIndicator(
                    color: AppConstants.primaryColor,
                    onRefresh: () async => _reload(),
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _CoachingMessageTile(
                            message: msg,
                            onTap: () {
                              if (!msg.isRead) {
                                context
                                    .read<NotificationBloc>()
                                    .add(MarkCoachingMessageReadEvent(msg.id));
                              }
                            },
                            onDismiss: () {
                              context
                                  .read<NotificationBloc>()
                                  .add(DismissCoachingMessageEvent(msg.id));
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(bool isDark, ColorScheme colorScheme, Color textDark) {
    final categories = [
      (null, 'notifications.filter_all'.tr()),
      ('daily', 'notifications.filter_daily'.tr()),
      ('weekly', 'notifications.filter_weekly'.tr()),
      ('alert', 'notifications.filter_alert'.tr()),
    ];
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: categories.map((c) {
          final (value, label) = c;
          final isSelected = _selectedCategory == value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedCategory = value);
                _reload();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppConstants.primaryColor
                      : (isDark ? colorScheme.surfaceContainerHighest : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppConstants.primaryColor
                        : (isDark ? Colors.white24 : const Color(0xFFEAEAEA)),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white60 : const Color(0xFF6B7280)),
                    fontFamily: AppConstants.fontRegular,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmpty(bool isDark, Color textDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none_rounded,
              size: 56, color: isDark ? Colors.white24 : const Color(0xFFD1D5DB)),
          const SizedBox(height: 12),
          Text(
            'notifications.empty_title'.tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textDark,
              fontFamily: AppConstants.fontRegular,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, Color textDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textDark, fontFamily: AppConstants.fontRegular),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _reload,
              style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
              child: Text('notifications.retry'.tr(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Message tile ──



class _CoachingMessageTile extends StatefulWidget {
  final CoachingMessageModel message;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _CoachingMessageTile({
    required this.message,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_CoachingMessageTile> createState() => _CoachingMessageTileState();
}

class _CoachingMessageTileState extends State<_CoachingMessageTile> {
  bool _isExpanded = false;

  Color _urgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
      case 'urgent':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      default:
        return AppConstants.primaryColor;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'daily':
        return Icons.today_rounded;
      case 'weekly':
        return Icons.calendar_view_week_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final borderColor =
    isDark ? colorScheme.outline.withOpacity(0.2) : const Color(0xFFEAEAEA);
    final textDark = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final textMid = isDark ? Colors.white60 : const Color(0xFF6B7280);
    final accent = _urgencyColor(widget.message.urgency);

    return Dismissible(
      key: ValueKey(widget.message.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          setState(() => _isExpanded = !_isExpanded);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.message.isRead ? cardColor : accent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.message.isRead ? borderColor : accent.withOpacity(0.3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(_categoryIcon(widget.message.category), color: accent, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.message.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: widget.message.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: textDark,
                              fontFamily: AppConstants.fontRegular,
                            ),
                          ),
                        ),
                        if (!widget.message.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6, top: 2),
                            decoration:
                            BoxDecoration(color: accent, shape: BoxShape.circle),
                          ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: textMid,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Collapsed: 2-line preview. Expanded: full body.
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      firstChild: Text(
                        widget.message.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: textMid,
                          height: 1.4,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                      secondChild: Text(
                        widget.message.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: textMid,
                          height: 1.5,
                          fontFamily: AppConstants.fontRegular,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('MMM d, h:mm a').format(widget.message.createdAt),
                      style: TextStyle(
                          fontSize: 11,
                          color: textMid,
                          fontFamily: AppConstants.fontRegular),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}