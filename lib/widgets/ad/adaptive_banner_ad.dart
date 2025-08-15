// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdaptiveBannerAd extends StatefulWidget {
//   @override
//   _AdaptiveBannerAdState createState() => _AdaptiveBannerAdState();

//   final double height;

//   AdaptiveBannerAd({required this.height});
// }

// class _AdaptiveBannerAdState extends State<AdaptiveBannerAd> {
//   BannerAd? _bannerAd;
//   bool _isLoaded = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadAdaptiveBannerAd(); // Gọi trong didChangeDependencies thay vì initState
//   }

//   void _loadAdaptiveBannerAd() {
//     final double screenWidth =
//         MediaQuery.of(context).size.width; // Lấy width tại đây

//     final AdSize adSize =
//         AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
//             screenWidth.toInt());

//     _bannerAd = BannerAd(
//       adUnitId: 'ca-app-pub-3940256099942544/9214589741', // ID test của Google
//       size: adSize,
//       request: AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _isLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           print('error: $error');
//           ad.dispose();
//         },
//       ),
//     )..load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoaded
//         ? Container(
//             width: double.infinity,
//             height: widget.height,
//             child: AdWidget(ad: _bannerAd!),
//           )
//         : SizedBox(
//             height: widget.height,
//           );
//   }

//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }
// }
