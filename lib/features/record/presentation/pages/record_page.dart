import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widgets/app_retry_widget.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  late final ScrollController _scrollController;

  Account get _account => getAccountFromState(context);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadRecords();
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

  void _loadRecords() {
    context.read<RecordsBloc>().add(
      RecordsRequested(param: GetRecordsUseCaseParams(userId: _account.uid)),
    );
  }

  void _loadMore() {
    final state = context.read<RecordsBloc>().state;
    context.read<RecordsBloc>().add(
      RecordsRequested(
        param: GetRecordsUseCaseParams(
          userId: _account.uid,
          lastDocId: state.lastDocId,
        ),
      ),
    );
  }

  void _refresh() {
    context.read<RecordsBloc>().add(
      RecordsRefreshed(param: GetRecordsUseCaseParams(userId: _account.uid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      body: SafeArea(
        child: BlocBuilder<RecordsBloc, RecordsState>(
          builder: (context, state) {
            if (state.status == RecordsStatus.loading) {
              return const AppCircularProgressIndicator();
            }
            if (state.status == RecordsStatus.failure) {
              return AppRetryWidget(
                message: state.error.toLocalizedError(context),
                onRetry: _refresh,
              );
            }
            if (state.status == RecordsStatus.success) {
              if (state.records.isEmpty) {
                return const AppEmpty();
              }
              return ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: state.hasReachedMax
                    ? state.records.length
                    : state.records.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= state.records.length) {
                    return const AppCircularProgressIndicator();
                  }
                  final record = state.records[index];
                  return RecordCard(
                    record: record,
                    onTap: () {
                      context.push(
                        '${Routes.diary}/${Routes.diaryEdit}',
                        extra: record,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
