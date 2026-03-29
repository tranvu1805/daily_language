import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class ReviewWordInput extends StatelessWidget {
  final String content;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isShowingAnswer;
  final bool isCorrect;
  final VoidCallback onSubmitted;
  final VoidCallback onTextUpdated;

  const ReviewWordInput({
    super.key,
    required this.content,
    required this.controller,
    required this.focusNode,
    required this.isShowingAnswer,
    required this.isCorrect,
    required this.onSubmitted,
    required this.onTextUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (isShowingAnswer) {
      final textTheme = Theme.of(context).textTheme;
      return Center(
        child: Text(
          content,
          style: textTheme.displayMedium?.copyWith(
            color: isCorrect ? Colors.green : Colors.red,
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
            if (controller.text.length > index) {
              displayChar = controller.text[index];
            }

            final textTheme = Theme.of(context).textTheme;

            return Container(
              width: 32,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: controller.text.length == index
                        ? ColorApp.primary
                        : Colors.grey.shade300,
                    width: controller.text.length == index ? 3 : 1.5,
                  ),
                ),
              ),
              child: Text(
                controller.text.length > index ? displayChar : '',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorApp.textPrimary,
                ),
              ),
            );
          }),
        ),
        Opacity(
          opacity: 0,
          child: SizedBox(
            height: 1,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              onChanged: (val) {
                if (val.length > content.length) {
                  controller.text = val.substring(0, content.length);
                }
                onTextUpdated();
              },
              onSubmitted: (_) => onSubmitted(),
            ),
          ),
        ),
      ],
    );
  }
}
