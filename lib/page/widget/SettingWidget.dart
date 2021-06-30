import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/TelAndSmsService.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/FavoritePage.dart';
import 'package:wallpaperdownloader/page/SettingPage.dart';

class SettingWidget extends StatefulWidget {
  final Function showRate;

  const SettingWidget({Key key, this.showRate}) : super(key: key);

  @override
  SettingWidgetState createState() => new SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  @override
  void initState() {
    super.initState();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = CommonUtil.getScreenWidth(context) * 0.3;

    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: Container(
              color: SetColors.mainColor,
              child: Column(
                children: [
                  Container(
                    height: 100.0,
                    alignment: Alignment.center,
                    //color: SetColors.white,
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Row(
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/ic_launcher.png',
                            //color: SetColors.white,
                            width: 60.0,
                            height: 60.0,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5.0),
                            height: 40,
                            child: Text(
                              Config.appName,
                              style: TextStyle(
                                  color: SetColors.white,
                                  fontSize: SetConstants.middleTextSize),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.bottomLeft,
                            height: 40,
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              Config.versionName,
                              style: TextStyle(
                                  color: SetColors.white,
                                  fontSize: SetConstants.middleTextSize),
                            ),
                          ),
                        ),
                        //Container(child: Text('Wallpager hd'),),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      //height: 60.0,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              color: SetColors.transparent,
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    child:
                                        /*Icon(
                                      Icons.home,
                                      size: 30,
                                      color: SetColors.white,
                                    ),*/
                                        SvgPicture.asset('assets/home.svg',
                                            width: 25.0,
                                            height: 25.0,
                                            color: SetColors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Home',
                                      style: TextStyle(
                                          fontSize: SetConstants.normalTextSize,
                                          //fontWeight: FontWeight.bold,
                                          color: SetColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*Container(
                            alignment: Alignment.centerLeft,
                            height: 40.0,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.label,
                                  size: 30,
                                  color: SetColors.darkDarkGrey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Explore',
                                    style: TextStyle(
                                        fontSize: SetConstants.normalTextSize,
                                        color: SetColors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FavoritePage();
                              }));
                            },
                            child: Container(
                              color: SetColors.transparent,
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    child: SvgPicture.asset('assets/love.svg',
                                        width: 25.0,
                                        height: 25.0,
                                        color: SetColors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Favorite',
                                      style: TextStyle(
                                          fontSize: SetConstants.normalTextSize,
                                          //fontWeight: FontWeight.bold,
                                          color: SetColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /* WidgetUtil.getDivider(
                              height: 1.0, color: SetColors.black),*/

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SettingPage();
                              }));
                            },
                            child: Container(
                              color: SetColors.transparent,
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    child: SvgPicture.asset(
                                        'assets/setting.svg',
                                        width: 25.0,
                                        height: 25.0,
                                        color: SetColors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Settings',
                                      style: TextStyle(
                                          fontSize: SetConstants.normalTextSize,
                                          //fontWeight: FontWeight.bold,
                                          color: SetColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          WidgetUtil.getDivider(
                              height: 1.0, color: SetColors.black),
                          Container(
                            padding: EdgeInsets.only(left: 20.0),
                            alignment: Alignment.centerLeft,
                            height: 60.0,
                            child: Text(
                              'More Options',
                              style: TextStyle(
                                fontSize: SetConstants.normalTextSize,
                                color: SetColors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Share.share(Config.shareStr);
                            },
                            child: Container(
                              color: SetColors.transparent,
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    child: SvgPicture.asset('assets/share.svg',
                                        width: 25.0,
                                        height: 25.0,
                                        color: SetColors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Share',
                                      style: TextStyle(
                                          fontSize: SetConstants.normalTextSize,
                                          //fontWeight: FontWeight.bold,
                                          color: SetColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              widget.showRate();
                              //WidgetUtil.showAlertDialogForRate(context);
                            },
                            child: Container(
                              color: SetColors.transparent,
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    child: SvgPicture.asset('assets/rate.svg',
                                        width: 25.0,
                                        height: 25.0,
                                        color: SetColors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Rate this App',
                                      style: TextStyle(
                                          fontSize: SetConstants.normalTextSize,
                                          //fontWeight: FontWeight.bold,
                                          color: SetColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              TelAndSmsService.launchMailto();
                            },
                            child: Container(
                              color: SetColors.transparent,
                              alignment: Alignment.centerLeft,
                              height: 60.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.0,
                                    child: SvgPicture.asset('assets/mail.svg',
                                        width: 25.0,
                                        height: 25.0,
                                        color: SetColors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Send us Feedback',
                                      style: TextStyle(
                                          fontSize: SetConstants.normalTextSize,
                                          //fontWeight: FontWeight.bold,
                                          color: SetColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                                //color: SetColors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          new GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: new Opacity(
                opacity: 0.1,
                child: new Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  color: SetColors.transparent,
                ),
              )),
        ],
      ),
    );
  }
}
