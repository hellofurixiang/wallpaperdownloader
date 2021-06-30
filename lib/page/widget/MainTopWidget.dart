import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/style/StringZh.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/page/SearchPage.dart';
import 'package:wallpaperdownloader/page/widget/SettingWidget.dart';

///头部导航栏
class MainTopWidget extends StatefulWidget {
  const MainTopWidget({
    Key key,
  }) : super(key: key);

  @override
  MainTopWidgetState createState() => new MainTopWidgetState();
}
enum Availability { LOADING, AVAILABLE, UNAVAILABLE }

extension on Availability {
  String stringify() => this.toString().split('.').last;
}

class MainTopWidgetState extends State<MainTopWidget> {

  final InAppReview _inAppReview = InAppReview.instance;
  String _appStoreId = 'com.hdwallpaper.wallpaper';//'com.free.aesthetic.wallpaper.hd4k.hd.wallpaperdownloader';
  String _microsoftStoreId = 'com.hdwallpaper.wallpaper';
  Availability _availability = Availability.LOADING;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final isAvailable = await _inAppReview.isAvailable();

        setState(() {
          _availability = isAvailable && !Platform.isAndroid
              ? Availability.AVAILABLE
              : Availability.UNAVAILABLE;
        });
      } catch (e) {
        setState(() => _availability = Availability.UNAVAILABLE);
      }
    });
  }

  void _setAppStoreId(String id) => _appStoreId = id;

  void _setMicrosoftStoreId(String id) => _microsoftStoreId = id;

  Future<void> _requestReview() => _inAppReview.requestReview();

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
    appStoreId: _appStoreId,
    microsoftStoreId: _microsoftStoreId,
  );


  @override
  Widget build(BuildContext context) {
    var height = CommonUtil.getStatusBarHeight(context);

    List<Widget> list = [];

    list.add(new Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          showDialog<Null>(
              context: context, //BuildContext对象
              barrierDismissible: false,
              builder: (BuildContext context) {
                return SettingWidget(showRate: _openStoreListing);
              });
        },
        child: Container(
          color: SetColors.transparent,
          margin: EdgeInsets.only(left: 15.0),
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset('assets/show_setting.svg',
              width: 25.0, height: 25.0, color: SetColors.white),
        ),
      ),
    ));

    list.add(new Expanded(
      flex: 2,
      child: new Container(
        alignment: Alignment.center,
        child: new Text(
          Config.appName,
          style: new TextStyle(
              color: SetColors.white,
              fontSize: SetConstants.bigTextSize,
              fontWeight: FontWeight.w700),
        ),
      ),
    ));

    list.add(Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage();
          }));
          //AdMobService.showInterstitialAd();
        },
        child: new Container(
          color: SetColors.transparent,
          margin: EdgeInsets.only(right: 15.0),
          alignment: Alignment.centerRight,
          child: SvgPicture.asset('assets/search.svg',
              width: 25.0, height: 25.0, color: SetColors.white),
        ),
      ),
    ));

    return new Container(
      padding: new EdgeInsets.only(
        top: height,
      ),
      height: height + 50.0,
      color: SetColors.transparent,
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list),
    );
  }
}
