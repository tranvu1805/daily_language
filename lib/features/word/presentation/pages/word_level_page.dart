import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WordLevelPage extends StatefulWidget {
  /// 'my_words' | 'A1' | 'A2' | 'B1' | 'B2' | 'C1'
  final String topic;

  const WordLevelPage({super.key, required this.topic});

  @override
  State<WordLevelPage> createState() => _WordLevelPageState();
}

class _WordLevelPageState extends State<WordLevelPage> {
  late final ScrollController _scrollController;

  Account get _account => getAccountFromState(context);

  bool get _isMyWords => widget.topic == 'my_words';

  String get _title => _isMyWords ? 'My Words' : 'Oxford ${widget.topic}';

  String get _subtitle =>
      _isMyWords ? 'Your personal vocabulary' : _levelSubtitles[widget.topic] ?? '';

  static const _levelSubtitles = {
    'A1': 'Beginner · 500 words',
    'A2': 'Elementary · 700 words',
    'B1': 'Intermediate · 1200 words',
    'B2': 'Upper-Intermediate · 1500 words',
    'C1': 'Advanced · 1000 words',
  };

  static const _levelColors = {
    'my_words': ColorApp.primary,
    'A1': ColorApp.levelA1,
    'A2': ColorApp.levelA2,
    'B1': ColorApp.levelB1,
    'B2': ColorApp.levelB2,
    'C1': ColorApp.levelC1,
  };

  Color get _accentColor =>
      _levelColors[widget.topic] ?? ColorApp.primary;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    if (_isMyWords) {
      _loadWords();
    } else {
      _loadOxford();
    }
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
      if (_isMyWords) {
        _loadMore();
      } else {
        _loadMoreOxford();
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    return _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 200;
  }

  void _loadWords() {
    context.read<UserWordsBloc>().add(
      UserWordsRequested(
        param: GetUserWordsUseCaseParams(
          userId: _account.uid,
          limit: 20,
        ),
      ),
    );
  }

  void _loadMore() {
    final state = context.read<UserWordsBloc>().state;
    context.read<UserWordsBloc>().add(
      UserWordsRequested(
        param: GetUserWordsUseCaseParams(
          userId: _account.uid,
          limit: pageSize,
          lastDocId: state.lastDocId,
        ),
      ),
    );
  }

  void _loadOxford() {
    context.read<WordsBloc>().add(
      WordsRequested(
        param: GetDictionaryWordsUseCaseParams(
          level: widget.topic,
          limit: pageSize,
        ),
      ),
    );
  }

  void _loadMoreOxford() {
    final state = context.read<WordsBloc>().state;
    if (state.status == WordStatus.loading || state.hasReachedMax) return;

    context.read<WordsBloc>().add(
      WordsLoadMore(
        param: GetDictionaryWordsUseCaseParams(
          level: widget.topic,
          limit: pageSize,
          lastId: state.words.isEmpty ? null : state.words.last.content,
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    if (_isMyWords) {
      context.read<UserWordsBloc>().add(
        UserWordsRefreshed(
          param: GetUserWordsUseCaseParams(
            userId: _account.uid,
            limit: pageSize,
          ),
        ),
      );
    } else {
      _loadOxford();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      body: SafeArea(
        child: RefreshIndicator(
          color: _accentColor,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: WordLevelPageHeaderWidget(
                  title: _title,
                  subtitle: _subtitle,
                  accentColor: _accentColor,
                  onBack: () => context.pop(),
                  onAdd: _isMyWords
                      ? () => context.push(
                            '${Routes.words}/${Routes.wordsAdd}',
                          )
                      : null,
                ),
              ),
              if (_isMyWords)
                MyWordsListWidget(
                  accentColor: _accentColor,
                  onRefresh: _refresh,
                )
              else
                OxfordWordsListWidget(
                  topic: widget.topic,
                  accentColor: _accentColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
