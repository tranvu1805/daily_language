import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum SnackBarType { success, failure }

class SnackBarHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.success);
  }

  static void showFailure(BuildContext context, String message) {
    _showSnackBar(context, message, SnackBarType.failure);
  }

  static void showTopSuccess(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: message,
        backgroundColor: ColorApp.primary,
      ),
    );
  }

  static void showTopFailure(BuildContext context, String message) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: message,
        backgroundColor: ColorApp.failedRed,
      ),
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message,
    SnackBarType type,
  ) {
    final backgroundColor =
        type == SnackBarType.success ? ColorApp.primary : ColorApp.failedRed;
    final textTheme = Theme.of(context).textTheme;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
