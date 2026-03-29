import 'package:daily_language/core/constants/colors_app.dart';
import 'package:flutter/material.dart';

class ReviewCardWidget extends StatelessWidget {
  final VoidCallback onTap;
  final int reviewCount;

  const ReviewCardWidget({
    super.key,
    required this.onTap,
    this.reviewCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasReview = reviewCount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: hasReview
                  ? [ColorApp.primary, const Color(0xFF6E85E8)]
                  : [ColorApp.taupeGray.withValues(alpha: 0.2), ColorApp.taupeGray.withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: hasReview
                ? [
                    BoxShadow(
                      color: ColorApp.primary.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: hasReview
                      ? Colors.white.withValues(alpha: 0.2)
                      : ColorApp.taupeGray.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: hasReview ? Colors.white : ColorApp.taupeGray,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Review',
                      style: textTheme.titleMedium?.copyWith(
                        color: hasReview ? Colors.white : ColorApp.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasReview
                          ? 'You have $reviewCount words ready to review!'
                          : 'No words to review today. Keep learning!',
                      style: textTheme.bodySmall?.copyWith(
                        color: hasReview
                            ? Colors.white.withValues(alpha: 0.8)
                            : ColorApp.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: hasReview ? Colors.white : ColorApp.taupeGray,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
