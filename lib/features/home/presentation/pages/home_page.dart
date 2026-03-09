import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widget/app_retry_widget.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/account/presentation/bloc/account_bloc/account_bloc.dart';
import 'package:daily_language/features/authentication/presentation/presentation.dart';
import 'package:daily_language/features/home/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountInProgress) {
            return const AppCircularProgressIndicator();
          }
          if (state is AccountFailure) {
            return AppRetryWidget(
              onRetry: () {
                final authState = context.read<AuthenticationBloc>().state;
                if (authState is AuthenticationSuccess) {
                  context.read<AccountBloc>().add(
                    AccountCreated(
                      param: CreateAccountUseCaseParams(
                        uid: authState.user.id,
                        email: authState.user.email,
                        fullName: authState.user.username,
                        avatarUrl: authState.user.avatarUrl,
                      ),
                    ),
                  );
                }
              },
            );
          }
          if (state is AccountSuccess) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeAppBar(account: state.account),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorApp.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.lightbulb,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today\'s Prompt',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge,
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMMM d, yyyy',
                                    ).format(DateTime.now()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"What made you happy today?"',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text('Write'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: ColorApp.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.mic, size: 18),
                                  label: const Text('Speak'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorApp.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Quick Actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            QuickActionButton(
                              label: 'Text Entry',
                              icon: Icons.edit,
                              color: ColorApp.primary,
                            ),
                            QuickActionButton(
                              label: 'Voice',
                              icon: Icons.mic,
                              color: ColorApp.purple,
                            ),
                            QuickActionButton(
                              label: 'Photo',
                              icon: Icons.photo_camera,
                              color: Colors.pink,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // This Week Stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'This Week',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'View All',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: ColorApp.primary,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Words Written',
                                value: '1,247',
                                subtitle: '+18% from last week',
                                icon: Icons.book,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: StatCard(
                                title: 'New Vocabulary',
                                value: '42',
                                subtitle: '+12% from last week',
                                icon: Icons.bookmark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // // Recent Entries
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Text(
                  //             'Recent Entries',
                  //             style: Theme.of(context).textTheme.labelLarge,
                  //           ),
                  //           Text(
                  //             'See All',
                  //             style: Theme.of(context).textTheme.bodyMedium
                  //                 ?.copyWith(
                  //                   color: ColorApp.primary,
                  //                   fontSize: 12,
                  //                 ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(height: 12),
                  //       RecordCard(
                  //         record: Record(emotion: emotion, type: type, content: content, imageUrls: imageUrls, createdAt: createdAt, voiceUrl: voiceUrl, id: id, updatedAt: updatedAt),
                  //       ),
                  //       const SizedBox(height: 12),
                  //       RecordCard(
                  //         date: 'December 19',
                  //         subtitle: 'Japanese • Voice Record',
                  //         content: '',
                  //         tags: const ['Transcript', 'Practice'],
                  //         hasAudio: true,
                  //         backgroundColor: ColorApp.primary.withValues(
                  //           alpha: 0.1,
                  //         ),
                  //         badgeColor: ColorApp.primary,
                  //         badgeText: 'Voice',
                  //       ),
                  //       const SizedBox(height: 12),
                  //       RecordCard(
                  //         date: 'December 18',
                  //         subtitle: 'Korean • 2 photos',
                  //         content: '"오늘 친구들과 시장에 갔어요. 정말 재미있었어요"',
                  //         tags: const ['Translate', 'Check Grammar'],
                  //         hasImages: true,
                  //         backgroundColor: Colors.pink.withValues(alpha: 0.1),
                  //         badgeColor: Colors.pink,
                  //         badgeText: 'Images',
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  // My Vocabulary
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Vocabulary',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'Review',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: ColorApp.primary,
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '127',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.copyWith(
                                              fontSize: 24,
                                              color: Colors.black,
                                            ),
                                      ),
                                      Text(
                                        'Total saved words',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorApp.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(
                                      Icons.bookmark,
                                      color: ColorApp.primary,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  CategoryChip(
                                    label: 'Work (32)',
                                    color: Colors.red,
                                  ),
                                  CategoryChip(
                                    label: 'Travel (18)',
                                    color: ColorApp.green,
                                  ),
                                  CategoryChip(
                                    label: 'Family (24)',
                                    color: ColorApp.primary,
                                  ),
                                  CategoryChip(
                                    label: 'Food (15)',
                                    color: ColorApp.orange,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
