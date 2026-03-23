import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/bloc/user_word_bloc/user_word_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OxfordWordCard extends StatelessWidget {
  final Word word;
  final Color accentColor;

  const OxfordWordCard({
    super.key,
    required this.word,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        context.push(
          '${Routes.words}/${Routes.wordsLevelDetail}',
          extra: word,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        word.content,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorApp.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          word.pronunciation,
                          style: textTheme.bodySmall?.copyWith(
                            color: ColorApp.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(${word.type}) ${word.meaningEn}',
                    style: textTheme.bodySmall?.copyWith(
                      color: ColorApp.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    word.meaningVi,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {
                final account = getAccountFromState(context);
                final now = DateTime.now();
                final wordId = word.id.toLowerCase().replaceAll(' ', '_');
                context.read<UserWordBloc>().add(
                  UserWordCreated(
                    param: CreateUserWordUseCaseParams(
                      userId: account.uid,
                      wordId: wordId,
                      level: word.level,
                      word: word.content,
                      repetitionCount: 0,
                      wrongCount: 0,
                      stage: 0,
                      easeFactor: 2.5,
                      interval: 1,
                      lastReviewed: now,
                      nextReview: now.add(const Duration(hours: 8)),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.add_circle_rounded,
                color: accentColor,
                size: 28,
              ),
              splashRadius: 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
