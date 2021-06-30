import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/HangInfoProvider.dart';
import 'package:wallpaperdownloader/common/db/provider/WatchAdProvider.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/modal/WatchAdEntity.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/plugin/EquipmentPlugin.dart';
import 'package:wallpaperdownloader/page/PicEditPage.dart';
import 'package:wallpaperdownloader/page/widget/PopupMenuWidget.dart';

class PicDetailPage extends StatefulWidget {
  final String id;

  final String operType;
  final String cat;
  final String keyword;

  const PicDetailPage({Key key, this.operType, this.cat, this.keyword, this.id})
      : super(key: key);

  @override
  PicDetailPageState createState() => new PicDetailPageState();
}

class PicDetailPageState extends State<PicDetailPage>
    with SingleTickerProviderStateMixin {
  HangInfoProvider provider = new HangInfoProvider();
  WatchAdProvider watchAdProvider = new WatchAdProvider();

  bool infoOffstage = true;

  ///观看广告
  bool advertisingBo = true;

  ///收藏
  bool favoriteBo = false;

  ///图片加载控制器
  AnimationController _controller;

  ///预览图片路径
  String imgPath;

  ///下载图片路径
  String fullPath;

  ///图片信息类
  PicInfo picInfo;

  ///加载状态
  bool isLoad = true;

  ///本地图片路径
  String localImgUrl;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);

    //picInfo = widget.picInfo;
    super.initState();
    initData();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  initData() async {
    //favoriteBo = widget.favoritBo;
    //advertisingBo = widget.advertisingBo;

    //showLoadingDialog(context, text: StringZh.loading);
    ApiUtil.getDetailInfo(context, {
      'id': widget.id,
    }, (res) async {
      //Navigator.pop(context);
      if (res['code'] == '1') {
        PicInfo newPicInfo = PicInfo.fromJson(res['resBody']);

        HangInfoProvider provider = new HangInfoProvider();

        HangInfoEntity vo = await provider.findOne(newPicInfo.id);
        setState(() {
          picInfo = newPicInfo;
          imgPath = Config.downloadUrl +
              picInfo.fileName +
              '_preview.' +
              picInfo.type;
          fullPath = Config.downloadUrl + picInfo.fileName + '.' + picInfo.type;

          isLoad = false;

          if (vo != null) {
            if (vo.favorite != null) {
              favoriteBo = vo.favorite == 1;
            }
            if (vo.watchAds != null) {
              //advertisingBo = vo.watchAds == 1;
            }
          } else {
            if (picInfo.advertising != null && picInfo.advertising) {
              //advertisingBo = false;
            }
          }
        });
      } else {
        WidgetUtil.showToast(msg: res['message']);
      }
    }, (err) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  ///处理收藏
  changeCollection() {
    if (favoriteBo) {
      ApiUtil.removeCollection(context, picInfo.id, (res) async {
        if (res['code'] == '1') {
          bool bo = await provider.updateFavorite(
              picInfo.id, picInfo.fileName + '_thumbnail.' + picInfo.type, 0);
          if (bo) {
            WidgetUtil.showToast(msg: 'Removed to favorite');
            setState(() {
              favoriteBo = false;
            });
          }
        } else {
          WidgetUtil.showToast(msg: res['message']);
        }
      }, (err) {});
    } else {
      ApiUtil.changeCollection(context, picInfo.id, (res) async {
        if (res['code'] == '1') {
          bool count = await provider.updateFavorite(
              picInfo.id, picInfo.fileName + '_thumbnail.' + picInfo.type, 1);
          if (count) {
            WidgetUtil.showToast(msg: 'Added to favorite');
            setState(() {
              favoriteBo = true;
            });
          }
        } else {
          WidgetUtil.showToast(msg: res['message']);
        }
      }, (err) {});
    }
  }

  ///处理广告
  changeAdvertising() async {
    bool count = await provider.updateWatchAds(
        picInfo.id, picInfo.fileName + '.' + picInfo.type, 1);
    if (count) {
      setState(() {
        advertisingBo = true;
      });
    }
  }

  showRewardedAd(Function operFun) async {
    DateTime date = DateTime.now();

    String watchDate =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    WatchAdEntity watchAdEntity = await watchAdProvider.findOne(watchDate);
    bool showRewardedAd = false;
    bool showInterstitialAd = false;

    if (watchAdEntity != null) {
      if (watchAdEntity.watchRewardedAd == 10 &&
          watchAdEntity.watchInterstitialAd == 10) {
        operFun();
        return;
      }
      if (watchAdEntity.watchRewardedAd < 10) {
        showRewardedAd = true;
      } else {
        if (watchAdEntity.watchInterstitialAd < 10) {
          showInterstitialAd = true;
        }
      }
    } else {
      showRewardedAd = true;
    }
    WidgetUtil.showLoadingDialog(context, text: 'Loading ads...');

    ///GlobalInfo.instance.setShowBannerAdState(1);
    if (showRewardedAd) {
      AdMobService.showRewardedAd(context, onAdLoad: () {}, onAdClosed: () {
        ///GlobalInfo.instance.setShowBannerAdState(2);
        ///changeAdvertising();
        watchAdProvider.updateWatchRewardedAd(watchDate);
        operFun();
      });
    } else {
      AdMobService.showInterstitialAd(
          onAdLoaded: () {},
          onAdClosed: () {
            watchAdProvider.updateWatchInterstitialAd(watchDate);
            operFun();
          });
    }
  }

  downloadFile() async {
    WidgetUtil.showLoadingDialog(context, text: 'download...');
    //GlobalInfo.instance.setShowBannerAdState(2);
    String downloadUrl = await CommonUtil.saveImage(context, fullPath);
    if (downloadUrl.isEmpty) {
      return;
    }
    setState(() {
      localImgUrl = downloadUrl.replaceAll('file://', '');
    });
    EquipmentPlugin.editImg(downloadUrl);
  }

  Widget getOperWidget() {
    if (!advertisingBo) {
      return GestureDetector(
        onTap: () {
          //showRewardedAd();
        },
        child: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: SetColors.white,
                  size: 30.0,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'WATCH ADS',
                    style: TextStyle(color: SetColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                final RenderBox box = context.findRenderObject() as RenderBox;
                Share.share(Config.shareStr,
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              },
              child: Image(
                image: new AssetImage('assets/share.png'),
                width: 30.0,
                height: 30.0,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                WidgetUtil.showConfirmDialog(
                    context, 'Are you sure want to download this wallpaper?',
                    () async {
                  showRewardedAd(downloadFile);
                });
              },
              child: Image(
                image: AssetImage('assets/download.png'),
                width: 30.0,
                height: 30.0,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onPanDown: (details) {
                x = details.globalPosition.dx;
                y = details.globalPosition.dy;
              },
              onTap: () async {
                showDialog<Null>(
                    context: context, //BuildContext对象
                    barrierDismissible: false,
                    barrierColor: SetColors.transparent,
                    builder: (BuildContext context) {
                      return new PopupMenuWidget(
                        x: x,
                        y: y,
                        itemList: ['Quick Apply', 'Crop Wallpaper'],
                        callBack: (menuIndex) {
                          Navigator.pop(context);
                          if (menuIndex == 0) {
                            quickApply();
                          } else {
                            goToEdit();
                          }
                        },
                        infoOffstage: infoOffstage,
                      );
                    });
              },
              child: Image(
                image: AssetImage('assets/edit.png'),
                width: 30.0,
                height: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }

  double x, y;

  quickApply() async {
    WidgetUtil.showAlertDialog(context, 'Set this image as wallpaper?',
        () async {
      showRewardedAd(setWallpaper);
    });

    /*WidgetUtil.showAlertDialog(context, 'Set this image as wallpaper?',
        () async {
      WidgetUtil.showLoadingDialog(context, text: 'Loading ads...');
      GlobalInfo.instance.setShowBannerAdState(1);
      AdMobService.showRewardedAd(context, () async {
        GlobalInfo.instance.setShowBannerAdState(2);
        WidgetUtil.showLoadingDialog(context, text: 'Set wallpaper...');
        String re = await Wallpaper.bothScreen(imgPath);
        if (re == 'Both screen') {
          WidgetUtil.showToast(msg: 'Set wallpaper successfully');
        } else {
          WidgetUtil.showToast(msg: 'Set wallpaper error');
        }
        Navigator.pop(context);
      });
    });*/
  }

  setWallpaper() async {
    String re;
    if (localImgUrl != null) {
      re = await WallpaperManager.setWallpaperFromFile(
          localImgUrl, WallpaperManager.BOTH_SCREENS);
    } else {
      re = await Wallpaper.bothScreen(fullPath);
    }
    if (re == 'Both screen' || re == 'Wallpaper set') {
      WidgetUtil.showToast(msg: 'Set wallpaper successfully');
    } else {
      WidgetUtil.showToast(msg: 'Set wallpaper error');
    }
  }

  goToEdit() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PicEditPage(
        localImgUrl: localImgUrl,
        picInfo: picInfo,
      );
    }));

    //Navigator.pushNamed(context, 'PicEditPage');
  }

  initGestureConfigHandler(ExtendedImageState state) {
    return GestureConfig(
        minScale: 0.9,
        animationMinScale: 0.7,
        maxScale: 3.0,
        animationMaxScale: 3.5,
        speed: 1.0,
        inertialSpeed: 100.0,
        initialScale: 1.0,
        inPageView: false);
  }

  loadStateChanged(ExtendedImageState state) {
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
        _controller.forward();
        return FadeTransition(
          opacity: _controller,
          child: ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            fit: BoxFit.contain,
            width: 300,
            height: 300,
          ),
        );
        break;
      case LoadState.failed:
        _controller.reset();
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: SetColors.mainColor,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),

            ///限制大小无效是设置此属性
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/pic_error.svg',
                width: 40.0, height: 40.0, color: SetColors.white),
          ),
          onTap: () {
            state.reLoadImage();
          },
        );
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SetColors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand, //未定位widget占满Stack整个空间
        children: <Widget>[
          isLoad
              ? WidgetUtil.getEmptyLoadingWidget()
              : (localImgUrl != null
                  ? ExtendedImage.file(
                      File(localImgUrl),
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (ExtendedImageState state) {
                        return initGestureConfigHandler(state);
                      },
                      loadStateChanged: (ExtendedImageState state) {
                        return loadStateChanged(state);
                      },
                    )
                  : ExtendedImage.network(
                      imgPath,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      cache: true,
                      /*initGestureConfigHandler: (ExtendedImageState state) {
                        return initGestureConfigHandler(state);
                      },*/
                      //loadStateChanged: (ExtendedImageState state){return loadStateChanged(state);},
                    )),
          Positioned(
            top: CommonUtil.getStatusBarHeight(context) + 10.0,
            left: 10.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.transparent,
                child: SvgPicture.asset('assets/back.svg',
                    width: 35.0, height: 35.0, color: SetColors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: isLoad
                ? Container()
                : Container(
                    padding: EdgeInsets.all(4.0),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(.4),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      infoOffstage = !infoOffstage;
                                    });
                                  },
                                  child: Container(
                                    child: Text(picInfo.keyword ?? '',
                                        style: TextStyle(
                                            color: SetColors.white,
                                            fontSize:
                                                SetConstants.bigTextSize)),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(flex: 3, child: getOperWidget()),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          changeCollection();
                                          //WidgetUtil.showLoadingDialog(context, 'Loading ads...');
                                          //showRewardedAd();
                                        },
                                        child: new Image(
                                          image: new AssetImage(
                                              'assets/collection.png'),
                                          width: 30.0,
                                          height: 30.0,
                                          color: favoriteBo
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Offstage(
                          offstage: infoOffstage,
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text('Views',
                                            style: TextStyle(
                                                color: SetColors.white)),
                                      ),
                                      Container(
                                        child: Text(
                                          picInfo.readCount.toString(),
                                          style:
                                              TextStyle(color: SetColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text('Downloads',
                                            style: TextStyle(
                                                color: SetColors.white)),
                                      ),
                                      Container(
                                        child: Text(
                                            picInfo.downloadCount.toString(),
                                            style: TextStyle(
                                                color: SetColors.white)),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text('Resolution',
                                            style: TextStyle(
                                                color: SetColors.white)),
                                      ),
                                      Container(
                                        child: Text(picInfo.resolution ?? '',
                                            style: TextStyle(
                                                color: SetColors.white)),
                                      ),
                                    ],
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
        ],
      ),
    );
  }
}
