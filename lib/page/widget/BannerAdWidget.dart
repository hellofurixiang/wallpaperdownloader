import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/page/AdMobService.dart';

///横幅广告页面
class BannerAdWidget extends StatefulWidget {
  @override
  BannerAdWidgetState createState() => new BannerAdWidgetState();
}

class BannerAdWidgetState extends State<BannerAdWidget>
    with TickerProviderStateMixin {
  double width = window.physicalSize.width;
  double height = window.physicalSize.height;

  @override
  void initState() {
    super.initState();

    //print('width:'+((width * 0.5).toInt() - 20).toString());
    //print('height'+((height * 0.5 - 170).toInt()).toString());

    bannerAd = AdMobService.createBannerAd(
        adSize: AdSize(
            width: (width * 0.5-10).toInt(),
            height: (height * 0.5 - 170).toInt()));
  }

  BannerAd bannerAd;

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
    GlobalInfo.instance.setShowBannerAdState(0);
  }

  @override
  Widget build(BuildContext context) {
    //print('width1:'+width.toString());
    //print('height1:'+height.toString());
    //width = CommonUtil.getScreenWidth(context);
    //double height = CommonUtil.getScreenHeight(context);
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
                height: 150.0,
                width: width * 0.5,
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    //Navigator.pop(context);

                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 100.0,
                    width: width * 0.5 * 0.5,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    decoration: BoxDecoration(
                      color: SetColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100.0,
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
                                                SetConstants.bigTextSize)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Wallpager hd',
                                        style: TextStyle(
                                            color: SetColors.black,
                                            fontSize:
                                                SetConstants.bigTextSize)),
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
                                                SetConstants.bigTextSize)),
                                  ),
                                ),
                                //Container(child: Text('Wallpager hd'),),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 100.0,
                          alignment: Alignment.centerRight,
                          child: new Icon(
                            Icons.arrow_forward_ios,
                            color: SetColors.mainColor,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: SetColors.transparent,
                  child: AdWidget(ad: bannerAd..load()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
