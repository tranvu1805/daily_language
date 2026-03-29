import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/route/routes.dart';
import 'package:daily_language/core/utils/helper/notification_helper.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/presentation/presentation.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecordEditPage extends StatefulWidget {
  final Record record;

  const RecordEditPage({super.key, required this.record});

  @override
  State<RecordEditPage> createState() => _RecordEditPageState();
}

class _RecordEditPageState extends State<RecordEditPage> {
  late final TextEditingController _contentController;
  late final TextEditingController _translatedContentController;
  late String _selectedEmotion;
  late String _selectedType;
  String _sttLocale = 'en_US';

  Account get _account => getAccountFromState(context);

  @override
  void initState() {
    super.initState();
    final initialLocale = widget.record.vietnameseContent.isNotEmpty
        ? 'vi_VN'
        : 'en_US';
    _sttLocale = initialLocale;

    _contentController = TextEditingController(
      text: initialLocale == 'vi_VN'
          ? widget.record.vietnameseContent
          : widget.record.englishContent,
    );
    _translatedContentController = TextEditingController(
      text: initialLocale == 'vi_VN' ? widget.record.englishContent : '',
    );
    _selectedEmotion = widget.record.emotion;
    _selectedType = widget.record.type;
  }

  @override
  void dispose() {
    _contentController.dispose();
    _translatedContentController.dispose();
    super.dispose();
  }

  void _onLocaleToggle() {
    setState(() {
      _sttLocale = _sttLocale == 'vi_VN' ? 'en_US' : 'vi_VN';
      if (_sttLocale == 'en_US') {
        _translatedContentController.clear();
      }
    });
  }

  void _onAIReviewPressed({required String languageCode}) {
    if (_sttLocale == 'vi_VN') {
      SnackBarHelper.showFailure(context, context.l10n.aiOnlyEnglish);
      return;
    }

    final content = _contentController.text.trim();
    if (content.isEmpty) {
      SnackBarHelper.showFailure(context, context.l10n.enterTextReview);
      return;
    }

    context.push(Routes.diary + Routes.grammar, extra: (content, languageCode));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final languageCode = Localizations.localeOf(context).languageCode;

    return BlocListener<RecordBloc, RecordState>(
      listener: (context, state) {
        if (state is RecordUpdateSuccess) {
          context.read<RecordsBloc>().add(
            RecordsRefreshed(
              param: GetRecordsUseCaseParams(userId: _account.uid),
            ),
          );
          context.read<AccountBloc>().add(
            AccountStreakUpdated(account: _account),
          );
          sl<NotificationHelper>().scheduleDailyReminder(forceTomorrow: true);
          context.pop();
        }
        if (state is RecordFailure) {
          SnackBarHelper.showFailure(
            context,
            state.error.toLocalizedError(context),
          );
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
            l10n.editRecord,
            style: textTheme.titleLarge?.copyWith(
              color: ColorApp.darkGray,
              fontWeight: FontWeight.bold,
            ),
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
                        : Center(
                            child: Text(
                              l10n.update,
                              style: textTheme.labelLarge?.copyWith(
                                color: ColorApp.primary,
                                fontWeight: FontWeight.bold,
                              ),
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
              Text(
                l10n.emotionQuestion,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorApp.charcoalBlue,
                ),
              ),
              const SizedBox(height: 12),
              EmotionSelector(
                selectedEmotion: _selectedEmotion,
                onEmotionSelected: (emotion) =>
                    setState(() => _selectedEmotion = emotion),
              ),
              const SizedBox(height: 24),

              // Type Section
              Text(
                l10n.category,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorApp.charcoalBlue,
                ),
              ),
              const SizedBox(height: 12),
              CategorySelector(
                selectedCategory: _selectedType,
                onCategorySelected: (category) =>
                    setState(() => _selectedType = category),
              ),
              const SizedBox(height: 24),

              // Speech Input (mic + content + translation)
              SpeechInputWidget(
                contentController: _contentController,
                translatedController: _translatedContentController,
                locale: _sttLocale,
                onLocaleToggle: _onLocaleToggle,
              ),
              const SizedBox(height: 32),

              Center(
                child: PrimaryButton(
                  onPressed: _onSave,
                  label: l10n.updateRecord,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            heroTag: 'ai_review_edit',
            onPressed: () => _onAIReviewPressed(languageCode: languageCode),
            backgroundColor: ColorApp.primary,
            shape: const CircleBorder(),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final englishContent = _sttLocale == 'en_US'
        ? _contentController.text.trim()
        : _translatedContentController.text.trim();
    final vietnameseContent = _sttLocale == 'vi_VN'
        ? _contentController.text.trim()
        : '';

    if (englishContent.isEmpty && vietnameseContent.isEmpty) {
      SnackBarHelper.showFailure(context, context.l10n.emptyError);
      return;
    }

    context.read<RecordBloc>().add(
      RecordUpdated(
        param: UpdateRecordUseCaseParams(
          id: widget.record.id,
          userId: _account.uid,
          emotion: _selectedEmotion,
          type: _selectedType,
          englishContent: englishContent,
          vietnameseContent: vietnameseContent,
        ),
      ),
    );
  }
}
