import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/features/word/presentation/models/level_data.dart';
import 'package:daily_language/features/word/presentation/widgets/level_card_widget.dart';
import 'package:daily_language/features/word/presentation/widgets/my_words_topic_card_widget.dart';
import 'package:daily_language/features/word/presentation/widgets/review_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WordPage extends StatelessWidget {
  const WordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Section title ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'My Learning',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorApp.textPrimary,
                  ),
                ),
              ),
            ),
            // ── Review Card ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: ReviewCardWidget(
                onTap: () =>
                    context.push('${Routes.words}/${Routes.wordsReview}'),
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
                  'Oxford Word Lists',
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
                children: _levels.map((level) {
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
    );
  }
}

const List<LevelData> _levels = [
  LevelData(
    id: 'A1',
    label: 'A1',
    subtitle: 'Beginner',
    wordCount: '500 words',
    color: ColorApp.levelA1,
    bgColor: ColorApp.levelA1Bg,
    icon: Icons.emoji_nature_rounded,
  ),
  LevelData(
    id: 'A2',
    label: 'A2',
    subtitle: 'Elementary',
    wordCount: '700 words',
    color: ColorApp.levelA2,
    bgColor: ColorApp.levelA2Bg,
    icon: Icons.local_florist_rounded,
  ),
  LevelData(
    id: 'B1',
    label: 'B1',
    subtitle: 'Intermediate',
    wordCount: '1200 words',
    color: ColorApp.levelB1,
    bgColor: ColorApp.levelB1Bg,
    icon: Icons.bolt_rounded,
  ),
  LevelData(
    id: 'B2',
    label: 'B2',
    subtitle: 'Upper-Intermediate',
    wordCount: '1500 words',
    color: ColorApp.levelB2,
    bgColor: ColorApp.levelB2Bg,
    icon: Icons.local_fire_department_rounded,
  ),
  LevelData(
    id: 'C1',
    label: 'C1',
    subtitle: 'Advanced',
    wordCount: '1000 words',
    color: ColorApp.levelC1,
    bgColor: ColorApp.levelC1Bg,
    icon: Icons.auto_awesome_rounded,
  ),
];
