import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/account/presentation/widgets/widgets.dart';
import 'package:daily_language/features/authentication/domain/domain.dart';
import 'package:daily_language/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User get _user => getUserFromState(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AccountBloc>().add(AccountRequested(uid: _user.id));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountInProgress) {
            return AppCircularProgressIndicator();
          }
          if (state is AccountFailure) {
            return Center(child: Text(state.error, style: textTheme.bodyMedium));
          }
          if (state is AccountSuccess) {
            final account = state.account;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AccountAvatarButton(onTap: () {}),
                    SizedBox(height: 24),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorApp.darkGray.withAlpha(40), width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: ListTile.divideTiles(
                          context: context,
                          tiles: [
                            AccountListTile(
                              icon: Icons.person,
                              color: ColorApp.primary,
                              title: context.l10n.fullName,
                              subtitle: account.fullName,
                            ),
                            AccountListTile(
                              icon: Icons.email,
                              color: ColorApp.green,
                              title: context.l10n.email,
                              subtitle: account.email,
                            ),
                            AccountListTile(
                              icon: Icons.phone,
                              color: ColorApp.purple,
                              title: context.l10n.phoneNumber,
                              subtitle: account.phoneNumber,
                            ),
                            AccountListTile(
                              icon: Icons.local_fire_department_rounded,
                              color: ColorApp.orange,
                              title: context.l10n.streak,
                              subtitle: account.streak.toString(),
                            ),
                          ],
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(onPressed: () {}, label: context.l10n.editProfile),
                    SizedBox(height: 20),
                    SecondaryButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
                      },
                      label: context.l10n.logOut,
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
