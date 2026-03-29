import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OxfordWordsListWidget extends StatelessWidget {
  final String topic;
  final Color accentColor;

  const OxfordWordsListWidget({
    super.key,
    required this.topic,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsBloc, WordsState>(
      builder: (context, state) {
        if (state.status == WordStatus.loading && state.words.isEmpty) {
          return const SliverFillRemaining(
            child: AppCircularProgressIndicator(),
          );
        } else if (state.status == WordStatus.failure && state.words.isEmpty) {
          return SliverFillRemaining(
            child: AppRetryWidget(
              onRetry: () => _refresh(context),
              message: state.error.toLocalizedError(context),
            ),
          );
        } else if (state.words.isEmpty) {
          return const SliverFillRemaining(child: AppEmpty());
        }
        final showLoader = !state.hasReachedMax;
        final itemCount = state.words.length + (showLoader ? 1 : 0);
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              if (index == state.words.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: CircularProgressIndicator(color: accentColor),
                  ),
                );
              }
              final word = state.words[index];
              return OxfordWordCard(word: word, accentColor: accentColor);
            },
            separatorBuilder: (context, index) {
              if (index == state.words.length - 1 && showLoader) {
                return const SizedBox.shrink();
              }
              return const SizedBox(height: 8);
            },
            itemCount: itemCount,
          ),
        );
      },
    );
  }

  void _refresh(BuildContext context) {
    context.read<WordsBloc>().add(
      WordsRequested(
        param: GetDictionaryWordsUseCaseParams(level: topic, limit: pageSize),
      ),
    );
  }
}
