import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WordPage extends StatelessWidget {
  const WordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final levels = LevelData.getLevels(l10n);

    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            final account = getAccountFromState(context);
            context.read<ReviewWordBloc>().add(
                  ReviewWordLoaded(userId: account.uid),
                );
            context.read<UserWordsBloc>().add(
                  UserWordsRequested(
                    param: GetUserWordsUseCaseParams(
                      userId: account.uid,
                      limit: 20,
                    ),
                  ),
                );
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
            slivers: [
              // ── Section title ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text(
                    l10n.myLearning,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorApp.textPrimary,
                    ),
                  ),
                ),
              ),
              // ── Review Card ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: BlocBuilder<ReviewWordBloc, ReviewWordState>(
                  builder: (context, state) {
                    return ReviewCardWidget(
                      reviewCount: state.reviewWords.length,
                      onTap: () =>
                          context.push('${Routes.words}/${Routes.wordsReview}'),
                    );
                  },
                ),
              ),
              // ── My Words card (full width) ───────────────────────────────
              SliverToBoxAdapter(
                child: MyWordsTopicCardWidget(
                  onTap: () => context.push(
                    '${Routes.words}/${Routes.wordsLevel}',
                    extra: 'my_words',
                  ),
                ),
              ),
              // ── Section title ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Text(
                    l10n.oxfordWordLists,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorApp.textPrimary,
                    ),
                  ),
                ),
              ),
              // ── Level grid (A1 → C1) ─────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1,
                  children: levels.map((level) {
                    return LevelCardWidget(
                      level: level,
                      onTap: () => context.push(
                        '${Routes.words}/${Routes.wordsLevel}',
                        extra: level.id,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
