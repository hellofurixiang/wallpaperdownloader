import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/crop_editor_helper.dart';

class PicEditDemoPage extends StatefulWidget {
  final PicInfo picInfo;

  const PicEditDemoPage({
    Key key,
    this.picInfo,
  }) : super(key: key);

  @override
  PicEditDemoPageState createState() => new PicEditDemoPageState();
}

class PicEditDemoPageState extends State<PicEditDemoPage> {
  @override
  void initState() {
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
          result['filePath'], WallpaperManager.BOTH_SCREENS);

      WidgetUtil.showToast(msg: setWallpaperResult);

    } catch (e) {
      WidgetUtil.showToast(msg: 'Set wallpaper error!');
      //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //String imgPath = Config.address + 'getFullFileBytesStr?id=' + widget.id;
    String imgPath = Config.downloadUrl +
        widget.picInfo.fileName +
        '.' +
        widget.picInfo.type;
    return new Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(
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
              initEditorConfigHandler: (ExtendedImageState state) {
                return EditorConfig(
                    cornerColor: SetColors.mainColor,
                    maxScale: 8.0,
                    cropRectPadding: const EdgeInsets.all(10.0),
                    hitTestSize: 20.0,
                    initCropRectType: InitCropRectType.imageRect,
                    cropAspectRatio: CropAspectRatios.ratio3_4,
                    editActionDetailsIsChanged: (EditActionDetails details) {
                      //print(details?.totalScale);
                    });
              },
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              child: Container(
                width: CommonUtil.getScreenWidth(context),
                color: SetColors.mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: new Icon(
                        Icons.arrow_back,
                        color: SetColors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    GestureDetector(
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
                                      cropImage();
                                    },
                                  )
                                ],
                              );
                            });
                      },
                      child: Container(
                          height: 40.0,
                          margin: EdgeInsets.only(right: 5.0),
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text(
                            'APPLY WALLPAPER',
                            style: TextStyle(
                                color: SetColors.white,
                                fontSize: SetConstants.middleTextSize),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            /*Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Container(
                width: CommonUtil.getScreenWidth(context),
                color: SetColors.mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    *//*Container(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.crop,
                        color: SetColors.white,
                      ),
                      onPressed: () {
                        cropImage();
                      },
                      label: Text(
                        'Crop',
                        style: TextStyle(color: SetColors.white),
                      ),
                    )),*//*
                    Container(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.flip,
                        color: SetColors.white,
                      ),
                      label: Text('Flip',
                          style: TextStyle(color: SetColors.white)),
                      onPressed: () {
                        editorKey.currentState.flip();
                      },
                    )),
                    Container(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.rotate_left,
                        color: SetColors.white,
                      ),
                      label: Text('Rotate Left',
                          style: TextStyle(color: SetColors.white)),
                      onPressed: () {
                        editorKey.currentState.rotate(right: false);
                      },
                    )),
                    Container(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.rotate_right,
                        color: SetColors.white,
                      ),
                      label: Text('Rotate Right',
                          style: TextStyle(color: SetColors.white)),
                      onPressed: () {
                        editorKey.currentState.rotate(right: true);
                      },
                    )),
                    Container(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.refresh,
                        color: SetColors.white,
                      ),
                      label: Text('Reset',
                          style: TextStyle(color: SetColors.white)),
                      onPressed: () {
                        editorKey.currentState.reset();
                      },
                    )),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
