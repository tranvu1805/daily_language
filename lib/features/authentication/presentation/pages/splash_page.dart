import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:daily_language/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorApp.backgroundGradient),
        child: BlocListener<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is AuthenticationSuccess) {
                context.read<AccountBloc>().add(
                  AccountCreated(
                    param: CreateAccountUseCaseParams(
                      uid: state.user.id,
                      email: state.user.email,
                      fullName: state.user.username,
                    ),
                  ),
                );
              } else if (state is AuthenticationFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is AuthenticationInProgress) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Assets.iconsLogo, width: 200),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.dailyLanguage,
                    style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 100),
                  Text(context.l10n.continueWith, style: textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 62,
                        width: 98,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ColorApp.pureWhite,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            context.read<AuthenticationBloc>().add(AuthenticationGoogleLoggedIn());
                          },
                          icon: Icon(
                            FontAwesomeIcons.googlePlusG,
                            size: 24,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
