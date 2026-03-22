import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/word/domain/domain.dart';
import 'package:daily_language/features/word/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class WordAddPage extends StatefulWidget {
  const WordAddPage({super.key});

  @override
  State<WordAddPage> createState() => _WordAddPageState();
}

class _WordAddPageState extends State<WordAddPage> {
  late final TextEditingController _wordTextController;
  late final stt.SpeechToText _speech;
  String _sttLocale = 'vi_VN';

  Account get _account => getAccountFromState(context);

  @override
  void initState() {
    super.initState();
    _wordTextController = TextEditingController();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _wordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<UserWordBloc, UserWordState>(
      listener: (context, state) {
        if (state is UserWordCreateSuccess) {
          context.read<UserWordsBloc>().add(
            UserWordsRefreshed(
              param: GetUserWordsUseCaseParams(userId: _account.uid, limit: 20)
            ),
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
          backgroundColor: ColorApp.linenWhite,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(Icons.close, color: ColorApp.darkGray),
          ),
          title: Text(
            'New Word',
            style: textTheme.titleMedium?.copyWith(color: ColorApp.darkGray),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<UserWordBloc, UserWordState>(
              builder: (context, state) {
                final isLoading = state is UserWordInProgress;
                return GestureDetector(
                  onTap: isLoading ? null : _onSave,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorApp.primary,
                            ),
                          )
                        : Text(
                            'Save',
                            style: textTheme.labelLarge?.copyWith(
                              color: ColorApp.primary,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Word Input Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Enter a word', style: textTheme.labelLarge),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sttLocale = _sttLocale == 'vi_VN' ? 'en_US' : 'vi_VN';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: ColorApp.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _sttLocale == 'vi_VN' ? 'VN' : 'EN',
                            style: textTheme.labelSmall?.copyWith(
                              color: ColorApp.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _onMicPressed,
                        icon: const Icon(Icons.mic, size: 20, color: ColorApp.taupeGray),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ColorApp.darkGray.withAlpha(20)),
                ),
                child: TextField(
                  controller: _wordTextController,
                  style: textTheme.bodySmall,
                  decoration: InputDecoration(
                    hintText: 'Type a word to add...',
                    hintStyle: textTheme.bodySmall?.copyWith(
                      color: ColorApp.taupeGray,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              PrimaryButton(onPressed: _onSave, label: 'Save Word'),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final wordText = _wordTextController.text.trim();
    if (wordText.isEmpty) {
      SnackBarHelper.showFailure(context, 'Please enter a word');
      return;
    }

    final now = DateTime.now();
    context.read<UserWordBloc>().add(
      UserWordCreated(
        param: CreateUserWordUseCaseParams(
          userId: _account.uid,
          wordId: wordText.toLowerCase(),
          word: wordText,
          repetitionCount: 0,
          wrongCount: 0,
          stage: 0,
          easeFactor: 2.5,
          interval: 1,
          lastReviewed: now,
          nextReview: now.add(const Duration(days: 1)),
        ),
      ),
    );
  }

  Future<void> _onMicPressed() async {
    DialogHelper.showMicListeningDialog(context: context);
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            setState(() {
              _wordTextController.text = result.recognizedWords;
            });
            _speech.stop();
            if (mounted) context.pop();
          }
        },
        listenFor: const Duration(seconds: 30),
        localeId: _sttLocale,
        listenOptions: stt.SpeechListenOptions(
          cancelOnError: true,
        ),
      );
    } else {
      if (mounted) {
        SnackBarHelper.showFailure(context, 'Speech recognition unavailable');
        context.pop();
      }
    }
  }
}

