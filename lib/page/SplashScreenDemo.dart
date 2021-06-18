import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/page/MainPage.dart';

class SplashScreenDemo extends StatefulWidget {
  SplashScreenDemo({Key key}) : super(key: key);

  @override
  _SplashScreenDemoState createState() => _SplashScreenDemoState();
}

class _SplashScreenDemoState extends State<SplashScreenDemo> {
  startTime() async {
    ///设置启动图生效时间
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainPage()),
        (route) => route == null);
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

    return Scaffold(
      backgroundColor: SetColors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/ic_splash_$rng.webp',
              fit: BoxFit.fill, scale: 2.0),
          Positioned(
            top: 50,
            child: Container(
              alignment: Alignment.center,
              width: CommonUtil.getScreenWidth(context),
              child: Text(
                Config.versionName,
                style: TextStyle(
                  fontSize: SetConstants.veryLagerTextSize,
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
      ),
    );
  }
}
