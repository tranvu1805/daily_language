import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/bloc/user_word_bloc/user_word_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class OxfordWordDetailPage extends StatefulWidget {
  final Word word;
  final bool showAddButton;

  const OxfordWordDetailPage({
    super.key,
    required this.word,
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
        SnackBarHelper.showFailure(context, 'Could not play audio');
      }
    }
  }

  void _addWord() {
    final now = DateTime.now();
    final wordId = widget.word.id.toLowerCase().replaceAll(' ', '_');
    context.read<UserWordBloc>().add(
      UserWordCreated(
        param: CreateUserWordUseCaseParams(
          userId: account.uid,
          wordId: wordId,
          level: widget.word.level,
          word: widget.word.content,
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
    final word = widget.word;
    return BlocListener<UserWordBloc, UserWordState>(
      listener: (context, state) {
        if (state is UserWordCreateSuccess) {
          SnackBarHelper.showSuccess(
            context,
            'Word ${widget.word.content} to My Words',
          );
          context.pop();
        }
        if (state is UserWordFailure) {
          SnackBarHelper.showFailure(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: ColorApp.linenWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Word Details',
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              word.content,
                              style: textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorApp.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  word.pronunciation,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: ColorApp.textSecondary,
                                  ),
                                ),
                                if (word.audioUs.isNotEmpty) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () => _playAudio(word.audioUs),
                                    icon: const Icon(
                                      Icons.volume_up_rounded,
                                      color: ColorApp.primary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildChip(
                                  word.type,
                                  ColorApp.cyanBlue,
                                  ColorApp.charcoalBlue,
                                  textTheme,
                                ),
                                _buildChip(
                                  word.level.toUpperCase(),
                                  ColorApp.lightOrange,
                                  ColorApp.orange,
                                  textTheme,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Meanings
                      _buildSectionHeader(
                        'English Meaning',
                        Icons.g_translate_rounded,
                        textTheme,
                      ),
                      _buildText(word.meaningEn, textTheme),
                      if (word.example.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildExample(word.example, textTheme),
                      ],
                      const SizedBox(height: 24),
                      _buildSectionHeader(
                        'Vietnamese Meaning',
                        Icons.translate_rounded,
                        textTheme,
                      ),
                      _buildText(word.meaningVi, textTheme, isBold: true),
                      if (word.definitionVi.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        _buildText(word.definitionVi, textTheme),
                      ],

                      if (word.synonym.isNotEmpty ||
                          word.antonym.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'Relations',
                          Icons.link_rounded,
                          textTheme,
                        ),
                        if (word.synonym.isNotEmpty)
                          _buildRelationList(
                            'Synonyms:',
                            word.synonym,
                            textTheme,
                          ),
                        if (word.antonym.isNotEmpty) ...[
                          if (word.synonym.isNotEmpty)
                            const SizedBox(height: 12),
                          _buildRelationList(
                            'Antonyms:',
                            word.antonym,
                            textTheme,
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
                    onPressed: _addWord,
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
                      'Add to My Words',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
    String label,
    Color bgColor,
    Color textColor,
    TextTheme textTheme,
  ) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorApp.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorApp.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text, TextTheme textTheme, {bool isBold = false}) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Text(
      text,
      style: textTheme.bodyMedium?.copyWith(
        color: ColorApp.textSecondary,
        fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildExample(String example, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorApp.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorApp.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.format_quote_rounded,
            size: 20,
            color: ColorApp.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              example,
              style: textTheme.bodyMedium?.copyWith(
                color: ColorApp.textPrimary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationList(
    String label,
    List<String> items,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: ColorApp.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (e) => Text(
                    e,
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorApp.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
