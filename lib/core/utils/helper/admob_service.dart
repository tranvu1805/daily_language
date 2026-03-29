import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class AdMobService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _numInterstitialLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;

  static const int maxFailedLoadAttempts = 3;

  // Singleton pattern for easy usage anywhere in the app
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  /// Initialize Interstitial Ad
  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('InterstitialAd loaded.');
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  /// Show Interstitial Ad
  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      if (onAdDismissed != null) onAdDismissed();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd(); // Reload for next time
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd(); // Reload for next time
        if (onAdDismissed != null) onAdDismissed();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

  /// Initialize Rewarded Ad
  void createRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('RewardedAd loaded.');
          _rewardedAd = ad;
          _numRewardedLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
            createRewardedAd();
          }
        },
      ),
    );
  }

  /// Show Rewarded Ad
  void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded before loaded.');
      if (onAdClosed != null) onAdClosed();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd(); // Reload for next time
        if (onAdClosed != null) onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd(); // Reload for next time
        if (onAdClosed != null) onAdClosed();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
        onUserEarnedReward(reward);
      },
    );
    _rewardedAd = null;
  }

  /// Initial loads all ads
  void loadAllAds() {
    createInterstitialAd();
    createRewardedAd();
  }
}
