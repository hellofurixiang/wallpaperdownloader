import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/WatchAdProvider.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/modal/WatchAdEntity.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/crop_editor_helper.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';

class PicEditPage extends StatefulWidget {
  final PicInfo picInfo;
  final String localImgUrl;

  const PicEditPage({
    Key key,
    this.picInfo,
    this.localImgUrl,
  }) : super(key: key);

  @override
  PicEditPageState createState() => new PicEditPageState();
}

class PicEditPageState extends State<PicEditPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  WatchAdProvider watchAdProvider = new WatchAdProvider();
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.0,
        upperBound: 1.0);

    super.initState();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(StatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  Future<void> cropImage() async {
    final Uint8List fileData = Uint8List.fromList(kIsWeb
        ? (await cropImageDataWithDartLibrary(state: editorKey.currentState))
        : (await cropImageDataWithNativeLibrary(
            state: editorKey.currentState)));

    try {
      /// 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus != PermissionStatus.granted) {
          throw '无法存储图片，请先授权！';
        }
      }

      /// 保存图片
      final result = await ImageGallerySaver.saveImage(fileData);

      if (result == null || result == '') throw '图片保存失败';

      String setWallpaperResult = await WallpaperManager.setWallpaperFromFile(
          result['filePath'].toString().replaceAll('file://', ''),
          WallpaperManager.BOTH_SCREENS);

      WidgetUtil.showToast(msg: setWallpaperResult);
      Navigator.pop(context);
    } catch (e) {
      WidgetUtil.showToast(msg: 'Set wallpaper error!');
      //print(e.toString());
    }
  }

  double cropAspectRatio;

  /*showRewardedAd() {
    WidgetUtil.showLoadingDialog(context, text: 'Loading ads...');
    GlobalInfo.instance.setShowBannerAdState(1);
    AdMobService.showRewardedAd(context, onAdLoad: (){},onAdClosed: () {
      GlobalInfo.instance.setShowBannerAdState(2);
      cropImage();
    });
  }*/


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

  @override
  Widget build(BuildContext context) {
    cropAspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    //String imgPath = Config.address + 'getFullFileBytesStr?id=' + widget.id;

    return new Scaffold(
      backgroundColor: SetColors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand, //未定位widget占满Stack整个空间
        children: <Widget>[
          getEditImgWidget(),
          Positioned(
              top: CommonUtil.getStatusBarHeight(context) + 10,
              left: 10.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15.0),
                  color: Colors.transparent,
                  child: SvgPicture.asset('assets/back.svg',
                      width: 35.0, height: 35.0, color: SetColors.white),
                ),
              )),
          Positioned(
            top: CommonUtil.getStatusBarHeight(context),
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                //显示对话框
                WidgetUtil.showAlertDialog(
                    context, 'Set this image as wallpaper?', () {
                  showRewardedAd(cropImage);
                });
              },
              child: Container(
                  height: 50.0,
                  margin: EdgeInsets.only(left:15.0,right: 10.0),
                  alignment: Alignment.center,
                  child: Text(
                    'Apply',
                    style: TextStyle(
                        color: SetColors.white,
                        fontSize: SetConstants.lagerTextSize,),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget getEditImgWidget() {

    String imgPath = Config.downloadUrl +
        widget.picInfo.fileName +
        '.' +
        //'_preview.' +
        widget.picInfo.type;

    EditorConfig editorConfig = EditorConfig(
        cornerColor: SetColors.white,
        //裁剪框四角图形的大小
        cornerSize: Size(20.0, 4.0),
        //最大的缩放倍数
        maxScale: 8.0,
        //裁剪框跟图片 layout 区域之间的距离。最好是保持一定距离，不然裁剪框边界很难进行拖拽
        cropRectPadding: const EdgeInsets.only(left: 15.0, right: 15.0),
        //裁剪框四角以及边线能够拖拽的区域的大小
        hitTestSize: 50.0,
        lineColor: SetColors.white,
        lineHeight: 2.0,
        //initCropRectType: InitCropRectType.imageRect,
        //裁剪框的宽高比
        cropAspectRatio: CropAspectRatios.ratio3_4,
        //cropAspectRatio,
        //editActionDetailsIsChanged: (EditActionDetails details) {
        //print(details?.totalScale);
        //}
        editorMaskColorHandler: (BuildContext context, bool pointerDown) {
          return Theme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(pointerDown ? 0.1 : 0.2);
        });

    if (widget.localImgUrl != null) {
      return ExtendedImage.file(
        File(widget.localImgUrl),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: editorKey,
        enableLoadState: true,
        cacheRawData: true,
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height - 40,
        initEditorConfigHandler: (ExtendedImageState state) {
          return editorConfig;
        },
        /*initGestureConfigHandler: (ExtendedImageState state) {
          return initGestureConfigHandler(state);
        },*/
      );
    } else {
      return ExtendedImage.network(
        imgPath,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: editorKey,
        enableLoadState: true,
        cacheRawData: true,
        cache: true,
        //width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height - 40,
        initEditorConfigHandler: (ExtendedImageState state) {
          return editorConfig;
        },
        /*initGestureConfigHandler: (ExtendedImageState state) {
          return initGestureConfigHandler(state);
        },*/
      );
    }
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
}
