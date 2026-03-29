import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:daily_language/core/utils/widget/primary_button.dart';
import 'package:daily_language/features/grammar/presentation/bloc/grammar_bloc.dart';
import 'package:daily_language/features/grammar/presentation/widgets/widgets.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    
    return Scaffold(
      backgroundColor: ColorApp.linenWhite,
      appBar: AppBar(
        title: Text(
          l10n.grammarChecker,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
            Text(
              l10n.grammarCheckDescription,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: ColorApp.taupeGray),
            ),
            const SizedBox(height: 24),
            GrammarInputField(controller: _controller),
            const SizedBox(height: 24),
            BlocBuilder<GrammarBloc, GrammarState>(
              builder: (context, state) {
                final isLoading = state is GrammarInProgress;
                return PrimaryButton(
                  label: l10n.checkNow,
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
            ),
            const SizedBox(height: 32),
            BlocBuilder<GrammarBloc, GrammarState>(
              builder: (context, state) {
                if (state is GrammarSuccess) {
                  return GrammarAnalysisWidget(correction: state.correction);
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
                            style: textTheme.bodyMedium?.copyWith(
                              color: ColorApp.failedRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
