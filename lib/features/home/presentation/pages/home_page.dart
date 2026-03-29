import 'package:daily_language/core/utils/helper/admob_service.dart';
import 'package:daily_language/core/utils/widgets/app_circular_progress_indicator.dart';
import 'package:daily_language/core/utils/widgets/app_retry_widget.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/authentication/presentation/presentation.dart';
import 'package:daily_language/features/home/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountInProgress) {
            return const AppCircularProgressIndicator();
          }

          if (state is AccountFailure) {
            return AppRetryWidget(
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
            AdMobService().loadAllAds();
            return HomeContentWidget(account: state.account);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
