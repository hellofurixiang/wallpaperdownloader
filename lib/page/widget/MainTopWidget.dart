import 'package:flutter/material.dart';
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

class MainTopWidgetState extends State<MainTopWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = CommonUtil.getStatusBarHeight(context);

    List<Widget> list = [];

    list.add(new Expanded(
      flex: 1,
      child: new Container(
        margin: EdgeInsets.only(left: 8.0),
        alignment: Alignment.centerLeft,
        child: new IconButton(
          icon: new Icon(
            Icons.storage,
            color: SetColors.black,
            size: 30.0,
          ),
          onPressed: () {
            showDialog<Null>(
                context: context, //BuildContext对象
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return SettingWidget();
                });
          },
        ),
      ),
    ));

    list.add(new Expanded(
      flex: 2,
      child: new Container(
        alignment: Alignment.center,
        child: new Text(
          StringZh.app_describe,
          style: new TextStyle(
              color: SetColors.black,
              fontSize: SetConstants.bigTextSize,
              fontWeight: FontWeight.w700),
        ),
      ),
    ));

    list.add(new Expanded(
      flex: 1,
      child: new Container(
        margin: EdgeInsets.only(right: 8.0),
        alignment: Alignment.centerRight,
        child: new IconButton(
          icon: new Icon(
            Icons.search,
            color: SetColors.black,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SearchPage();
            }));
          },
        ),
      ),
    ));

    return new Container(
      padding: new EdgeInsets.only(
        top: height,
      ),
      height: height + 50.0,
      color: SetColors.white,
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list),
    );
  }
}
