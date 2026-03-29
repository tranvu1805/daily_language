import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/core/utils/helper/local_storage_helper.dart';
import 'package:daily_language/core/utils/helper/notification_helper.dart';
import 'package:daily_language/core/utils/helper/snackbar_helper.dart';
import 'package:daily_language/features/account/domain/entities/account.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorApp.secondary, ColorApp.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white24,
                    child: ClipOval(child: Image.network(account.avatarUrl)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.welcomeBack,
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        account.fullName,
                        style: textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  final localStorage = sl<LocalStorageHelper>();
                  final initialTime = TimeOfDay(
                    hour: localStorage.reminderHour,
                    minute: localStorage.reminderMinute,
                  );
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: initialTime,
                  );
                  if (selectedTime != null) {
                    await localStorage.setReminderTime(
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    await sl<NotificationHelper>().scheduleDailyReminder();
                    if (context.mounted) {
                      SnackBarHelper.showSuccess(
                        context,
                        l10n.reminderSetAt(selectedTime.format(context)),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.alarm_add, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Current Streak
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currentStreak,
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${account.streak} ${l10n.days}',
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.highestStreak}: ${account.maxStreak} ${l10n.days}',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.local_fire_department,
                  color: ColorApp.orange,
                  size: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
