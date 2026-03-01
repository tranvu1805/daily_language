import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  DialogHelper._();

  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color confirmColor = ColorApp.primary,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: ColorApp.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: textTheme.labelLarge?.copyWith(fontSize: 18)),
              const SizedBox(height: 12),
              Text(
                message,
                style: textTheme.bodySmall?.copyWith(color: ColorApp.taupeGray),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: ColorApp.pureWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorApp.darkGray.withAlpha(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            cancelText,
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: confirmColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            confirmText,
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
