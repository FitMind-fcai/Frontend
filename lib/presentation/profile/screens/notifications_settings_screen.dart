import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/notifications_prefernces_model.dart';
import '../../notifications/manager/notification_bloc.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // Local state for toggles
  bool _mealReminders = false;
  bool _workoutReminders = false;
  bool _hydrationReminders = false;
  bool _sleepReminders = false;
  bool _coachingReminders = false;

  // Local state for time fields
  int _hydrationIntervalHours = 2;
  int _mealReminderMinutesBefore = 30;
  int _workoutReminderHour = 8;
  int _sleepReminderHour = 22;
  int _coachingDailyHour = 9;

  void _populateFromPrefs(NotificationPreferencesModel prefs) {
    _mealReminders = prefs.mealRemindersEnabled;
    _workoutReminders = prefs.workoutRemindersEnabled;
    _hydrationReminders = prefs.hydrationRemindersEnabled;
    _sleepReminders = prefs.sleepRemindersEnabled;
    _coachingReminders = prefs.coachingRemindersEnabled;
    _hydrationIntervalHours = prefs.hydrationIntervalHours;
    _mealReminderMinutesBefore = prefs.mealReminderMinutesBefore;
    _workoutReminderHour = prefs.workoutReminderHour;
    _sleepReminderHour = prefs.sleepReminderHour;
    _coachingDailyHour = prefs.coachingDailyHour;
  }

  void _onSave() {
    final prefs = NotificationPreferencesModel(
      mealRemindersEnabled: _mealReminders,
      workoutRemindersEnabled: _workoutReminders,
      hydrationRemindersEnabled: _hydrationReminders,
      sleepRemindersEnabled: _sleepReminders,
      coachingRemindersEnabled: _coachingReminders,
      hydrationIntervalHours: _hydrationIntervalHours,
      mealReminderMinutesBefore: _mealReminderMinutesBefore,
      workoutReminderHour: _workoutReminderHour,
      sleepReminderHour: _sleepReminderHour,
      coachingDailyHour: _coachingDailyHour,
    );
    context.read<NotificationBloc>().add(
          UpdateNotificationPreferencesEvent(prefs),
        );
  }

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotificationPreferencesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        elevation: 0,
        leading: BackButton(color: isDark ? Colors.white : Colors.black),
        title: Text(
          'notification_settings.title'.tr(),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontRegular,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationPreferencesLoaded) {
            setState(() => _populateFromPrefs(state.prefs));
          }
          if (state is NotificationPreferencesSaved) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'notification_settings.settings_saved'.tr(),
              ),
            ));
          }
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                        'notification_settings.section_reminders'.tr(), isDark),
                    _SettingsGroup(
                      children: [
                        _SettingsTile(
                          icon: Icons.restaurant_menu_outlined,
                          label: 'notification_settings.meal_reminders'.tr(),
                          onTap: () {},
                          trailing: _AppToggle(
                            value: _mealReminders,
                            onChanged: (v) =>
                                setState(() => _mealReminders = v),
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.fitness_center_outlined,
                          label: 'notification_settings.workout_reminders'.tr(),
                          onTap: () {},
                          trailing: _AppToggle(
                            value: _workoutReminders,
                            onChanged: (v) =>
                                setState(() => _workoutReminders = v),
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.water_drop_outlined,
                          label:
                              'notification_settings.hydration_reminders'.tr(),
                          onTap: () {},
                          trailing: _AppToggle(
                            value: _hydrationReminders,
                            onChanged: (v) =>
                                setState(() => _hydrationReminders = v),
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.bedtime_outlined,
                          label: 'notification_settings.sleep_reminders'.tr(),
                          onTap: () {},
                          trailing: _AppToggle(
                            value: _sleepReminders,
                            onChanged: (v) =>
                                setState(() => _sleepReminders = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionHeader(
                        'notification_settings.section_ai_coach'.tr(), isDark),
                    _SettingsGroup(
                      children: [
                        _SettingsTile(
                          icon: Icons.face_retouching_natural,
                          label: 'notification_settings.ai_coach_notifications'
                              .tr(),
                          onTap: () {},
                          trailing: _AppToggle(
                            value: _coachingReminders,
                            onChanged: (v) =>
                                setState(() => _coachingReminders = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark?AppConstants.primaryColor:Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'notification_settings.save_settings'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.check,
                              color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppConstants.fontRegular,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Icon(Icons.more_vert,
              size: 18, color: isDark ? Colors.white38 : Colors.grey),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) => Column(children: children);
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark
                        ? colorScheme.surfaceContainerHighest
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      size: 18, color: isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppConstants.fontRegular,
                      color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                trailing ??
                    Image.asset(
                      "assets/images/Monotone arrow right.png",
                      width: 20,
                      height: 20,
                      color: isDark ? Colors.white : Colors.black,
                      colorBlendMode: BlendMode.srcIn,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AppToggle({required this.value, required this.onChanged});

  @override
  State<_AppToggle> createState() => _AppToggleState();
}

class _AppToggleState extends State<_AppToggle> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _val,
      onChanged: (v) {
        setState(() => _val = v);
        widget.onChanged(v);
      },
      activeColor: Colors.white,
      activeTrackColor: AppConstants.primaryColor,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFDDDDDD),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
