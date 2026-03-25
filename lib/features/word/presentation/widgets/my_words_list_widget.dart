import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/bloc/user_words_bloc/user_words_bloc.dart';
import 'package:daily_language/features/word/presentation/widgets/word_card.dart';
import 'package:daily_language/features/word/presentation/widgets/word_level_empty_words_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyWordsListWidget extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onRefresh;

  const MyWordsListWidget({
    super.key,
    required this.accentColor,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserWordsBloc, UserWordsState>(
      listenWhen: (previous, current) =>
          previous.action != current.action ||
          previous.status != current.status,
      listener: (context, state) {
        if (state.action == UserWordsAction.detail) {
          if (state.status == UserWordsStatus.success &&
              state.selectedWordDetail != null) {
            context.push(
              '${Routes.words}/${Routes.wordsLevelDetail}',
              extra: {'word': state.selectedWordDetail, 'showAddButton': false},
            );
          } else if (state.status == UserWordsStatus.failure) {
            SnackBarHelper.showFailure(context, state.error);
          }
        }
      },
      child: BlocBuilder<UserWordsBloc, UserWordsState>(
        builder: (context, state) {
          if (state.status == UserWordsStatus.loading &&
              state.action != UserWordsAction.request) {
            return const SliverToBoxAdapter(
              child: AppCircularProgressIndicator(),
            );
          }

          if (state.status == UserWordsStatus.failure &&
              state.action != UserWordsAction.request) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: AppRetryWidget(message: state.error, onRetry: onRefresh),
              ),
            );
          }

          if (state.status == UserWordsStatus.success &&
              state.userWords.isEmpty) {
            return SliverToBoxAdapter(
              child: WordLevelEmptyWordsWidget(accentColor: accentColor),
            );
          }

          if (state.status == UserWordsStatus.success ||
              (state.status == UserWordsStatus.loading &&
                  state.action == UserWordsAction.request)) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList.separated(
                itemCount: state.hasReachedMax
                    ? state.userWords.length
                    : state.userWords.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.userWords.length) {
                    return const AppCircularProgressIndicator();
                  }
                  final word = state.userWords[index];
                  return WordCard(
                    word: word,
                    onTap: () {
                      context.read<UserWordsBloc>().add(
                        UserWordDetailRequested(
                          params: GetDictionaryWordByIdUseCaseParams(
                            word: word.word,
                            level: word.level,
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            );
          }

          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }
}
