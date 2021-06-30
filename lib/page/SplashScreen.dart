import 'dart:async';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/page/MainPage.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  InterstitialAd interstitialAd;

  startTime() async {
    ///设置启动图生效时间
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, showInterstitialAd);
  }

  void showInterstitialAd() {
    AdMobService.showInterstitialAd(
        onAdLoaded: () {},
        onAdClosed: () {
          navigationPage();
        });
  }

  void navigationPage() {
    //路由跳转
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (route) => route == null); //跳转下一页 并把动画结束
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int rng = new Random().nextInt(5);
    String path = 'assets/ic_splash_$rng.webp';

    return Stack(
      fit: StackFit.expand,
      children: [
        ExtendedImage.asset(
          path,
          fit: BoxFit.fill,
          loadStateChanged: (ExtendedImageState state) {
            if (state.extendedImageLoadState == LoadState.completed) {
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                fit: BoxFit.fill,
              );
            } else {
              return Container();
            }
          },
        ),
        Positioned(
          top: 50,
          child: Container(
            alignment: Alignment.center,
            width: CommonUtil.getScreenWidth(context),
            child: Text(
              Config.versionName,
              style: TextStyle(
                fontSize: SetConstants.middleTextSize,
                color: SetColors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          child: Container(
            alignment: Alignment.center,
            width: CommonUtil.getScreenWidth(context),
            child: Text(
              Config.appName,
              style: TextStyle(
                fontSize: SetConstants.veryLagerTextSize,
                color: SetColors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
