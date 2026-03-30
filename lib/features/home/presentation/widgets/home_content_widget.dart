import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/home/presentation/widgets/home_app_bar.dart';
import 'package:daily_language/features/home/presentation/widgets/home_section_header_widget.dart';
import 'package:daily_language/features/home/presentation/widgets/my_vocabulary_section_widget.dart';
import 'package:daily_language/features/home/presentation/widgets/recent_records_section_widget.dart';
import 'package:daily_language/features/home/presentation/widgets/today_prompt_card_widget.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Rendered only after [AccountBloc] confirms [AccountSuccess].
/// Receives the resolved [account] so data loading is always safe.
class HomeContentWidget extends StatefulWidget {
  final Account account;

  const HomeContentWidget({super.key, required this.account});

  @override
  State<HomeContentWidget> createState() => _HomeContentWidgetState();
}

class _HomeContentWidgetState extends State<HomeContentWidget> {
  @override
  void initState() {
    super.initState();
    _loadDataIfNeeded();
  }

  void _loadDataIfNeeded() {
    final recordsState = context.read<RecordsBloc>().state;
    if (recordsState.status == RecordsStatus.initial) {
      context.read<RecordsBloc>().add(
        RecordsRequested(
          param: GetRecordsUseCaseParams(userId: widget.account.uid),
        ),
      );
    }

    final wordsState = context.read<UserWordsBloc>().state;
    if (wordsState.status == UserWordsStatus.initial) {
      context.read<UserWordsBloc>().add(
        UserWordsRequested(
          param: GetUserWordsUseCaseParams(
            userId: widget.account.uid,
            limit: 20,
          ),
        ),
      );
    }

    final reviewState = context.read<ReviewWordBloc>().state;
    if (reviewState.status == ReviewWordStatus.initial) {
      context.read<ReviewWordBloc>().add(ReviewWordLoaded(userId: widget.account.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<RecordsBloc>().add(
              RecordsRefreshed(
                param: GetRecordsUseCaseParams(userId: widget.account.uid),
              ),
            );
        context.read<UserWordsBloc>().add(
              UserWordsRequested(
                param: GetUserWordsUseCaseParams(
                  userId: widget.account.uid,
                  limit: 20,
                ),
              ),
            );
        context.read<ReviewWordBloc>().add(
              ReviewWordLoaded(userId: widget.account.uid),
            );
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppBar(account: widget.account),
            const SizedBox(height: 20),
            const TodayPromptCardWidget(),
            const SizedBox(height: 8),
            BlocBuilder<ReviewWordBloc, ReviewWordState>(
              builder: (context, state) {
                return ReviewCardWidget(
                  reviewCount: state.reviewWords.length,
                  onTap: () =>
                      context.push('${Routes.words}/${Routes.wordsReview}'),
                );
              },
            ),
            const SizedBox(height: 24),
            HomeSectionHeaderWidget(
              title: l10n.recentDiary,
              actionLabel: l10n.seeAll,
              onActionTap: () => context.go(Routes.diary),
            ),
            const SizedBox(height: 12),
            const RecentRecordsSectionWidget(),
            const SizedBox(height: 24),
            HomeSectionHeaderWidget(
              title: l10n.myVocabulary,
              actionLabel: l10n.review,
              onActionTap: () => context.go(Routes.words),
            ),
            const SizedBox(height: 12),
            const MyVocabularySectionWidget(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
