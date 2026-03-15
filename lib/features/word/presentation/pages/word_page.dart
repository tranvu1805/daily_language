import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WordPage extends StatefulWidget {
  const WordPage({super.key});

  @override
  State<WordPage> createState() => _WordPageState();
}

class _WordPageState extends State<WordPage> {
  late final ScrollController _scrollController;

  Account get _account => getAccountFromState(context);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadWords();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll - 200;
  }

  void _loadWords() {
    context.read<WordsBloc>().add(
      WordsRequested(param: GetWordsUseCaseParams(userId: _account.uid)),
    );
  }

  void _loadMore() {
    final state = context.read<WordsBloc>().state;
    context.read<WordsBloc>().add(
      WordsRequested(
        param: GetWordsUseCaseParams(
          userId: _account.uid,
          lastDocId: state.lastDocId,
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    context.read<WordsBloc>().add(
      WordsRefreshed(param: GetWordsUseCaseParams(userId: _account.uid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fafb),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xff6366f1),
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    WordPageHeaderWidget(),
                    WordAutoExtractWidget(),
                    WordStatisticsWidget(),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: WordListHeaderWidget(
                  onAddPressed: () {
                    context.push('${Routes.words}/${Routes.wordsAdd}');
                  },
                ),
              ),
              BlocBuilder<WordsBloc, WordsState>(
                builder: (context, state) {
                  if (state.status == WordsStatus.loading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: AppCircularProgressIndicator()),
                      ),
                    );
                  }
                  if (state.status == WordsStatus.failure) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: AppRetryWidget(
                          message: state.error,
                          onRetry: _refresh,
                        ),
                      ),
                    );
                  }
                  if (state.status == WordsStatus.success) {
                    if (state.words.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('No words added yet.')),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverList.separated(
                        itemCount: state.hasReachedMax
                            ? state.words.length
                            : state.words.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.words.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: AppCircularProgressIndicator(),
                              ),
                            );
                          }
                          final word = state.words[index];
                          return WordCard(
                            word: word,
                            onTap: () {
                              // TODO: Navigate to word details
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
