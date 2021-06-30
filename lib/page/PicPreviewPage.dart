import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/HangInfoProvider.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/PicDetailPage.dart';

class PicPreviewPage extends StatefulWidget {
  final PicInfo picInfo;
  final String operType;
  final String cat;
  final String keyword;
  final String id;
  final String fileName;

  const PicPreviewPage(
      {Key key,
      this.operType,
      this.cat,
      this.keyword,
      this.picInfo,
      this.id,
      this.fileName})
      : super(key: key);

  @override
  PicPreviewPageState createState() => new PicPreviewPageState();
}

class PicPreviewPageState extends State<PicPreviewPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<PicInfo> picInfos = [];

  bool isLoad = true;

  ///默认是第一个
  int selIndex = 0;

  SwiperController swiperController;

  final _nativeAdController = NativeAdmobController();

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);
    if (widget.picInfo == null) {
      picInfos.add(PicInfo.newInfo(
          widget.id,
          widget.fileName.substring(0, widget.fileName.indexOf('_thumbnail')),
          widget.fileName.substring(widget.fileName.indexOf('.') + 1)));
    } else {
      picInfos.add(widget.picInfo);
    }
    super.initState();

    initData();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _nativeAdController.dispose();
    _controller.dispose();
    super.dispose();
  }

  initData() async {
    bool bo = false;
    switch (widget.operType) {
      case "new":
        break;
      case "download":
      case "read":
      case "random":
      case "advertising":
      case "cat":
      case "search":
        bo = true;
        break;
    }

    if (widget.operType == 'favorite') {
      HangInfoProvider provider = new HangInfoProvider();

      List<HangInfoEntity> vos = await provider.findAll();
      List<PicInfo> newPicInfoList = [];
      for (int i = 0; i < vos.length; i++) {
        if (widget.id == vos[i].imgId) {
          continue;
        }

        newPicInfoList.add(PicInfo.newInfo(
            vos[i].imgId,
            vos[i].fileName.substring(0, vos[i].fileName.indexOf('_thumbnail')),
            vos[i].fileName.substring(vos[i].fileName.indexOf('.') + 1)));
        if (i % 8 == 0) {
          newPicInfoList.add(PicInfo.nativeAd('-1'));
        }
      }
      setState(() {
        if (newPicInfoList.length > 0) {
          picInfos.addAll(newPicInfoList);
        }
        isLoad = false;
      });
    } else {
      ApiUtil.getNextOrPrePicInfo(context, {
        'keyword': widget.keyword,
        'cat': widget.cat,
        'id': picInfos[selIndex].id,
        'operType': widget.operType,
        'nextOrPre': bo,
        'size': 20
      }, (res) async {
        //Navigator.pop(context);
        if (res['code'] == '1') {
          List<PicInfo> newPicInfoList = [];
          for (int i = 0; i < res['resBody'].length; i++) {
            PicInfo newPicInfo = PicInfo.fromJson(res['resBody'][i]);
            if (newPicInfo.id == widget.id ||
                newPicInfo.id == widget.picInfo.id) {
              continue;
            }
            newPicInfoList.add(newPicInfo);
            if (i % Config.loadAdCount == 0) {
              newPicInfoList.add(PicInfo.nativeAd('-1'));
            }
          }
          setState(() {
            if (newPicInfoList.length > 0) {
              picInfos.addAll(newPicInfoList);
            }
            isLoad = false;
          });
        } else {
          WidgetUtil.showToast(msg: res['message']);
        }
      }, (err) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  UniqueKey swiperKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    double picPadding = CommonUtil.getScreenHeight(context) * 0.1 +
        CommonUtil.getStatusBarHeight(context);
    BoxDecoration boxDecoration;

    if (picInfos[selIndex].id == '-1') {
      boxDecoration = BoxDecoration(color: SetColors.black);
    } else {
      boxDecoration = BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.cover,
          image: new NetworkImage(Config.downloadUrl +
              picInfos[selIndex].fileName +
              '_preview.' +
              picInfos[selIndex].type),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SetColors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand, //未定位widget占满Stack整个空间
        children: <Widget>[
          isLoad
              ? WidgetUtil.getEmptyLoadingWidget()
              : Container(
                  //color: Colors.red,

                  //width: CommonUtil.getScreenWidth(context)*0.95,
                  //height: CommonUtil.getScreenHeight(context)*0.85,
                  decoration: boxDecoration,
                  child: ClipRRect(
                    // make sure we apply clip it properly
                    child: BackdropFilter(
                      //背景滤镜
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), //背景模糊化
                      child: Container(
                        padding: EdgeInsets.only(
                            top: picPadding, bottom: picPadding),
                        color: Colors.grey.withOpacity(0.1),
                        child: Swiper(
                          key: swiperKey,
                          loop: false,
                          onIndexChanged: (int index) {
                            setState(() {
                              selIndex = index;
                            });
                            if (widget.operType == 'favorite') {
                              return;
                            }
                            if (index == picInfos.length - 1) {
                              initData();
                            }
                          },
                          onTap: (index) {
                            if (picInfos[index].id != '-1') {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PicDetailPage(
                                  cat: widget.cat,
                                  keyword: widget.keyword,
                                  operType: widget.operType,
                                  id: picInfos[selIndex].id,
                                );
                              }));
                            }
                          },
                          itemBuilder: (BuildContext context, int index) {
                            if (picInfos[index].id == '-1') {
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
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8), //设置圆角
                              //圆角组件
                              child: ExtendedImage.network(
                                Config.downloadUrl +
                                    picInfos[index].fileName +
                                    '_preview.' +
                                    picInfos[index].type,
                                mode: ExtendedImageMode.gesture,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                color: SetColors.transparent,
                                loadStateChanged: (ExtendedImageState state) {
                                  switch (state.extendedImageLoadState) {
                                    case LoadState.loading:
                                      _controller.reset();
                                      return Container(
                                        color: SetColors.mainColor,
                                        width: 40.0,
                                        height: 40.0,

                                        ///限制大小无效是设置此属性
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                          color: SetColors.white,
                                        ),
                                      );
                                      break;

                                    ///if you don't want override completed widget
                                    ///please return null or state.completedWidget
                                    //return null;
                                    //return state.completedWidget;
                                    case LoadState.completed:
                                      return ExtendedRawImage(
                                        image: state.extendedImageInfo?.image,
                                        fit: BoxFit.cover,
                                      );
                                      break;
                                    case LoadState.failed:
                                      _controller.reset();
                                      return Container(
                                        margin: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: SetColors.mainColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),

                                        ///限制大小无效是设置此属性
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                            'assets/pic_error.svg',
                                            width: 40.0,
                                            height: 40.0,
                                            color: SetColors.white),
                                      );
                                      break;
                                    default:
                                      return Container();
                                      break;
                                  }
                                },
                              ),
                            );
                          },
                          itemCount: picInfos.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                        ),
                      ),
                    ),
                  ),
                ),
          Positioned(
            top: CommonUtil.getStatusBarHeight(context) + 10,
            left: 10.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(5.0),
                color: Colors.transparent,
                child: SvgPicture.asset('assets/back.svg',
                    width: 35.0, height: 35.0, color: SetColors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Container(
              height: 60,
              width: CommonUtil.getScreenWidth(context),
              //padding: EdgeInsets.all(10),
              //margin: EdgeInsets.only(bottom: 20.0),
              child: NativeAdmob(
                loading: Center(
                    child: CircularProgressIndicator(
                  color: SetColors.white,
                )),
                adUnitID: AdMobService.nativeAdGeneralUnitId,
                numberAds: 5,
                controller: _nativeAdController,
                type: NativeAdmobType.banner,
                options: NativeAdmobOptions(
                  headlineTextStyle: NativeTextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
