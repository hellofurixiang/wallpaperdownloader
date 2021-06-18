import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/crop_editor_helper.dart';
import 'package:wallpaperdownloader/page/AdMobService.dart';
import 'package:wallpaperdownloader/page/CommonState.dart';

class PicEditPage extends StatefulWidget {
  final PicInfo picInfo;

  const PicEditPage({
    Key key,
    this.picInfo,
  }) : super(key: key);

  @override
  PicEditPageState createState() => new PicEditPageState();
}

class PicEditPageState extends State<PicEditPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

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

  showRewardedAd() {
    WidgetUtil.showLoadingDialog(context, 'Loading ads...');
    GlobalInfo.instance.setShowBannerAdState(1);
    AdMobService.showRewardedAd(context, () {
      GlobalInfo.instance.setShowBannerAdState(2);
      cropImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    cropAspectRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    //String imgPath = Config.address + 'getFullFileBytesStr?id=' + widget.id;
    String imgPath = Config.downloadUrl +
        widget.picInfo.fileName +
        '_preview.' +
        widget.picInfo.type;
    return new Scaffold(
      backgroundColor: SetColors.black,
      body:

      Stack(
          alignment: Alignment.center,
          fit: StackFit.expand, //未定位widget占满Stack整个空间
          children: <Widget>[
            ExtendedImage.network(
              imgPath,
              fit: BoxFit.contain,
              mode: ExtendedImageMode.editor,
              extendedImageEditorKey: editorKey,
              enableLoadState: true,
              cacheRawData: true,
              //width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height - 40,
              initEditorConfigHandler: (ExtendedImageState state) {
                return EditorConfig(
                    cornerColor: SetColors.white,
                    //裁剪框四角图形的大小
                    cornerSize: Size(20.0, 4.0),
                    //最大的缩放倍数
                    maxScale: 8.0,
                    //裁剪框跟图片 layout 区域之间的距离。最好是保持一定距离，不然裁剪框边界很难进行拖拽
                    cropRectPadding: const EdgeInsets.only(left: 15.0,right: 15.0),
                    //裁剪框四角以及边线能够拖拽的区域的大小
                    hitTestSize: 50.0,
                    lineColor: SetColors.white,
                    lineHeight:2.0,
                    //initCropRectType: InitCropRectType.imageRect,
                    //裁剪框的宽高比
                    cropAspectRatio:
                        CropAspectRatios.ratio3_4, //cropAspectRatio,
                    //editActionDetailsIsChanged: (EditActionDetails details) {
                    //print(details?.totalScale);
                    //}
                    editorMaskColorHandler:(BuildContext context, bool pointerDown){
                      return Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(pointerDown ? 0.1: 0.2);
                    }
                    );
              },
              /*loadStateChanged: (ExtendedImageState state) {
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
              },*/
            ),
            Positioned(
              top:  CommonUtil.getStatusBarHeight(context),
              left: 0.0,
              child: Container(
                //color: SetColors.black,
                child: IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    color: SetColors.white,
                    size: 35.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Positioned(
              top:  CommonUtil.getStatusBarHeight(context),
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  //显示对话框
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text('Set this image as wallpaper?'),
                          actions: [
                            FlatButton(
                              child: Text("YES"),
                              onPressed: () {
                                Navigator.pop(context);
                                showRewardedAd();
                              },
                            )
                          ],
                        );
                      });
                },
                child: Container(
                    height: 50.0,
                    margin: EdgeInsets.only(right: 5.0),
                    alignment: Alignment.center,
                    child: Text(
                      'APPLY WALLPAPER',
                      style: TextStyle(
                          color: SetColors.white,
                          fontSize: SetConstants.middleTextSize,
                          fontWeight: FontWeight.w700),
                    )),
              ),
            ),
          ],
        ),
    );
  }
}
