import 'package:daily_language/core/constants/app.dart';
import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
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

  String _getTitle(BuildContext context) =>
      _isMyWords ? context.l10n.myWords : context.l10n.oxfordTopic(widget.topic);

  String _getSubtitle(BuildContext context) {
    if (_isMyWords) return context.l10n.personalVocabulary;
    final l10n = context.l10n;
    switch (widget.topic) {
      case 'A1':
        return l10n.levelWordsCount(l10n.beginner, 500);
      case 'A2':
        return l10n.levelWordsCount(l10n.elementary, 700);
      case 'B1':
        return l10n.levelWordsCount(l10n.intermediate, 1200);
      case 'B2':
        return l10n.levelWordsCount(l10n.upperIntermediate, 1500);
      case 'C1':
        return l10n.levelWordsCount(l10n.advanced, 1000);
      default:
        return '';
    }
  }

  static const _levelColors = {
    'my_words': ColorApp.primary,
    'A1': ColorApp.levelA1,
    'A2': ColorApp.levelA2,
    'B1': ColorApp.levelB1,
    'B2': ColorApp.levelB2,
    'C1': ColorApp.levelC1,
  };

  Color get _accentColor => _levelColors[widget.topic] ?? ColorApp.primary;

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
        param: GetUserWordsUseCaseParams(userId: _account.uid, limit: 20),
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
    return BlocListener<UserWordBloc, UserWordState>(
      listener: (context, state) {
        if (state is UserWordCreateSuccess) {
          SnackBarHelper.showSuccess(
            context,
            context.l10n.addedWordToMyWords(state.word),
          );
          // Global refresh of UserWordsBloc to ensure My Words list is updated everywhere
          context.read<UserWordsBloc>().add(
            UserWordsRefreshed(
              param: GetUserWordsUseCaseParams(
                userId: _account.uid,
                limit: pageSize,
              ),
            ),
          );
        } else if (state is UserWordFailure) {
          SnackBarHelper.showFailure(context, state.error);
        }
      },
      child: Scaffold(
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
                    title: _getTitle(context),
                    subtitle: _getSubtitle(context),
                    accentColor: _accentColor,
                    onBack: () => context.pop(),
                    onAdd: _isMyWords
                        ? () =>
                              context.push('${Routes.words}/${Routes.wordsAdd}')
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
      ),
    );
  }
}
