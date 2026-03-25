import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RecordAddPage extends StatefulWidget {
  const RecordAddPage({super.key});

  @override
  State<RecordAddPage> createState() => _RecordAddPageState();
}

class _RecordAddPageState extends State<RecordAddPage> {
  late final TextEditingController _contentController;
  late final TextEditingController _translatedContentController;
  String _selectedEmotion = '';
  String _selectedType = '';
  late final stt.SpeechToText _speech;
  bool _isListening = false;
  String _sttLocale = 'vi_VN';

  Account get _account => getAccountFromState(context);

  static const _emotions = [
    '😊 Happy',
    '😢 Sad',
    '😡 Angry',
    '😨 Scared',
    '😌 Calm',
    '🤔 Thinking',
  ];
  static const _types = ['Daily', 'Study', 'Work', 'Travel', 'Food', 'Other'];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _translatedContentController = TextEditingController();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _translatedContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        if (state is RecordCreateSuccess) {
          context.read<RecordsBloc>().add(
            RecordsRefreshed(
              param: GetRecordsUseCaseParams(userId: _account.uid),
            ),
          );
          context.pop();
        }
        if (state is RecordFailure) {
          SnackBarHelper.showFailure(context, state.error);
        }
        if (state is RecordTranslateSuccess) {
          _translatedContentController.text = state.translatedContent;
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
            'New Record',
            style: textTheme.titleMedium?.copyWith(color: ColorApp.darkGray),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<RecordBloc, RecordState>(
              builder: (context, state) {
                final isLoading = state is RecordInProgress;
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
              // Emotion Section
              Text('How are you feeling?', style: textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _emotions.map((emotion) {
                  final isSelected = _selectedEmotion == emotion;
                  return EmotionChip(
                    label: emotion,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedEmotion = emotion),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Type Section
              Text('Category', style: textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((type) {
                  final isSelected = _selectedType == type;
                  return TypeChip(
                    label: type,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Content Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Write your thoughts', style: textTheme.labelLarge),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sttLocale = _sttLocale == 'vi_VN' ? 'en_US' : 'vi_VN';
                            if (_sttLocale == 'en_US') {
                              _translatedContentController.clear();
                            }
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
                  controller: _contentController,
                  maxLines: 8,
                  style: textTheme.bodySmall,
                  decoration: InputDecoration(
                    hintText: 'What happened today?',
                    hintStyle: textTheme.bodySmall?.copyWith(
                      color: ColorApp.taupeGray,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              if (_sttLocale == 'vi_VN') ...[
                const SizedBox(height: 16),
                Text('English translation', style: textTheme.labelLarge),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorApp.darkGray.withAlpha(20)),
                  ),
                  child: TextField(
                    controller: _translatedContentController,
                    maxLines: 5,
                    readOnly: true,
                    style: textTheme.bodySmall,
                    decoration: InputDecoration(
                      hintText: 'Translated content will appear here',
                      hintStyle: textTheme.bodySmall?.copyWith(
                        color: ColorApp.taupeGray,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),

              // Save Button
              PrimaryButton(onPressed: _onSave, label: 'Save Record'),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      SnackBarHelper.showFailure(context, 'Please write something');
      return;
    }

    context.read<RecordBloc>().add(
      RecordCreated(
        param: CreateRecordUseCaseParams(
          userId: _account.uid,
          emotion: _selectedEmotion,
          type: _selectedType,
          content: content,
        ),
      ),
    );
  }

  Future<void> _onMicPressed() async {
    DialogHelper.showMicListeningDialog(context: context);
    setState(() { _isListening = true; });
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            final recognizedWords = result.recognizedWords.trim();
            if (!mounted) return;
            setState(() {
              _isListening = false;
            });
            _speech.stop();
            context.pop();
            if (recognizedWords.isEmpty) {
              _contentController.clear();
              _translatedContentController.clear();
              return;
            }
            if (_sttLocale == 'vi_VN') {
              _contentController.text = recognizedWords;
              _translatedContentController.clear();
              context.read<RecordBloc>().add(
                RecordVietnameseTranslatedRequested(
                  param: TranslateVietnameseToEnglishUseCaseParams(
                    content: recognizedWords,
                  ),
                ),
              );
              return;
            }
            _translatedContentController.clear();
            _contentController.text = recognizedWords;
          }
        },
        listenFor: const Duration(seconds: 30),
        localeId: _sttLocale,
        listenOptions: stt.SpeechListenOptions(
          cancelOnError: true,
        ),
      );
    } else {
      if (!mounted) return;
      setState(() { _isListening = false; });
      SnackBarHelper.showFailure(context, 'Speech recognition unavailable');
      context.pop();
    }
  }
}
