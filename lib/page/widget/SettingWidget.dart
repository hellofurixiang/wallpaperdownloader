import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/FavoritePage.dart';

class SettingWidget extends StatefulWidget {
  @override
  SettingWidgetState createState() => new SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  bool offstage = false;

  void changeOffstage() {
    setState(() {
      offstage = !offstage;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = CommonUtil.getScreenWidth(context) * 0.5;

    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: Container(
              child: Column(
                children: [
                   Container(
                     height: 100.0,
                      alignment: Alignment.center,
                      color: SetColors.white,
                      padding: EdgeInsets.only(left: 4.0,right: 4.0),
                      child: Row(
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/ic_launcher.png',
                              color: SetColors.black,
                              width: 60.0,
                              height: 60.0,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              height: 40,
                              child: Text('Wallpager hd',
                                  style: TextStyle(
                                      color: SetColors.black,
                                      fontSize: SetConstants.bigTextSize)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            height: 40,
                            child: Text('V1.01',
                                style: TextStyle(
                                    color: SetColors.black,
                                    fontSize: SetConstants.bigTextSize)),
                          ),
                          //Container(child: Text('Wallpager hd'),),
                        ],
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50.0,
                      color: SetColors.white,
                      child: Column(
                        children: [
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
                                        fontSize: SetConstants.bigTextSize,
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
                              color: SetColors.white,
                              alignment: Alignment.centerLeft,
                              height: 40.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_comment_rounded,
                                    size: 30,
                                    color: SetColors.darkDarkGrey,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Favorite',
                                      style: TextStyle(
                                          fontSize: SetConstants.bigTextSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          WidgetUtil.getDivider(height: 1.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Share.share('Test address');
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 40.0,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: 30,
                                    color: SetColors.darkDarkGrey,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      'Share',
                                      style: TextStyle(
                                          fontSize: SetConstants.bigTextSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /* Container(
                            padding: EdgeInsets.only(left: 10.0),
                            alignment: Alignment.centerLeft,
                            height: 40.0,
                            child: Text(
                              'Other',
                              style: TextStyle(
                                  fontSize: SetConstants.bigTextSize,
                                  color: SetColors.gray,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 40.0,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.article,
                                  size: 30,
                                  color: SetColors.darkDarkGrey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Rate',
                                    style: TextStyle(
                                        fontSize: SetConstants.bigTextSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 40.0,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.more,
                                  size: 30,
                                  color: SetColors.darkDarkGrey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Favorite',
                                    style: TextStyle(
                                        fontSize: SetConstants.bigTextSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 40.0,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  size: 30,
                                  color: SetColors.darkDarkGrey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Share',
                                    style: TextStyle(
                                        fontSize: SetConstants.bigTextSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          */
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 40.0,
                            padding: EdgeInsets.only(left: 5.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 30,
                                  color: SetColors.darkDarkGrey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Settings',
                                    style: TextStyle(
                                        fontSize: SetConstants.bigTextSize,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: SetColors.white,
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
                opacity: 0.4,
                child: new Container(
                  alignment: Alignment.topCenter,
                  width: width,
                  color: SetColors.lightGray,
                ),
              )),
        ],
      ),
    );
  }
}
