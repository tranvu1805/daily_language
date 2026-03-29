import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/widget/primary_button.dart';
import 'package:daily_language/features/grammar/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrammarCheckPage extends StatefulWidget {
  final String? initialText;

  const GrammarCheckPage({super.key, this.initialText});

  @override
  State<GrammarCheckPage> createState() => _GrammarCheckPageState();
}

class _GrammarCheckPageState extends State<GrammarCheckPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    if (widget.initialText != null && widget.initialText!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<GrammarBloc>().add(
          CorrectGrammarRequested(widget.initialText!),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      appBar: AppBar(
        title: const Text(
          'Grammar Checker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Improve your writing with AI-powered grammar check.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorApp.taupeGray, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildInputSection(),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 32),
            _buildResultSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorApp.charcoalBlue.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        maxLines: 8,
        style: const TextStyle(fontSize: 16, color: ColorApp.charcoalBlue),
        decoration: InputDecoration(
          hintText: 'Type or paste your English text here...',
          hintStyle: TextStyle(
            color: ColorApp.taupeGray.withValues(alpha: 0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        final isLoading = state is GrammarInProgress;
        return PrimaryButton(
          label: 'Check Now',
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              context.read<GrammarBloc>().add(
                CorrectGrammarRequested(_controller.text.trim()),
              );
            }
          },
          isLoading: isLoading,
        );
      },
    );
  }

  Widget _buildResultSection() {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        if (state is GrammarSuccess) {
          final correction = state.correction;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: ColorApp.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'AI Analysis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorApp.charcoalBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCorrectionCard(correction),
              const SizedBox(height: 24),
              const Text(
                'Detailed Explanation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.charcoalBlue,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorApp.cyanBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ColorApp.cyanBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  correction.explanation,
                  style: const TextStyle(
                    fontSize: 15,
                    color: ColorApp.charcoalBlue,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          );
        } else if (state is GrammarFailure) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorApp.failedRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorApp.failedRed.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: ColorApp.failedRed),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.error,
                    style: const TextStyle(color: ColorApp.failedRed),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCorrectionCard(correction) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorApp.pureWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: correction.hasErrors
              ? ColorApp.failedRed.withValues(alpha: 0.15)
              : ColorApp.green.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (correction.hasErrors) ...[
            const _LabelBadge(
              label: 'Original',
              color: ColorApp.failedRed,
              icon: Icons.close_rounded,
            ),
            const SizedBox(height: 12),
            Text(
              correction.original,
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.lineThrough,
                color: ColorApp.taupeGray.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(height: 1, thickness: 0.5),
            ),
          ],
          _LabelBadge(
            label: correction.hasErrors ? 'Improved' : 'Perfect',
            color: ColorApp.green,
            icon: Icons.check_rounded,
          ),
          const SizedBox(height: 12),
          Text(
            correction.corrected,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorApp.charcoalBlue,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _LabelBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
