// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAdWidget extends StatefulWidget {
  // / The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize;

  /// The AdMob ad unit to show.
  ///
  /// replace this test ad unit with your own ad unit
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-6311242713601440/1225088115'
      // ... or this one on iOS.
      : 'ca-app-pub-6311242713601440/5169036706';

  MyBannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<MyBannerAdWidget> createState() => _MyBannerAdWidgetState();
}

class _MyBannerAdWidgetState extends State<MyBannerAdWidget> {
  /// The banner ad to show. This is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: widget.adSize.width.toDouble(),
          height: widget.adSize.height.toDouble(),
          child: _bannerAd == null
              // Nothing to render yet.
              ? const Text('no ads')
              // The actual ad.
              : AdWidget(ad: _bannerAd!),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() {
    final bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd failed to load: $error');
          ad.dispose();
        },
      ),
    );

    // Start loading.
    bannerAd.load();
  }
}