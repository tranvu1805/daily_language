import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/utils.dart';
import 'package:daily_language/features/account/domain/domain.dart';
import 'package:daily_language/features/word/presentation/bloc/review_word_bloc/review_word_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReviewWordPage extends StatefulWidget {
  const ReviewWordPage({super.key});

  @override
  State<ReviewWordPage> createState() => _ReviewWordPageState();
}

class _ReviewWordPageState extends State<ReviewWordPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Account get account => getAccountFromState(context);

  @override
  void initState() {
    super.initState();
    context.read<ReviewWordBloc>().add(ReviewWordLoaded(userId: account.uid));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isEmpty) return;
    context.read<ReviewWordBloc>().add(
      ReviewWordAnswerSubmitted(answer: _controller.text),
    );
  }

  void _next() {
    _controller.clear();
    context.read<ReviewWordBloc>().add(ReviewWordNextRequested());
    // Auto focus after a short delay to let animations/rebuild finish
    Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<ReviewWordBloc, ReviewWordState>(
      listener: (context, state) {
        if (state.status == ReviewWordStatus.finished) {
           _showCompletionDialog();
        }
        if (state.error.isNotEmpty && state.status == ReviewWordStatus.failure) {
            SnackBarHelper.showFailure(context, state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorApp.linenWhite,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Review Words',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorApp.textPrimary,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              color: ColorApp.textPrimary,
              onPressed: () => context.pop(),
            ),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReviewWordState state) {
    if (state.status == ReviewWordStatus.loading && state.reviewWords.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ReviewWordStatus.failure && state.reviewWords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Failed to load words: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ReviewWordBloc>().add(ReviewWordLoaded(userId: account.uid)),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.status == ReviewWordStatus.finished) {
        return const SizedBox.shrink();
    }

    if (state.currentDictionaryWord == null) {
        return const Center(child: CircularProgressIndicator());
    }

    final word = state.currentDictionaryWord!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Word ${state.currentIndex + 1} of ${state.reviewWords.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorApp.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LinearProgressIndicator(
                  value: (state.currentIndex + 1) / state.reviewWords.length,
                  backgroundColor: ColorApp.primary.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation(ColorApp.primary),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: ColorApp.primary, size: 32),
                const SizedBox(height: 16),
                Text(
                  'Definition',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: ColorApp.textSecondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  word.meaningEn,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorApp.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (state.isShowingAnswer && word.meaningVi.isNotEmpty) ...[
                    const Divider(height: 32),
                    Text(
                      word.meaningVi,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorApp.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 48),

          _buildWordInput(word.content, state),
          
          const SizedBox(height: 48),

          if (state.isShowingAnswer) ...[
             _buildFeedback(state),
             const SizedBox(height: 24),
             ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: ColorApp.primary.withValues(alpha: 0.3),
                ),
                child: const Text('Next Word', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             ),
          ] else ...[
             ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorApp.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  shadowColor: ColorApp.primary.withValues(alpha: 0.3),
                ),
                child: const Text('Check Answer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             ),
          ],
        ],
      ),
    );
  }

  Widget _buildWordInput(String content, ReviewWordState state) {
    if (state.isShowingAnswer) {
        return Center(
          child: Text(
            content,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: state.isCorrect ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        );
    }

    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(content.length, (index) {
            final char = content[index];
            if (char == ' ') return const SizedBox(width: 20);
            
            String displayChar = '_';
            if (_controller.text.length > index) {
                displayChar = _controller.text[index];
            }

            return Container(
              width: 32,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _controller.text.length == index ? ColorApp.primary : Colors.grey.shade300,
                    width: _controller.text.length == index ? 3 : 1.5,
                  ),
                ),
              ),
              child: Text(
                _controller.text.length > index ? displayChar : '',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ColorApp.textPrimary),
              ),
            );
          }),
        ),
        
        Opacity(
          opacity: 0,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            onChanged: (val) {
                if (val.length > content.length) {
                    _controller.text = val.substring(0, content.length);
                }
                setState(() {});
            },
            onSubmitted: (_) => _submit(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback(ReviewWordState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: state.isCorrect ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            state.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: state.isCorrect ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Text(
            state.isCorrect ? 'Correct! Keep it up!' : 'Oops! The correct word is above.',
            style: TextStyle(
              color: state.isCorrect ? Colors.green.shade700 : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Review Completed! 🥳', textAlign: TextAlign.center),
        content: const Text(
          'You have finished all your reviews for now. Great job!',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorApp.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back to My Learning'),
            ),
          ),
        ],
      ),
    );
  }
}
