import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/record/domain/domain.dart';
import 'package:daily_language/features/record/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecordAddPage extends StatefulWidget {
  const RecordAddPage({super.key});

  @override
  State<RecordAddPage> createState() => _RecordAddPageState();
}

class _RecordAddPageState extends State<RecordAddPage> {
  late final TextEditingController _contentController;
  String _selectedEmotion = '';
  String _selectedType = '';

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
  }

  @override
  void dispose() {
    _contentController.dispose();
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
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
                  return _EmotionChip(
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
                  return _TypeChip(
                    label: type,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedType = type),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Content Section
              Text('Write your thoughts', style: textTheme.labelLarge),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something'),
          backgroundColor: Colors.red,
        ),
      );
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
}

class _EmotionChip extends StatelessWidget {
  const _EmotionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorApp.primary.withAlpha(25) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? ColorApp.primary
                : ColorApp.darkGray.withAlpha(30),
          ),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected ? ColorApp.primary : ColorApp.darkGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ColorApp.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? ColorApp.primary
                : ColorApp.darkGray.withAlpha(30),
          ),
        ),
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: isSelected ? Colors.white : ColorApp.darkGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
