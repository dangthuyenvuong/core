// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:flutter/material.dart';

// class RewardedAdManager {
//   RewardedAd? _rewardedAd;

//   void loadAd() {
//     RewardedAd.load(
//       adUnitId: 'ca-app-pub-3940256099942544/5224354917', // ID test
//       request: const AdRequest(),
//       rewardedAdLoadCallback: RewardedAdLoadCallback(
//         onAdLoaded: (RewardedAd ad) {
//           _rewardedAd = ad;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           debugPrint('Failed to load rewarded ad: $error');
//         },
//       ),
//     );
//   }

//   void showAd(VoidCallback onRewardEarned) {
//     if (_rewardedAd != null) {
//       _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (RewardedAd ad) {
//           ad.dispose();
//           loadAd(); // Tải lại quảng cáo mới
//         },
//       );

//       _rewardedAd!.show(
//           onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//         onRewardEarned();
//       });

//       _rewardedAd = null;
//     } else {
//       debugPrint("Ad not loaded yet");
//     }
//   }
// }
