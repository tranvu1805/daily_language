import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../helper/admob_service.dart';
import 'primary_button.dart';

class RewardAdWidget extends StatelessWidget {
  final Function(RewardItem) onRewardEarned;
  final VoidCallback? onAdClosed;
  final String label;

  const RewardAdWidget({
    super.key,
    required this.onRewardEarned,
    this.label = 'Watch Ad for Reward',
    this.onAdClosed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: label,
      onPressed: () {
        AdMobService().showRewardedAd(
          onUserEarnedReward: onRewardEarned,
          onAdClosed: onAdClosed,
        );
      },
    );
  }
}
