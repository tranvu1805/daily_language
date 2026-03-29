import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111'; // Android test banner id
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner id
      }
    }

    // TODO: Replace with your actual Ad unit IDs
    if (Platform.isAndroid) {
      return 'ca-app-pub-5217504969864302/1119463014';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712'; // Android test interstitial id
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910'; // iOS test interstitial id
      }
    }

    // TODO: Replace with your actual Ad unit IDs
    if (Platform.isAndroid) {
      return 'ca-app-pub-5217504969864302/6036011680';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917'; // Android test reward id
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712485313'; // iOS test reward id
      }
    }

    // TODO: Replace with your actual Ad unit IDs
    if (Platform.isAndroid) {
      return 'ca-app-pub-5217504969864302/9708602730';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
