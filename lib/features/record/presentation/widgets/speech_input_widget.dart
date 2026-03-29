import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechInputWidget extends StatefulWidget {
  final TextEditingController contentController;
  final TextEditingController translatedController;
  final String locale;
  final VoidCallback onLocaleToggle;

  const SpeechInputWidget({
    super.key,
    required this.contentController,
    required this.translatedController,
    required this.locale,
    required this.onLocaleToggle,
  });

  @override
  State<SpeechInputWidget> createState() => _SpeechInputWidgetState();
}

class _SpeechInputWidgetState extends State<SpeechInputWidget> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  // Recording state
  String _accumulatedText = '';
  DateTime? _recordingStartTime;
  DateTime? _lastResultTime;
  bool _isManualStop = false;
  bool _hasFinished = false;
  ValueNotifier<bool>? _micLoadingNotifier;

  @override
  void dispose() {
    _micLoadingNotifier?.dispose();
    super.dispose();
  }

  // ─── Public interface ────────────────────────────────────────────────────────

  bool get _isSilencedTooLong {
    if (_lastResultTime == null) return false;
    return DateTime.now().difference(_lastResultTime!).inSeconds >= 19;
  }

  bool get _isOverTimeLimit {
    if (_recordingStartTime == null) return false;
    return DateTime.now().difference(_recordingStartTime!).inSeconds >= 120;
  }

  void _resetState() {
    _accumulatedText = widget.contentController.text.trim();
    _recordingStartTime = DateTime.now();
    _lastResultTime = DateTime.now();
    _isManualStop = false;
    _hasFinished = false;
  }

  // ─── Recording logic ─────────────────────────────────────────────────────────

  Future<void> _onMicPressed() async {
    if (_speech.isListening) return;

    _resetState();
    _micLoadingNotifier?.dispose();
    _micLoadingNotifier = ValueNotifier<bool>(false);
    final isLoading = _micLoadingNotifier!;

    DialogHelper.showMicListeningDialog(
      context: context,
      isLoading: isLoading,
      onStop: () async {
        _isManualStop = true;
        await _speech.stop();
        _finishRecording();
      },
    );

    final available = await _speech.initialize(
      onStatus: (status) async {
        if (_hasFinished || !mounted) return;
        if (status == 'notListening' || status == 'done') {
          if (_isManualStop || _isSilencedTooLong) {
            _finishRecording();
          } else {
            // Short delay so OS releases the audio pipeline before restarting
            await Future.delayed(const Duration(milliseconds: 800));
            _startListeningSegment();
          }
        }
      },
      onError: (error) async {
        if (_hasFinished || !mounted) return;
        if (_isManualStop) {
          // error_client after _speech.stop() is expected — just finish
          _finishRecording();
          return;
        }
        if (_isSilencedTooLong) {
          _finishRecording();
        } else {
          // Transient OS error — silently restart
          await Future.delayed(const Duration(milliseconds: 800));
          _startListeningSegment();
        }
      },
    );

    if (available) {
      _startListeningSegment();
    } else {
      if (!mounted) return;
      if (Navigator.of(context).canPop()) context.pop();
      SnackBarHelper.showFailure(context, context.l10n.speechUnavailable);
    }
  }

  Future<void> _startListeningSegment() async {
    if (_isManualStop || _hasFinished || !mounted) return;
    if (_isOverTimeLimit) {
      _finishRecording();
      return;
    }

    // Proactively cancel ~2s before the 30s limit so the OS status
    // callbacks reliably fire and we can restart seamlessly.
    Future.delayed(const Duration(seconds: 28), () async {
      if (!_hasFinished && !_isManualStop && _speech.isListening) {
        await _speech.cancel();
      }
    });

    await _speech.listen(
      onResult: (result) {
        if (!mounted || _isManualStop) return;
        _lastResultTime = DateTime.now();
        final words = result.recognizedWords.trim();
        if (words.isNotEmpty) {
          widget.contentController.text = _accumulatedText.isEmpty
              ? words
              : '$_accumulatedText $words';
        }
        if (result.finalResult) {
          _accumulatedText = widget.contentController.text.trim();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 20),
      localeId: widget.locale,
      listenOptions: stt.SpeechListenOptions(cancelOnError: true),
    );
  }

  void _finishRecording() {
    if (!mounted || _hasFinished) return;
    _hasFinished = true;
    _micLoadingNotifier?.value = true;
    if (Navigator.of(context).canPop()) context.pop();

    final finalContent = widget.contentController.text.trim();
    if (finalContent.isEmpty) {
      widget.translatedController.clear();
      return;
    }

    if (widget.locale == 'vi_VN') {
      widget.translatedController.clear();
      context.read<RecordBloc>().add(
        RecordVietnameseTranslatedRequested(
          param: TranslateVietnameseToEnglishUseCaseParams(
            content: finalContent,
          ),
        ),
      );
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row: label + locale toggle + mic button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.writeThoughts, style: textTheme.labelLarge),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LocaleToggleWidget(
                  locale: widget.locale,
                  onToggle: widget.onLocaleToggle,
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: _onMicPressed,
                  icon: const Icon(
                    Icons.mic,
                    size: 20,
                    color: ColorApp.taupeGray,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Content text field
        _ContentTextField(controller: widget.contentController),

        // Translation field — shown only in VN mode
        if (widget.locale == 'vi_VN') ...[
          const SizedBox(height: 16),
          Text(context.l10n.englishTranslation, style: textTheme.labelLarge),
          const SizedBox(height: 12),
          _TranslationTextField(controller: widget.translatedController),
        ],
      ],
    );
  }
}

// ─── Sub-widgets ───────────────────────────────────────────────────────────────

class _LocaleToggleWidget extends StatelessWidget {
  final String locale;
  final VoidCallback onToggle;

  const _LocaleToggleWidget({required this.locale, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: ColorApp.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          locale == 'vi_VN' ? 'VN' : 'EN',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: ColorApp.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ContentTextField extends StatelessWidget {
  final TextEditingController controller;

  const _ContentTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorApp.darkGray.withAlpha(20)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 8,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: context.l10n.whatHappenedToday,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}

class _TranslationTextField extends StatelessWidget {
  final TextEditingController controller;

  const _TranslationTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorApp.darkGray.withAlpha(20)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        readOnly: true,
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: context.l10n.translationHint,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
