import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///横幅广告页面
class BannerAdWidget extends StatefulWidget {
  @override
  BannerAdWidgetState createState() => new BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget>
    with TickerProviderStateMixin {
  //double width = window.physicalSize.width;
  //double height = window.physicalSize.height;

  @override
  void initState() {
    super.initState();

    //print('width:'+((width * 0.5).toInt() - 20).toString());
    //print('height'+((height * 0.5 - 170).toInt()).toString());

    /*bannerAd = AdMobService.createBannerAd(
      () {
        setState(() {
          _isAdLoaded = true;
        });
      },
      adSize: AdSize.mediumRectangle,
      //AdSize.fullBanner
      */ /*AdSize(
            width: (width * 0.5 - 50).toInt(),
            height: (height * 0.5 - 200).toInt())*/ /*
    );*/

    bannerAd = AdMobService.createLagerNativeAd(() {
      setState(() {
        _isAdLoaded = true;
      });
    });

    bannerAd.load();
  }

  bool _isAdLoaded = false;

  //BannerAd bannerAd;

  NativeAd bannerAd;

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
    GlobalInfo.instance.setShowBannerAdState(0);
    GlobalInfo.instance.setBannerAd(null);
  }

  @override
  Widget build(BuildContext context) {
    //print('width1:'+width.toString());
    //print('height1:'+height.toString());
    double width = CommonUtil.getScreenWidth(context);
    double height = CommonUtil.getScreenHeight(context);
    //print('width2:'+width.toString());
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Container(
        alignment: Alignment.topCenter,
        //width: width,
        //color: SetColors.lightGray,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 100.0,
                width: width,
                alignment: Alignment.centerRight,
                child: Container(
                  height: 60.0,
                  width: width * 0.65,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 4.0, right: 4.0),
                  decoration: BoxDecoration(
                    color: SetColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 80.0,
                        child: Image.asset(
                          'assets/ic_launcher.png',
                          //color: SetColors.white,
                          width: 80.0,
                          height: 80.0,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //height: 100.0,
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Continue to use the app',
                                      style: TextStyle(
                                          color: SetColors.black,
                                          fontSize:
                                              SetConstants.normalTextSize)),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(ConstantConfig.appName,
                                      style: TextStyle(
                                          color: SetColors.black,
                                          fontSize:
                                              SetConstants.normalTextSize)),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('(background)',
                                      style: TextStyle(
                                          color: SetColors.black,
                                          fontSize:
                                              SetConstants.normalTextSize)),
                                ),
                              ),
                              //Container(child: Text('Wallpager hd'),),
                            ],
                          ),
                        ),
                      ),
                      _isAdLoaded
                          ? GestureDetector(
                              onTap: () {
                                //Navigator.pop(context);

                                Navigator.of(context).pop();
                              },
                              child: Container(
                                //height: 100.0,
                                color: SetColors.transparent,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(left: 15.0),
                                child: new Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.lightBlueAccent,
                                  size: 30.0,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(SetColors.mainColor),
                                strokeWidth: 2.5,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _isAdLoaded
                    ? Container(
                        alignment: Alignment.center,
                        color: SetColors.white,
                        width: width,
                        height: height - 150,
                        child: Container(
                          alignment: Alignment.center,
                          color: SetColors.darkGrey,
                          width: width - 20,
                          height: height - 200,
                          child: Container(
                            alignment: Alignment.center,
                            color: SetColors.white,
                            width: width - 20,
                            height: height - 200,
                            child: AdWidget(ad: bannerAd),
                          ),
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
