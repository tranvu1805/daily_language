import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/core/utils/widgets/app_retry_widget.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OxfordWordDetailPage extends StatefulWidget {
  final Word? word;
  final UserWord? userWord;
  final bool showAddButton;

  const OxfordWordDetailPage({
    super.key,
    this.word,
    this.userWord,
    this.showAddButton = true,
  });

  @override
  State<OxfordWordDetailPage> createState() => _OxfordWordDetailPageState();
}

class _OxfordWordDetailPageState extends State<OxfordWordDetailPage> {
  Account get account => getAccountFromState(context);
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.word == null && widget.userWord != null) {
      context.read<UserWordsBloc>().add(
        UserWordDetailRequested(
          params: GetDictionaryWordByIdUseCaseParams(
            word: widget.userWord!.word,
            level: widget.userWord!.level,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    if (url.isEmpty) return;
    try {
      final uri = Uri.parse(url);
      final filename = uri.pathSegments.last;
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$filename');

      if (!await file.exists()) {
        final response = await http.get(
          uri,
          headers: {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'},
        );
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
        } else {
          throw Exception('Failed to load audio: ${response.statusCode}');
        }
      }
      await _audioPlayer.play(DeviceFileSource(file.path));
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showFailure(context, context.l10n.audioError);
      }
    }
  }

  void _addWord(Word word) {
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
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<UserWordBloc, UserWordState>(
      listener: (context, state) {
        if (state is UserWordCreateSuccess) {
          SnackBarHelper.showSuccess(context, context.l10n.wordAdded);
          context.pop();
        }
        if (state is UserWordFailure) {
          SnackBarHelper.showFailure(
            context,
            state.error.toLocalizedError(context),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorApp.linenWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            context.l10n.wordDetails,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorApp.textPrimary,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: ColorApp.textPrimary,
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<UserWordsBloc, UserWordsState>(
            builder: (context, state) {
              final word = widget.word ?? state.selectedWordDetail;
              if (word == null) {
                if (state.status == UserWordsStatus.loading) {
                  return const Center(child: AppCircularProgressIndicator());
                }
                if (state.status == UserWordsStatus.failure) {
                  return AppRetryWidget(
                    message: state.error.toLocalizedError(context),
                    onRetry: () {
                      if (widget.userWord != null) {
                        context.read<UserWordsBloc>().add(
                          UserWordDetailRequested(
                            params: GetDictionaryWordByIdUseCaseParams(
                              word: widget.userWord!.word,
                              level: widget.userWord!.level,
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
                return Center(child: Text(context.l10n.wordNotFound));
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          WordDetailHeader(
                            word: word,
                            onPlayAudio: word.audioUs.isNotEmpty
                                ? () => _playAudio(word.audioUs)
                                : null,
                          ),
                          const SizedBox(height: 24),

                          // Meanings
                          WordDetailSectionHeader(
                            title: context.l10n.englishMeaning,
                            icon: Icons.g_translate_rounded,
                          ),
                          if (word.meaningEn.isNotEmpty)
                            Text(
                              word.meaningEn,
                              style: textTheme.bodyMedium?.copyWith(
                                color: ColorApp.textSecondary,
                              ),
                            ),
                          if (word.example.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            WordDetailExampleCard(example: word.example),
                          ],
                          const SizedBox(height: 24),

                          WordDetailSectionHeader(
                            title: context.l10n.vietnameseMeaning,
                            icon: Icons.translate_rounded,
                          ),
                          if (word.meaningVi.isNotEmpty)
                            Text(
                              word.meaningVi,
                              style: textTheme.bodyMedium?.copyWith(
                                color: ColorApp.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (word.definitionVi.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              word.definitionVi,
                              style: textTheme.bodyMedium?.copyWith(
                                color: ColorApp.textSecondary,
                              ),
                            ),
                          ],

                          if (word.synonym.isNotEmpty ||
                              word.antonym.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            WordDetailSectionHeader(
                              title: context.l10n.relations,
                              icon: Icons.link_rounded,
                            ),
                            if (word.synonym.isNotEmpty)
                              WordDetailRelationList(
                                label: context.l10n.synonyms,
                                items: word.synonym,
                              ),
                            if (word.antonym.isNotEmpty) ...[
                              if (word.synonym.isNotEmpty)
                                const SizedBox(height: 12),
                              WordDetailRelationList(
                                label: context.l10n.antonyms,
                                items: word.antonym,
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Add Button
                  if (widget.showAddButton)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => _addWord(word),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorApp.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.add_circle_rounded),
                        label: Text(
                          context.l10n.addToMyWords,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
