import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/word/presentation/bloc/user_words_bloc/user_words_bloc.dart';
import 'package:daily_language/features/word/presentation/widgets/word_card.dart';
import 'package:daily_language/features/word/presentation/widgets/word_level_empty_words_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<UserWordsBloc, UserWordsState>(
      builder: (context, state) {
        if (state.status == UserWordsStatus.loading) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Center(
                child: CircularProgressIndicator(color: accentColor),
              ),
            ),
          );
        }

        if (state.status == UserWordsStatus.failure) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: AppRetryWidget(
                message: state.error,
                onRetry: onRefresh,
              ),
            ),
          );
        }

        if (state.status == UserWordsStatus.success && state.userWords.isEmpty) {
          return SliverToBoxAdapter(
            child: WordLevelEmptyWordsWidget(accentColor: accentColor),
          );
        }

        if (state.status == UserWordsStatus.success) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList.separated(
              itemCount: state.hasReachedMax
                  ? state.userWords.length
                  : state.userWords.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.userWords.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: accentColor),
                    ),
                  );
                }
                final word = state.userWords[index];
                return WordCard(
                  word: word,
                  onTap: () {
                    // TODO: Navigate to word details
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
