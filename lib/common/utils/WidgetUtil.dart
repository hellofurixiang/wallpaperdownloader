import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/HangInfoProvider.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/StringZh.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/page/PicDetailPage.dart';

///控件通用类
class WidgetUtil {
  ///加载框
  static void showLoadingDialog(BuildContext context, String text) {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future<bool> _onWillPop() => new Future.value(false);
          return WillPopScope(
            onWillPop: _onWillPop,
            child: new Material(
              //创建透明层
              type: MaterialType.transparency, //透明类型
              child: new Center(
                //保证控件居中效果
                child: new SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: new Container(
                    decoration: ShapeDecoration(
                      color: SetColors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new CircularProgressIndicator(
                          color: SetColors.gray,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  static Widget getLoadingWidget(String text) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: SetColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: new EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(
                    text,
                    // ignore: conflicting_dart_import
                    style: new TextStyle(fontSize: SetConstants.smallTextSize),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget getEmptyLoadingWidget() {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: SetColors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(
                  color: SetColors.gray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///确认框
  static void showConfirmDialog(BuildContext context, Function confirmFun) {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Are you sure want to download this wallpaper?'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.pop(context);
                  confirmFun();
                },
              ),
            ],
          );
        });
  }

  ///获取自定义导航栏
  static AppBar getAppBar(BuildContext context, bool isBack, String title) {
    Widget leading;
    if (isBack) {
      leading = new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      leading = new Container();
    }

    return new AppBar(
      leading: leading,
      centerTitle: true,
      title: new Text(
        StringZh.app_describe,
        style: new TextStyle(
            color: SetColors.white, fontSize: SetConstants.lagerTextSize),
      ),
    );
  }

  ///空页面
  /*static Widget buildEmpty(BuildContext context, {Function onRefresh}) {
    return new Container(
      height: MediaQuery.of(context).size.height - 100,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new FlatButton(
            onPressed: () {
              if (null != onRefresh) {
                onRefresh();
              }
            },
            child: new Image(
                image: new AssetImage(SetIcons.no_data),
                width: 70.0,
                height: 70.0),
          ),
          new Container(
            child: new Text(StringZh.app_empty,
                style: new TextStyle(
                  fontSize: SetConstants.normalTextSize,
                )),
          ),
        ],
      ),
    );
  }*/

  ///分割线
  static Widget getDivider(
      {double height: 3.0, color: SetColors.dividerColor1}) {
    return new Container(
      height: height,
      color: color,
    );
  }

  ///登录界面、主界面提示退出
  static Future<bool> dialogExitApp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: new Text(StringZh.app_back_tip),
        actions: <Widget>[
          new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text(StringZh.app_cancel)),
          new FlatButton(
            onPressed: () {
              ///系统退出
              SystemNavigator.pop();
            },
            child: new Text(StringZh.app_ok),
          ),
        ],
      ),
    );
  }

  static showToast(
      {String msgType: Config.warning,
      String msg,
      Color backgroundColor: SetColors.gray,
      Color textColor: SetColors.white,
      double fontSize: SetConstants.smallTextSize,
      int timeInSecForIosWeb: 3}) {
    int seconds = 5;
    if (timeInSecForIosWeb == null) {
      if (msgType == Config.warning || msgType == Config.success) {
        seconds = 2;
      }
    } else {
      seconds = timeInSecForIosWeb;
    }
    if (msgType == Config.error) {
      backgroundColor = SetColors.red;
    } else if (msgType == Config.success) {
      backgroundColor = Colors.green;
    }

    Fluttertoast.showToast(
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
        msg: msg,
        timeInSecForIosWeb: seconds);
  }

