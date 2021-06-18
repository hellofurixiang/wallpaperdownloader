import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/HangInfoProvider.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/StringZh.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/AdMobService.dart';
import 'package:wallpaperdownloader/page/PicEditPage.dart';
import 'package:wallpaperdownloader/page/CommonState.dart';
import 'package:wallpaperdownloader/page/widget/PopupMenuWidget.dart';

class PicDetailPage extends StatefulWidget {
  final PicInfo picInfo;

  final bool favoritBo;

  final bool advertisingBo;

  final String operType;
  final String cat;
  final String keyword;

  const PicDetailPage(
      {Key key,
      this.picInfo,
      this.favoritBo: false,
      this.advertisingBo: true,
      this.operType,
      this.cat,
      this.keyword})
      : super(key: key);

  @override
  PicDetailPageState createState() => new PicDetailPageState();
}

class PicDetailPageState extends State<PicDetailPage>
    with SingleTickerProviderStateMixin {
  HangInfoProvider provider = new HangInfoProvider();

  bool infoOffstage = true;

  bool advertisingBo = true;

  bool favoriteBo = false;

  AnimationController _controller;

  String imgPath;

  PicInfo picInfo;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);

    picInfo = widget.picInfo;

    imgPath =
        Config.downloadUrl + picInfo.fileName + '_preview.' + picInfo.type;
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
    favoriteBo = widget.favoritBo;
    advertisingBo = widget.advertisingBo;
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

  showRewardedAd() {
    WidgetUtil.showLoadingDialog(context, 'Loading ads...');
    GlobalInfo.instance.setShowBannerAdState(1);
    AdMobService.showRewardedAd(context, () {
      GlobalInfo.instance.setShowBannerAdState(2);
      changeAdvertising();
    });
  }

  Widget getOperWidget(String imgPath) {
    if (!advertisingBo) {
      return GestureDetector(
        onTap: () {
          showRewardedAd();
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
                Share.share('wallpaper hd',
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
                WidgetUtil.showConfirmDialog(context, () {
                  WidgetUtil.showLoadingDialog(context, 'download...');
                  CommonUtil.saveImage(context, imgPath);
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
                            goToDetail();
                          }
                        },
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

  quickApply() {
    //显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Set this image as wallpaper?'),
          actions: [
            FlatButton(
              child: Text("YES"),
              onPressed: () async {
                AdMobService.showRewardedAd(context, () {
                  setWallpaper();
                });
              },
            )
          ],
        );
      },
    );
  }

  setWallpaper() async {
    Navigator.pop(context);
    WidgetUtil.showLoadingDialog(context, 'Set wallpaper...');
    String re = await Wallpaper.bothScreen(imgPath);
    if (re == 'Both screen') {
      WidgetUtil.showToast(msg: 'Set wallpaper successfully');
    } else {
      WidgetUtil.showToast(msg: 'Set wallpaper error');
    }
    Navigator.pop(context);
  }

  goToDetail() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PicEditPage(
        picInfo: picInfo,
      );
    }));

    //Navigator.pushNamed(context, 'PicEditPage');
  }

  ///左右滑动切换图片
  getNextOrPrePicInfo() async {
    if (widget.operType == 'favorite') {
      HangInfoProvider provider = new HangInfoProvider();

      HangInfoEntity vo = nextOrPre
          ? await provider.nextOne(picInfo.id)
          : await provider.preOne(picInfo.id);

      WidgetUtil.showLoadingDialog(context, StringZh.loading);

      ApiUtil.getDetailInfo(context, {
        'id': vo.imgId,
      }, (res) async {
        Navigator.pop(context);
        if (res['code'] == '1') {
          PicInfo nextPicInfo = PicInfo.fromJson(res['resBody']);

          setState(() {
            picInfo = nextPicInfo;
            imgPath = Config.downloadUrl +
                picInfo.fileName +
                '_preview.' +
                picInfo.type;
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
          });
        } else {
          WidgetUtil.showToast(msg: res['message']);
        }
      }, (err) {
        Navigator.pop(context);
      });
    } else {
      Map<String, Object> params = {
        'cat': widget.cat,
        'id': picInfo.id,
        'operType': widget.operType,
        'nextOrPre': nextOrPre,
        'keyword': widget.keyword
      };

      ApiUtil.getNextOrPrePicInfo(context, params, (res) async {
        if (res['code'] == '1') {
          PicInfo nextPicInfo = PicInfo.fromJson(res['resBody']);
          HangInfoProvider provider = new HangInfoProvider();

          HangInfoEntity vo = await provider.findOne(picInfo.id);

          setState(() {
            picInfo = nextPicInfo;
            imgPath = Config.downloadUrl +
                picInfo.fileName +
                '_preview.' +
                picInfo.type;
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
          });
        } else {
          WidgetUtil.showToast(msg: res['message']);
        }
      }, (err) {});
    }
  }

  double startDx = 0.0;
  bool nextOrPre = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SetColors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand, //未定位widget占满Stack整个空间
        children: <Widget>[
          GestureDetector(
            onPanStart: (DragStartDetails e) {
              startDx = e.localPosition.dx;
            },
            onPanUpdate: (DragUpdateDetails e) {
              if (e.localPosition.dx - startDx > 0) {
                nextOrPre = false;
              } else {
                nextOrPre = true;
              }
            },
            onPanEnd: (DragEndDetails e) {
              getNextOrPrePicInfo();
            },
            child: ExtendedImage.network(
              imgPath,
              mode: ExtendedImageMode.gesture,
              loadStateChanged: (ExtendedImageState state) {
                switch (state.extendedImageLoadState) {
                  case LoadState.loading:
                    _controller.reset();
                    return Container(
                      width: 50.0,
                      height: 50.0,
                      child: CupertinoActivityIndicator(),
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
                        fit: BoxFit.fill,
                      ),
                    );
                    break;
                  case LoadState.failed:
                    _controller.reset();
                    return GestureDetector(
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.asset(
                            "assets/failed.jpg",
                            fit: BoxFit.fill,
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Text(
                              "load image failed, click to reload",
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
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
              },
            ),
          ),
          Positioned(
            top: CommonUtil.getStatusBarHeight(context),
            left: 0.0,
            child: Container(
              color: Colors.transparent,
              child: IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: SetColors.white,
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Container(
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
                                      fontSize: SetConstants.bigTextSize)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: getOperWidget(imgPath)),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    changeCollection();
                                    //WidgetUtil.showLoadingDialog(context, 'Loading ads...');
                                    //showRewardedAd();
                                  },
                                  child: new Image(
                                    image:
                                        new AssetImage('assets/collection.png'),
                                    width: 30.0,
                                    height: 30.0,
                                    color:
                                        favoriteBo ? Colors.red : Colors.white,
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
                                      style: TextStyle(color: SetColors.white)),
                                ),
                                Container(
                                  child: Text(
                                    picInfo.readCount.toString(),
                                    style: TextStyle(color: SetColors.white),
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
                                      style: TextStyle(color: SetColors.white)),
                                ),
                                Container(
                                  child: Text(picInfo.downloadCount.toString(),
                                      style: TextStyle(color: SetColors.white)),
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
                                      style: TextStyle(color: SetColors.white)),
                                ),
                                Container(
                                  child: Text(picInfo.resolution ?? '',
                                      style: TextStyle(color: SetColors.white)),
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
