import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/style/StringZh.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/page/PicDetailPage.dart';
import 'package:wallpaperdownloader/page/PicPreviewPage.dart';
import 'package:wallpaperdownloader/page/widget/FeedbackWidget.dart';
import 'package:wallpaperdownloader/page/widget/SponRatingWidget.dart';

///控件通用类
class WidgetUtil {
  ///加载框
  static void showLoadingDialog(BuildContext context, {String text}) {
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
                child: Container(
                  width: 150.0,
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
                    child: new Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          color: SetColors.white,
                        ),
                        Expanded(
                          child: text == null
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    text,
                                    style: TextStyle(color: SetColors.darkGrey),
                                  ),
                                ),
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
                  color: SetColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///确认框
  static void showConfirmDialog(
      BuildContext context, String content, Function confirmFun,
      {Color background: SetColors.white,
      Color contextColor: SetColors.mainColor,
      Color btnColor: SetColors.mainColor}) {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: background,
            content: Text(
              content,
              style: TextStyle(color: contextColor),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: contextColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'YES',
                  style: TextStyle(color: contextColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  confirmFun();
                },
              ),
            ],
          );
        });
  }

  ///确认框
  static void showAlertDialog(
      BuildContext context, String content, Function confirmFun,
      {Color background: SetColors.white,
      Color contextColor: SetColors.mainColor,
      Color btnColor: SetColors.mainColor}) {
    showDialog<Null>(
        context: context, //BuildContext对象
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: background,
            content: Text(
              content,
              style: TextStyle(color: contextColor),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'YES',
                  style: TextStyle(color: contextColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  confirmFun();
                },
              ),
            ],
          );
        });
  }

  ///关于
  static void showAlertDialogForAbout(BuildContext context) {
    showDialog<Null>(
        context: context, //BuildContext对象
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: SetColors.white,
            content: Container(
              height: 130.0,
              child: Column(
                children: [
                  Container(
                    height: 60.0,
                    child: Image.asset(
                      'assets/ic_launcher.png',
                      //color: SetColors.white,
                      width: 60.0,
                      height: 60.0,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    //height: 40.0,
                    child: Text(
                      Config.appName,
                      style: TextStyle(
                          color: SetColors.mainColor,
                          fontSize: SetConstants.lagerTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    child: Text(
                      'Version ${Config.versionName}',
                      style: TextStyle(
                        color: SetColors.mainColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: SetColors.mainColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  ///评价
  static void showAlertDialogForRate(BuildContext context) {
    showDialog<Null>(
        context: context, //BuildContext对象
        //barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: SetColors.mainColor,
            content: Container(
              height: 280.0,
              width: CommonUtil.getScreenWidth(context),
              child: Column(
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
                  Container(
                    alignment: Alignment.center,
                    height: 60.0,
                    child: Text(
                      'How was your experience with us?',
                      style: TextStyle(
                        color: SetColors.white,
                        fontSize: SetConstants.bigTextSize,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60.0,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        SponRatingWidget(
                          value: 0,
                          size: 30,
                          padding: 5,
                          nomalImage: 'assets/star.png',
                          selectImage: 'assets/star.png',
                          selectAble: true,
                          onRatingUpdate: (value) {
                            print('星级：' + value.toString());
                            Navigator.pop(context);
                            showDialog<Null>(
                                context: context, //BuildContext对象
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return FeedbackWidget(rate: value);
                                });
                          },
                          maxRating: 5,
                          count: 5,
                        ),
                        Expanded(
                          child: Container(),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: SetColors.transparent,
                      alignment: Alignment.center,
                      height: 60.0,
                      width: 200.0,
                      child: Text(
                        'Maybe later',
                        style: TextStyle(
                          color: SetColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  static void goDetailPage(BuildContext context, String operType,
      {PicInfo picInfo,
      String cat,
      String keyword,
      String id,
      String fileName}) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PicPreviewPage(
        cat: cat,
        keyword: keyword,
        operType: operType,
        picInfo: picInfo,
        id: id,
        fileName: fileName,
      );
    }));

    /*showLoadingDialog(context, text: StringZh.loading);
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
    });*/
  }

  static String getPicUrl(PicInfo picInfo) {
    return Config.downloadUrl + picInfo.fileName + '_thumbnail.' + picInfo.type;
  }

  static Widget getListWidget(
      Function onRefresh,
      bool loading,
      ScrollController scrollController,
      List<PicInfo> imgList,
      String operType,
      int load,
      {bool isFeatured: false}) {
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
                      ///广告
                      if (imgList[i].id == '-1') {
                        return Container(
                          //height: 60,
                          //width: CommonUtil.getScreenWidth(context),
                          //padding: EdgeInsets.all(10),
                          //margin: EdgeInsets.only(bottom: 20.0),
                          alignment: Alignment.center,
                          child: NativeAdmob(
                            loading: Center(
                              child: CircularProgressIndicator(
                                color: SetColors.white,
                              ),
                            ),
                            adUnitID: AdMobService.nativeAdGeneralUnitId,
                            numberAds: 5,
                            //controller: _nativeAdController,
                            type: NativeAdmobType.full,
                            options: NativeAdmobOptions(
                              headlineTextStyle: NativeTextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      String imgPath = WidgetUtil.getPicUrl(imgList[i]);
                      return GestureDetector(
                        onTap: () {
                          //AdMobService.showInterstitialAd();
                          WidgetUtil.goDetailPage(context, operType,
                              picInfo: imgList[i]);

                          //AdMobService.showInterstitialAd();

                          //AdMobService.showRewardedAd(context,(){});
                        },
                        child: CachedNetworkImage(
                          imageUrl: imgPath,
                          imageBuilder: (context, imageProvider) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: SetColors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                isFeatured
                                    ? Positioned(
                                        top: 5.0,
                                        right: 5.0,
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: SetColors.white,
                                            size: 20.0,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            );
                          },
                          placeholder: (context, url) => Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: SetColors.mainColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Container(
                              color: SetColors.mainColor,
                              width: 40.0,
                              height: 40.0,

                              ///限制大小无效是设置此属性
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: SetColors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: SetColors.mainColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),

                            ///限制大小无效是设置此属性
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/pic_error.svg',
                                width: 40.0,
                                height: 40.0,
                                color: SetColors.white),
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (int index) {
                      if (((index + 1) % (Config.loadAdCount + 1) == 0)) {
                        return StaggeredTile.count(3, 2);
                      } else {
                        return StaggeredTile.count(1, 1.5);
                      }
                      //横轴和纵轴的数量,控制瀑布流效果
                      //return StaggeredTile.Count(2,index==0?2.5:3)

                      //return StaggeredTile.fit(1);
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

  static Widget getListLoadMoreOffstage(int load) {
    return Offstage(
      offstage: load != 2,
      child: Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
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