  ///加载控件
  static Widget getLoading() {
    ///'正在加载中，莫着急哦~'
    return new Container(
      alignment: Alignment.center,
      color: SetColors.white,
      width: double.infinity,
      height: double.infinity,
      child: new ClipRRect(
        child: new Container(
          alignment: Alignment.center,
          color: SetColors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 28.0,
                height: 28.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(SetColors.mainColor),
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(width: 15.0),
              Text(
                StringZh.hard_loading,
                style: new TextStyle(
                  fontSize: SetConstants.normalTextSize,
                  color: SetColors.mainColor,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void goDetailPage(BuildContext context, String id, String operType,
      {String cat, String keyword}) async {
    showLoadingDialog(context, StringZh.loading);
    ApiUtil.getDetailInfo(context, {
      'id': id,
    }, (res) async {
      Navigator.pop(context);
      if (res['code'] == '1') {
        PicInfo picInfo = PicInfo.fromJson(res['resBody']);

        HangInfoProvider provider = new HangInfoProvider();

        HangInfoEntity vo = await provider.findOne(picInfo.id);

        bool favoriteBo = false;
        bool advertisingBo = true;

        if (vo != null) {
          if (vo.favorite != null) {
            favoriteBo = vo.favorite == 1;
          }
          if (vo.watchAds != null) {
            advertisingBo = vo.watchAds == 1;
          }
        } else {
          if (picInfo.advertising != null && picInfo.advertising) {
            advertisingBo = false;
          }
        }

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PicDetailPage(
            cat: cat,
            keyword: keyword,
            operType: operType,
            picInfo: picInfo,
            favoritBo: favoriteBo,
            advertisingBo: advertisingBo,
          );
        }));
      } else {
        WidgetUtil.showToast(msg: res['message']);
      }
    }, (err) {
      Navigator.pop(context);
    });
  }

  static String getPicUrl(PicInfo picInfo) {
    return Config.downloadUrl + picInfo.fileName + '_thumbnail.' + picInfo.type;
  }

  /// 按指定位置弹出菜单
  ///dx,dy:手势位置
  ///items菜单选项，keey为显示内容，value为返回值
  ///如果不传items参数可以自定义菜单样式，需要传size和menu
  static Future showRightMenu(BuildContext context, dx, dy,
      {List<MapEntry<String, dynamic>> items, Size size, Widget menu}) async {
    double sw = MediaQuery.of(context).size.width; //屏幕宽度
    double sh = MediaQuery.of(context).size.height; //屏幕高度
    Border border = dy < sh / 2
        ? //
        Border(top: BorderSide(color: Colors.green[200], width: 2))
        : Border(bottom: BorderSide(color: Colors.green[200], width: 2));

    ///如果传了items参数则根据items生成菜单
    if (items != null && items.length > 0) {
      double itemWidth = 100.0;
      double itemHeight = 50.0;
      double menuHeight = itemHeight * items.length + 2;

      size = Size(itemWidth, menuHeight);

      menu = Container(
        decoration: BoxDecoration(color: Colors.white, border: border),
        child: Column(
          children: items
              .map<Widget>((e) => InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: itemWidth,
                      height: itemHeight,
                      child: Text(
                        e.key,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, e.value);
                    },
                  ))
              .toList(),
        ),
      );
    }
    Size sSize = MediaQuery.of(context).size;

// PopupMenuItem

    double menuW = size.width; //菜单宽度
    double menuH = size.height; //菜单高度
    //判断手势位置在屏幕的那个区域以判断最好的弹出方向
    double endL = dx < sw / 2 ? dx : dx - menuW;
    double endT = dy < sh / 2 ? dy : dy - menuH;
    double endR = dx < sw / 2 ? dx + menuW : dx;
    double endB = dy < sh / 2 ? dy + menuH : dy;

    return await showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          //由于用了组件放大的动画效果，所以用了SingleChildScrollView包裹
          //否则在组件小的时候会出现菜单超出编辑的错误
          return SingleChildScrollView(child: menu);
        },
        barrierColor: Colors.grey.withOpacity(0),
        //弹窗后的背景遮罩色，调来调去还是透明的顺眼
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 200),
        //动画时间

        transitionBuilder: (context, anim1, anim2, child) {
          return Stack(
            children: [
              // 有好多种Transition来实现不同的动画效果，可以参考官方API
              PositionedTransition(
                  rect: RelativeRectTween(
                    begin: RelativeRect.fromSize(
                        //动画起始位置与元素大小
                        Rect.fromLTWH(dx, dy, 1, 1),
                        sSize),
                    end: RelativeRect.fromSize(
                        //动画结束位置与元素大小
                        Rect.fromLTRB(endL, endT, endR, endB),
                        sSize),
                  ).animate(CurvedAnimation(parent: anim1, curve: Curves.ease)),
                  child: child)
            ],
          );
        });
  }

  /// 设置沉浸式导航栏文字颜色
  ///
  /// [light] 状态栏文字是否为白色
  static SystemUiOverlayStyle setNavigationBarTextColor(bool light) {
    return SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: null,
      statusBarColor: null,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: light ? Brightness.light : Brightness.dark,
      statusBarBrightness: light ? Brightness.dark : Brightness.light,
    );
  }

  static Widget getListWidget(Function onRefresh,
      bool loading,
      ScrollController scrollController,
      List<PicInfo> imgList,
      String operType,
      int load){
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: loading
                ? WidgetUtil.getEmptyLoadingWidget()
                : StaggeredGridView.countBuilder(
              //shrinkWrap: true,
              controller: scrollController,
              padding: EdgeInsets.all(2),
              crossAxisCount: 3,
              itemCount: imgList.length,
              itemBuilder: (context, i) {
                String imgPath = WidgetUtil.getPicUrl(imgList[i]);
                return GestureDetector(
                  onTap: () {
                    //AdMobService.showInterstitialAd();
                    WidgetUtil.goDetailPage(
                        context, imgList[i].id, operType);

                    //AdMobService.showInterstitialAd();

                    //AdMobService.showRewardedAd(context,(){});
                  },
                  child: new Material(
                    //elevation: 8.0,
                    //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: new CachedNetworkImage(
                      imageUrl: imgPath,
                      imageBuilder: (context, imageProvider) => Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: SetColors.darkGrey,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: SetColors.darkGrey,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: CupertinoActivityIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) {
                return StaggeredTile.count(1, 2); //横轴和纵轴的数量,控制瀑布流效果
              },
              //crossAxisCount: 4,
              //crossAxisSpacing: 4,
              //mainAxisSpacing: 10,
            ),
          ),
        ),
        WidgetUtil.getListLoadMoreOffstage(load),
      ],
    );
  }
  static Widget getListLoadMoreOffstage(int load){
    return Offstage(
      offstage: load != 2,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth:2.0,
            backgroundColor: SetColors.gray,
            color: SetColors.gray,
          ),
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
