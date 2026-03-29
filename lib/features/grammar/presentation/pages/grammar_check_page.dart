import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/core/utils/helper/admob_service.dart';
import 'package:daily_language/core/utils/helper/dialog_helper.dart';
import 'package:daily_language/core/utils/helper/method_utils.dart';
import 'package:daily_language/core/utils/widgets/primary_button.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:daily_language/features/grammar/domain/domain.dart';
import 'package:daily_language/features/grammar/presentation/bloc/grammar_bloc.dart';
import 'package:daily_language/features/grammar/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrammarCheckPage extends StatefulWidget {
  final String? initialText;
  final String? language;

  const GrammarCheckPage({super.key, this.initialText, this.language});

  @override
  State<GrammarCheckPage> createState() => _GrammarCheckPageState();
}

class _GrammarCheckPageState extends State<GrammarCheckPage> {
  late final TextEditingController _controller;

  static int remainingTurnsFor(Account account) {
    if (account.isPremium) return 999;
    final now = DateTime.now().toLocal();
    final lastReview = account.lastAiReviewAt?.toLocal();
    final isNewDay = lastReview == null ||
        lastReview.day != now.day ||
        lastReview.month != now.month ||
        lastReview.year != now.year;
    if (isNewDay) return 3;
    final baseTurnsLeft = (3 - account.aiReviewCount).clamp(0, 3);
    return baseTurnsLeft + account.aiReviewCoins;
  }

  void _onCheckPressed(Account account) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final turns = remainingTurnsFor(account);
    if (turns <= 0) {
      _showLimitReachedDialog(account);
      return;
    }

    context.read<AccountBloc>().add(AccountAiReviewUsed(account: account));
    context.read<GrammarBloc>().add(
      CorrectGrammarRequested(
        GetGrammarCorrectionParams(
          text: text,
          language: Localizations.localeOf(context).languageCode,
        ),
      ),
    );
  }

  void _showLimitReachedDialog(Account account) {
    DialogHelper.showConfirmDialog(
      context: context,
      title: context.l10n.aiReviewLimitReached,
      message: context.l10n.watchAdToGetTurn,
      confirmText: context.l10n.getMoreTurns,
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        AdMobService().showRewardedAd(
          onUserEarnedReward: (reward) {
            if (mounted) {
              // Re-read the latest account from state at reward time
              final latestAccount = getAccountFromState(context);
              context.read<AccountBloc>().add(
                AccountAiReviewRewardEarned(account: latestAccount),
              );
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    if (widget.initialText != null &&
        widget.language != null &&
        widget.initialText!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final account = getAccountFromState(context);
        if (remainingTurnsFor(account) > 0) {
          context.read<AccountBloc>().add(
            AccountAiReviewUsed(account: account),
          );
          context.read<GrammarBloc>().add(
            CorrectGrammarRequested(
              GetGrammarCorrectionParams(
                text: widget.initialText!.trim(),
                language: widget.language!,
              ),
            ),
          );
        } else {
          _showLimitReachedDialog(account);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      appBar: AppBar(
        title: Text(
          l10n.grammarChecker,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.grammarCheckDescription,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: ColorApp.taupeGray),
            ),
            const SizedBox(height: 24),
            GrammarInputField(controller: _controller),
            const SizedBox(height: 8),
            // BlocBuilder ensures this rebuilds whenever AccountBloc emits a new state
            BlocBuilder<AccountBloc, AccountState>(
              builder: (context, accountState) {
                if (accountState is! AccountSuccess) {
                  return const SizedBox.shrink();
                }
                final account = accountState.account;
                if (account.isPremium) return const SizedBox.shrink();
                final turns = remainingTurnsFor(account);
                return Text(
                  l10n.aiReviewTurnsLeft(turns),
                  textAlign: TextAlign.right,
                  style: textTheme.labelSmall?.copyWith(
                    color: turns > 0 ? ColorApp.taupeGray : ColorApp.failedRed,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<GrammarBloc, GrammarState>(
              builder: (context, state) {
                final isLoading = state is GrammarInProgress;
                return PrimaryButton(
                  label: l10n.checkNow,
                  onPressed: isLoading
                      ? null
                      : () {
                          final accountState = context
                              .read<AccountBloc>()
                              .state;
                          if (accountState is AccountSuccess) {
                            _onCheckPressed(accountState.account);
                          }
                        },
                  isLoading: isLoading,
                );
              },
            ),
            const SizedBox(height: 32),
            BlocBuilder<GrammarBloc, GrammarState>(
              builder: (context, state) {
                if (state is GrammarSuccess) {
                  return GrammarAnalysisWidget(correction: state.correction);
                } else if (state is GrammarFailure) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorApp.failedRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorApp.failedRed.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: ColorApp.failedRed,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.error.toLocalizedError(context),
                            style: textTheme.bodyMedium?.copyWith(
                              color: ColorApp.failedRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
