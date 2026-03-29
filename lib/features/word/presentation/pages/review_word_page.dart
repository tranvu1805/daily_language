import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/utils/helper/notification_helper.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReviewWordPage extends StatefulWidget {
  const ReviewWordPage({super.key});

  @override
  State<ReviewWordPage> createState() => _ReviewWordPageState();
}

class _ReviewWordPageState extends State<ReviewWordPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Account get account => getAccountFromState(context);

  @override
  void initState() {
    super.initState();
    context.read<ReviewWordBloc>().add(ReviewWordLoaded(userId: account.uid));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    context.read<ReviewWordBloc>().add(
      ReviewWordAnswerSubmitted(answer: _controller.text),
    );
  }

  void _next() {
    _controller.clear();
    context.read<ReviewWordBloc>().add(ReviewWordNextRequested());
    // Auto focus after a short delay to let animations/rebuild finish
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return BlocListener<ReviewWordBloc, ReviewWordState>(
      listener: (context, state) {
        if (state.status == ReviewWordStatus.finished) {
          context.read<AccountBloc>().add(
            AccountStreakUpdated(account: account),
          );
          sl<NotificationHelper>().scheduleDailyReminder(forceTomorrow: true);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const ReviewCompletionDialog(),
          );
        }
        if (state.error.isNotEmpty &&
            state.status == ReviewWordStatus.failure) {
          SnackBarHelper.showFailure(context, state.error.toLocalizedError(context));
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await DialogHelper.showConfirmDialog(
            context: context,
            title: l10n.reviewSession,
            message: l10n.stopReviewingQuestion,
            confirmText: l10n.stop,
            cancelText: l10n.cancel,
            confirmColor: Colors.redAccent,
          );

          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          backgroundColor: ColorApp.linenWhite,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              l10n.reviewWords,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorApp.textPrimary,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              color: ColorApp.textPrimary,
              onPressed: () async {
                final shouldPop = await DialogHelper.showConfirmDialog(
                  context: context,
                  title: l10n.stop,
                  message: l10n.exitReviewQuestion,
                  confirmText: l10n.exit,
                  cancelText: l10n.continueText,
                  confirmColor: Colors.redAccent,
                );
                if (shouldPop == true && context.mounted) {
                  context.pop();
                }
              },
            ),
          ),
          body: BlocBuilder<ReviewWordBloc, ReviewWordState>(
            builder: (context, state) {
              if (state.status == ReviewWordStatus.loading &&
                  state.reviewWords.isEmpty) {
                return const AppCircularProgressIndicator();
              }

              if (state.status == ReviewWordStatus.failure &&
                  state.reviewWords.isEmpty) {
                return AppRetryWidget(
                  onRetry: () => context.read<ReviewWordBloc>().add(
                    ReviewWordLoaded(userId: account.uid),
                  ),
                  message: l10n.failedToLoadWords(state.error.toLocalizedError(context)),
                );
              }

              if (state.status == ReviewWordStatus.finished) {
                return const SizedBox.shrink();
              }

              if (state.currentDictionaryWord == null) {
                return const AppCircularProgressIndicator();
              }

              final word = state.currentDictionaryWord!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReviewProgressWidget(
                      currentIndex: state.currentIndex,
                      totalCount: state.reviewWords.length,
                    ),
                    const SizedBox(height: 48),
                    ReviewDefinitionCard(
                      meaningEn: word.meaningEn,
                      meaningVi: word.meaningVi,
                      isShowingAnswer: state.isShowingAnswer,
                    ),
                    const SizedBox(height: 48),
                    ReviewWordInput(
                      content: word.content,
                      controller: _controller,
                      focusNode: _focusNode,
                      isShowingAnswer: state.isShowingAnswer,
                      isCorrect: state.isCorrect,
                      onSubmitted: _submit,
                      onTextUpdated: () => setState(() {}),
                    ),
                    const SizedBox(height: 48),
                    if (state.isShowingAnswer) ...[
                      ReviewFeedbackWidget(isCorrect: state.isCorrect),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: ColorApp.primary.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          l10n.nextWord,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: ColorApp.primary.withValues(alpha: 0.3),
                        ),
                        child: Text(
                          l10n.checkAnswer,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
