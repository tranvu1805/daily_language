import 'package:daily_language/core/constants/colors_app.dart';
import 'package:daily_language/core/utils/extension/extension_method.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReviewCompletionDialog extends StatelessWidget {
  const ReviewCompletionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(l10n.reviewCompleted, textAlign: TextAlign.center),
      content: Text(
        l10n.reviewFinishedMessage,
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              context.pop(); // Close dialog
              context.pop(); // Go back home/pre-page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.backToLearning),
          ),
        ),
      ],
    );
  }
}
