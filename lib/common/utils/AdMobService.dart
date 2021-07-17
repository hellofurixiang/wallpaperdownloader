import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/utils/LogUtils.dart';

class AdMobService {
  static String logTag = 'AdMobService';

  ///横幅广告
  /*static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  static String get interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/8691691433'
      : 'ca-app-pub-3940256099942544/5135589807';

  static String get rewardedAdAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';*/

  ///android
  ///广告格式	示例广告单元 ID
  ///开屏广告	ca-app-pub-3940256099942544/3419835294
  ///横幅广告	ca-app-pub-3940256099942544/6300978111
  ///插页式广告	ca-app-pub-3940256099942544/1033173712
  ///插页式视频广告	ca-app-pub-3940256099942544/8691691433
  ///激励广告	ca-app-pub-3940256099942544/5224354917
  ///插页式激励广告	ca-app-pub-3940256099942544/5354046379
  ///原生高级广告	ca-app-pub-3940256099942544/2247696110
  ///原生高级视频广告	ca-app-pub-3940256099942544/1044960115
  static String nativeAdGeneralUnitId='ca-app-pub-3940256099942544/2247696110';
  static String nativeAdUnitId='ca-app-pub-3940256099942544/1044960115';
  ///ios
  ///广告格式	演示广告单元 ID
  ///开屏广告	ca-app-pub-3940256099942544/5662855259
  ///横幅广告	ca-app-pub-3940256099942544/2934735716
  ///插页式广告	ca-app-pub-3940256099942544/4411468910
  ///插页式视频广告	ca-app-pub-3940256099942544/5135589807
  ///激励广告	ca-app-pub-3940256099942544/1712485313
  ///插页式激励广告	ca-app-pub-3940256099942544/6978759866
  ///原生高级广告	ca-app-pub-3940256099942544/3986624511
  ///原生高级视频广告	ca-app-pub-3940256099942544/2521693316

  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  ///横幅广告
  static BannerAd createBannerAd(Function onAdLoaded,
      {AdSize adSize: AdSize.banner}) {
    BannerAd bannerAd = new BannerAd(
        size: adSize,
        adUnitId: BannerAd.testAdUnitId,
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              onAdLoaded();
              LogUtils.i(logTag, 'Ad loaded');
            },
            onAdFailedToLoad: (Ad ad, LoadAdError err) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => LogUtils.i(logTag, 'Ad opened'),
            onAdClosed: (Ad ad) {
              LogUtils.i(logTag, 'Ad closed');
              ad.dispose();
            },
            onApplicationExit: (Ad ad) {
              ad.dispose();
            }),
        request: AdRequest());
    return bannerAd;
  }

  static InterstitialAd interstitialAd;

  ///插页式广告
  static InterstitialAd createInterstitialAd(
      {Function onAdLoaded, Function onAdClosed}) {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              LogUtils.i(logTag, 'InterstitialAd loaded');
              if (onAdLoaded != null) {
                onAdLoaded();
              }
              interstitialAd.show();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError err) {
              interstitialAd.dispose();
            },
            onAdOpened: (Ad ad) => LogUtils.i(logTag, 'InterstitialAd opened'),
            onAdClosed: (Ad ad) {
              LogUtils.i(logTag, 'InterstitialAd closed');
              interstitialAd.dispose();
              if (onAdClosed != null) {
                onAdClosed();
              }
            },
            onApplicationExit: (Ad ad) {
              interstitialAd.dispose();
            }),
        request: AdRequest());
  }

  static void showInterstitialAd({Function onAdLoaded, Function onAdClosed}) {
    interstitialAd?.dispose();
    interstitialAd =
        createInterstitialAd(onAdLoaded: onAdLoaded, onAdClosed: onAdClosed);
    interstitialAd.load();
  }

  static RewardedAd rewardedAd;

  ///激励广告、视频广告
  static RewardedAd createRewardedAd(
      BuildContext context, {Function onAdLoad,Function onAdClosed}) {
    return RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
          LogUtils.i(logTag, reward.type);
          LogUtils.i(logTag, reward.amount.toString());
        },
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          LogUtils.i(logTag, 'Ad loaded.');
          //Navigator.pop(context);
          rewardedAd.show();
          if(onAdLoad!=null){
            onAdLoad();
          }
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          LogUtils.i(logTag, 'Ad failed to load: $error');
          Navigator.pop(context);
          rewardedAd.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => LogUtils.i(logTag, 'Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          //ad.
          LogUtils.i(logTag, 'Ad closed.');
          rewardedAd.dispose();
          if(onAdClosed!=null){
            onAdClosed();
          }
        },
        // Called when an ad is in the process of leaving the application.
        onApplicationExit: (Ad ad) {
          LogUtils.i(logTag, 'Left application.');
          Navigator.pop(context);
          rewardedAd.dispose();
        },
        // Called when a RewardedAd triggers a reward.
      ),
    );
  }

  static void showRewardedAd(BuildContext context, {Function onAdLoad,Function onAdClosed}) {
    rewardedAd?.dispose();
    rewardedAd = createRewardedAd(context, onAdLoad:onAdLoad,onAdClosed:onAdClosed);
    rewardedAd.load();
  }

  ///原生横幅广告
  static NativeAd createBottomNativeAd(Function onAdLoaded) {
    NativeAd nativeAd = new NativeAd(
        factoryId: 'bottomNativeAd',
        adUnitId: NativeAd.testAdUnitId,
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              onAdLoaded();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError err) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) {},
            onAdClosed: (Ad ad) {
              // LogUtils.i(logTag,'Ad closed');
              ad.dispose();
            },
            onApplicationExit: (Ad ad) {
              ad.dispose();
            }),
        request: AdRequest());
    return nativeAd;
  }

  ///原生横幅广告
  static NativeAd createLagerNativeAd(Function onAdLoaded) {
    NativeAd nativeAd = new NativeAd(
        factoryId: 'lagerNativeAd',
        adUnitId: NativeAd.testAdUnitId,
        listener: AdListener(
            onAdLoaded: (Ad ad) {
              onAdLoaded();
            },
            onAdFailedToLoad: (Ad ad, LoadAdError err) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) {},
            onAdClosed: (Ad ad) {
              // LogUtils.i(logTag,'Ad closed');
              ad.dispose();
            },
            onApplicationExit: (Ad ad) {
              ad.dispose();
            }),
        request: AdRequest());
    return nativeAd;
  }
}
