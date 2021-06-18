import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/style/StringZh.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';

///头部导航栏
class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  ///标题
  final String title;

  ///是否有返回
  final bool isBack;

  ///背景颜色
  final Color backgroundColor;

  ///返回图标
  final IconData backIcon;

  ///返回图标颜色
  final Color iconColor;

  ///标题颜色
  final Color titleColor;

  ///右侧控件
  final Widget rightWidget;

  ///下面控件
  final Widget bottomWidget;

  const AppBarWidget({
    Key key,
    @required this.title,
    this.isBack: true,
    this.backIcon: Icons.arrow_back,
    this.backgroundColor: SetColors.white,
    this.iconColor: SetColors.black,
    this.titleColor: SetColors.black,
    this.rightWidget,
    this.bottomWidget,
  }) : super(key: key);

  @override
  AppBarWidgetState createState() => new AppBarWidgetState();

  // TODO: implement preferredSize
  @override
  Size get preferredSize {
    return new Size.fromHeight(56.0);
  }
}

class AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (widget.isBack) {
      list.add(new Expanded(
        flex: 1,
        child: new Container(
          alignment: Alignment.centerLeft,
          child: new IconButton(
            icon: new Icon(
              widget.backIcon,
              color: widget.iconColor,
              size: 40.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ));
    } else {
      list.add(new Expanded(
        flex: 1,
        child: new Container(),
      ));
    }
    list.add(new Expanded(
      flex: 2,
      child: new Container(
        /*padding: new EdgeInsets.only(
          left: widget.rightWidget == null ? 0.0 : 48.0,
          right: paddingRight,
        ),*/
        alignment: Alignment.center,
        child: new Text(
          widget.title,
          style: new TextStyle(
              color: widget.titleColor,
              fontSize: SetConstants.bigTextSize,
              fontWeight: FontWeight.w700),
        ),
      ),
    ));
    if (null != widget.rightWidget) {
      list.add(
        new Expanded(
          flex: 1,
          child: new Container(
            alignment: Alignment.centerRight,
            padding: new EdgeInsets.only(
              right: 5.0,
            ),
            child: widget.rightWidget,
          ),
        ),
      );
    } else {
      list.add(
        new Expanded(
          flex: 1,
          child: new Container(
            alignment: Alignment.centerRight,
            padding: new EdgeInsets.only(
              right: 2.0,
            ),
            child: new Text(
              '',
              style: new TextStyle(
                  color: SetColors.white,
                  fontSize: SetConstants.middleTextSize),
            ),
          ),
        ),
      );
    }

    var height = CommonUtil.getStatusBarHeight(context);

    return new Container(
      padding: new EdgeInsets.only(
        top: height,
      ),
      height: height + 50.0,
      color: widget.backgroundColor,
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: list),
    );
  }
}
