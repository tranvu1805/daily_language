import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/core/utils/widget/app_circular_progress_indicator.dart';
import 'package:daily_language/features/record/presentation/bloc/records_bloc/records_bloc.dart';
import 'package:daily_language/features/record/presentation/widgets/record_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecentRecordsSectionWidget extends StatelessWidget {
  const RecentRecordsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<RecordsBloc, RecordsState>(
      builder: (context, state) {
        if (state.status == RecordsStatus.loading && state.records.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: AppCircularProgressIndicator(),
          );
        }

        if (state.status == RecordsStatus.failure && state.records.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              state.error,
              style: textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
            ),
          );
        }

        if (state.records.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.l10n.noDiaryEntries,
              style: textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
            ),
          );
        }
        final preview = state.records.take(3).toList();
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final record = preview[index];
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
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: preview.length,
          shrinkWrap: true,
        );
      },
    );
  }
}
