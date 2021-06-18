import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///操作列表
class PopupMenuWidget extends StatefulWidget {
  ///项目列表
  final List<String> itemList;

  ///回调函数
  final Function callBack;

  final double x;
  final double y;

  PopupMenuWidget(
      {Key key,
      @required this.itemList,
      @required this.callBack,
      this.x,
      this.y})
      : super(key: key);

  @override
  PopupMenuWidgetState createState() => new PopupMenuWidgetState();
}

class PopupMenuWidgetState extends State<PopupMenuWidget> {
  @override
  initState() {
    super.initState();
  }

  double height = 40.0;

  ///项目
  Widget getItemList() {
    List<Widget> widgetList = new List();
    for (int i = 0; i < widget.itemList.length; i++) {
      widgetList.add(new GestureDetector(
        onTap: () {
          widget.callBack(i);
        },
        child: new Container(
          color: SetColors.white,
          alignment: Alignment.center,
          height: height,
          child: new Text(
            widget.itemList[i],
            style: new TextStyle(fontSize: SetConstants.normalTextSize),
          ),
        ),
      ));
      widgetList.add(WidgetUtil.getDivider(height: 0.5));
    }
    return new ListView(
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = CommonUtil.getScreenWidth(context);
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Stack(
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: new Container(
              color: Colors.transparent,
              width: width,
            ),
          ),
          new Positioned(
            right:  60.0,
            bottom: 60.0,
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              width: 120.0,
              height: height * widget.itemList.length,
              child: getItemList(),
            ),
          ),
        ],
      ),
    );
  }
}
