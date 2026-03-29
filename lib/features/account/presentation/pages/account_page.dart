import 'package:daily_language/core/bloc/locale_bloc/locale_bloc.dart';
import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/helper/local_storage_helper.dart';
import 'package:daily_language/core/utils/helper/notification_helper.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:daily_language/features/authentication/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _notificationsEnabled = sl<LocalStorageHelper>().areNotificationsEnabled;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountInProgress) {
            return const AppCircularProgressIndicator();
          }
          if (state is AccountFailure) {
            return Center(
              child: Text(state.error, style: textTheme.bodyMedium),
            );
          }
          if (state is AccountSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const SettingsSectionLabel(label: 'Chức năng'),
                        const SizedBox(height: 12),
                        SettingsCard(
                          children: [
                            BlocBuilder<LocaleBloc, LocaleState>(
                              builder: (context, state) {
                                String currentLocale = 'en';
                                if (state is LocaleInitial) {
                                  currentLocale = state.localeCode;
                                } else if (state is LocaleLoaded) {
                                  currentLocale = state.localeCode;
                                }

                                return SettingsTile(
                                  onTap: () => _showLanguagePicker(
                                    context,
                                    currentLocale,
                                  ),
                                  icon: Icons.translate,
                                  iconBgColor: const Color(0xFFE0F2FE),
                                  iconColor: Colors.lightBlue,
                                  title: 'Ngôn ngữ ứng dụng',
                                  subtitle: currentLocale == 'en'
                                      ? 'English'
                                      : 'Tiếng Việt',
                                  trailing: const SettingsChevron(),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SettingsSectionLabel(label: 'Thông tin cá nhân'),
                        const SizedBox(height: 12),
                        SettingsCard(
                          onTap: () {
                            context.push(Routes.account + Routes.accountEdit);
                          },
                          children: const [
                            SettingsTile(
                              icon: Icons.person_outline,
                              iconBgColor: Color(0xFFDCFCE7),
                              iconColor: ColorApp.green,
                              title: 'Cập nhật hồ sơ',
                              subtitle: 'Thông tin cá nhân',
                              trailing: SettingsChevron(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SettingsSectionLabel(label: 'Thông báo'),
                        const SizedBox(height: 12),
                        SettingsCard(
                          children: [
                            SettingsTile(
                              icon: Icons.notifications_outlined,
                              iconBgColor: const Color(0xFFF3E8FF),
                              iconColor: ColorApp.purple,
                              title: 'Nhắc nhở học tập',
                              trailing: Switch(
                                value: _notificationsEnabled,
                                onChanged: (value) async {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                  await sl<LocalStorageHelper>()
                                      .setNotificationsEnabled(value);
                                  if (value) {
                                    await sl<NotificationHelper>()
                                        .requestPermission();
                                    await sl<NotificationHelper>()
                                        .scheduleDailyReminder();
                                  } else {
                                    await sl<NotificationHelper>().cancelAll();
                                  }
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: ColorApp.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SettingsSectionLabel(label: 'Trợ giúp'),
                        const SizedBox(height: 12),
                        SettingsCard(
                          onTap: () {},
                          children: const [
                            SettingsTile(
                              icon: Icons.help_outline,
                              iconBgColor: Color(0xFFFFEDD5),
                              iconColor: ColorApp.orange,
                              title: 'Hướng dẫn & FAQ',
                              trailing: SettingsChevron(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SettingsLogoutButton(
                          onTap: () async {
                            final confirmed =
                                await DialogHelper.showConfirmDialog(
                                  context: context,
                                  title: 'Đăng xuất',
                                  message:
                                      'Bạn có chắc chắn muốn đăng xuất không?',
                                  confirmText: 'Đăng xuất',
                                  cancelText: 'Hủy',
                                  confirmColor: const Color(0xFFDC2626),
                                );
                            if (confirmed == true && context.mounted) {
                              context.read<AuthenticationBloc>().add(
                                AuthenticationLoggedOut(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Phiên bản 2.1.0',
                            style: textTheme.bodySmall?.copyWith(
                              color: ColorApp.taupeGray,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, String currentLocale) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Chọn ngôn ngữ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildLanguageOption(
                context: context,
                title: 'English',
                localeCode: 'en',
                isSelected: currentLocale == 'en',
              ),
              const SizedBox(height: 12),
              _buildLanguageOption(
                context: context,
                title: 'Tiếng Việt',
                localeCode: 'vi',
                isSelected: currentLocale == 'vi',
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String localeCode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        context.read<LocaleBloc>().add(LocaleChanged(localeCode));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorApp.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? ColorApp.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ColorApp.primary : ColorApp.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: ColorApp.primary, size: 24),
          ],
        ),
      ),
    );
  }
}
