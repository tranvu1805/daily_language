import 'package:daily_language/core/bloc/locale_bloc/locale_bloc.dart';
import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/helper/local_storage_helper.dart';
import 'package:daily_language/core/utils/helper/notification_helper.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/account/domain/use_cases/create_account_use_case.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/account/presentation/widgets/widgets.dart';
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
    final l10n = context.l10n;
    return SafeArea(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountInProgress) {
            return const AppCircularProgressIndicator();
          }
          if (state is AccountFailure) {
            return AppRetryWidget(
              message: state.error.toLocalizedError(context),
              onRetry: () {
                final authState = context.read<AuthenticationBloc>().state;
                if (authState is AuthenticationSuccess) {
                  context.read<AccountBloc>().add(
                    AccountCreated(
                      param: CreateAccountUseCaseParams(
                        uid: authState.user.id,
                        email: authState.user.email,
                        fullName: authState.user.username,
                        avatarUrl: authState.user.avatarUrl,
                      ),
                    ),
                  );
                }
              },
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
                        SettingsSectionLabel(label: l10n.functions),
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
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(24),
                                        ),
                                      ),
                                      builder: (context) => LanguagePickerSheet(
                                        currentLocale: currentLocale,
                                      ),
                                    );
                                  },
                                  icon: Icons.translate,
                                  iconBgColor: const Color(0xFFE0F2FE),
                                  iconColor: Colors.lightBlue,
                                  title: l10n.appLanguage,
                                  subtitle: currentLocale == 'en'
                                      ? context.l10n.english
                                      : context.l10n.vietnamese,
                                  trailing: const SettingsChevron(),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SettingsSectionLabel(label: l10n.personalInfo),
                        const SizedBox(height: 12),
                        SettingsCard(
                          onTap: () {
                            context.push(Routes.account + Routes.accountEdit);
                          },
                          children: [
                            SettingsTile(
                              icon: Icons.person_outline,
                              iconBgColor: const Color(0xFFDCFCE7),
                              iconColor: ColorApp.green,
                              title: l10n.updateProfile,
                              subtitle: l10n.personalInfo,
                              trailing: const SettingsChevron(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SettingsSectionLabel(label: l10n.notifications),
                        const SizedBox(height: 12),
                        SettingsCard(
                          children: [
                            SettingsTile(
                              icon: Icons.notifications_outlined,
                              iconBgColor: const Color(0xFFF3E8FF),
                              iconColor: ColorApp.purple,
                              title: l10n.learningReminders,
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
                        SettingsSectionLabel(label: l10n.help),
                        const SizedBox(height: 12),
                        SettingsCard(
                          onTap: () {},
                          children: [
                            SettingsTile(
                              icon: Icons.help_outline,
                              iconBgColor: const Color(0xFFFFEDD5),
                              iconColor: ColorApp.orange,
                              title: l10n.guidesAndFAQ,
                              trailing: const SettingsChevron(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SettingsLogoutButton(
                          onTap: () async {
                            final confirmed =
                                await DialogHelper.showConfirmDialog(
                                  context: context,
                                  title: l10n.logOut,
                                  message: l10n.logoutConfirm,
                                  confirmText: l10n.logOut,
                                  cancelText: l10n.cancel,
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
                            '${l10n.version} 2.1.0',
                            style: textTheme.bodySmall?.copyWith(
                              color: ColorApp.taupeGray,
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
}
