import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/core/utils/widget/app_circular_progress_indicator.dart';
import 'package:daily_language/features/word/presentation/bloc/user_words_bloc/user_words_bloc.dart';
import 'package:daily_language/features/word/presentation/widgets/word_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyVocabularySectionWidget extends StatelessWidget {
  const MyVocabularySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    
    return BlocBuilder<UserWordsBloc, UserWordsState>(
      builder: (context, state) {
        if (state.status == UserWordsStatus.loading &&
            state.userWords.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AppCircularProgressIndicator(),
          );
        }

        if (state.status == UserWordsStatus.failure &&
            state.userWords.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              state.error,
              style: textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
            ),
          );
        }

        if (state.userWords.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.noWordsYet,
              style: textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
            ),
          );
        }

        final preview = state.userWords.take(3).toList();
        final total = state.userWords.length;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Summary count card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ColorApp.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.bookmark,
                        color: ColorApp.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$total',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorApp.charcoalBlue,
                          ),
                        ),
                        Text(
                          l10n.personalVocabulary,
                          style: textTheme.labelSmall?.copyWith(
                            color: ColorApp.taupeGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final word = preview[index];
                  return WordCard(
                    word: word,
                    onTap: () {
                      context.push(
                        '${Routes.words}/${Routes.wordsLevelDetail}',
                        extra: word,
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                shrinkWrap: true,
                itemCount: preview.length,
              ),
            ],
          ),
        );
      },
    );
  }
}
