import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/plugin/EquipmentPlugin.dart';
import 'package:wallpaperdownloader/page/widget/PopupMenuWidget.dart';

class DownloadPicListPage extends StatefulWidget {
  const DownloadPicListPage({
    Key key,
  }) : super(key: key);

  @override
  DownloadPicListPageState createState() => new DownloadPicListPageState();
}

class DownloadPicListPageState extends State<DownloadPicListPage> {
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 0);

  ///信息列表
  List<String> imgList = [];

  final _nativeAdController = NativeAdmobController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var px = scrollController.position.pixels;
      if (px == scrollController.position.maxScrollExtent) {
        //onLoadMore();
      }
    });
    initData();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _nativeAdController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String operType = 'cat';

  ///加载数据
  Future<void> initData() async {
    Directory myImageDir =
        await Directory(ConstantConfig.saveImageDirForAndroid).create();

    List<FileSystemEntity> listOfFiles =
        await myImageDir.list(recursive: true).toList();
    imgList.clear();
    for (int i = 0; i < listOfFiles.length; i++) {
      setState(() {
        imgList.add(listOfFiles[i].path);
        /*if (imgList.length == ConstantConfig.loadAdCount) {
          imgList.add('');
          nativeAdCount += 1;
        } else if (imgList.length > ConstantConfig.loadAdCount &&
            (imgList.length - nativeAdCount) % ConstantConfig.loadAdCount ==
                0) {
          imgList.add('');
          nativeAdCount += 1;
        }*/
      });
    }
  }

  int nativeAdCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SetColors.black,
      body: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            margin: EdgeInsets.only(
                top: CommonUtil.getStatusBarHeight(context), bottom: 5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      color: SetColors.transparent,
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back,
                        color: SetColors.white,
                        size: 35.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'My Download',
                      style: TextStyle(
                          fontSize: SetConstants.bigTextSize,
                          color: SetColors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: new Container(
                    color: SetColors.transparent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: getLoadWidget(),
          ),
          Container(
            height: 60,
            width: CommonUtil.getScreenWidth(context),
            //padding: EdgeInsets.all(10),
            //margin: EdgeInsets.only(bottom: 20.0),
            child: WidgetUtil.createNativeAdmob(NativeAdmobType.banner),
          ),
        ],
      ),
    );
  }

  Widget getLoadWidget() {
    if (imgList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: CommonUtil.getScreenHeight(context)) * 0.4,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                'Whoops!!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: SetColors.white),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text('No Wallpaper Download',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: SetColors.white)),
            )
          ],
        ),
      );
    }

    return StaggeredGridView.countBuilder(
      controller: scrollController,
      padding: EdgeInsets.all(2),
      crossAxisCount: 3,
      itemCount: imgList.length,
      //mainAxisSpacing : 5.0,
      //crossAxisSpacing : 10.0,
      itemBuilder: (context, i) {
        ///广告
        if (imgList[i] == '') {
          return Container(
            //color: SetColors.white,
            //height: 60,
            //width: CommonUtil.getScreenWidth(context),
            //padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: WidgetUtil.createNativeAdmob(NativeAdmobType.full),
          );
        }
        return GestureDetector(
          onTap: () {
            //AdMobService.showInterstitialAd();
            //WidgetUtil.goDetailPage(context, operType,
            //picInfo: imgList[i], cat: widget.cat);
            clickImageFun(i);
          },
          child: ExtendedImage.file(
            File(imgList[i]),
            fit: BoxFit.fill,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (ExtendedImageState state) {
              return initGestureConfigHandler(state);
            },
            loadStateChanged: (ExtendedImageState state) {
              return loadStateChanged(state);
            },
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        /*if (((index + 1) % (ConstantConfig.loadAdCount + 1) == 0)) {
          return StaggeredTile.count(3, 2);
        } else {*/
          return StaggeredTile.count(1, 1.5);
        //}
        //横轴和纵轴的数量,控制瀑布流效果
      },
      //mainAxisSpacing: 8.0,
      //crossAxisSpacing: 8.0,
    );
  }

  clickImageFun(int index) {
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        barrierColor: SetColors.transparent,
        builder: (BuildContext context) {
          return new PopupMenuWidget(
              containerColor: SetColors.mainColor,
              fontColor: SetColors.white,
              isCenter: true,
              itemList: ['View', 'Set As Wallpaper', 'Share', 'Delete'],
              callBack: (menuIndex) async {
                Navigator.pop(context);
                if (menuIndex == 0) {
                  EquipmentPlugin.editImg('file://' + imgList[index]);
                } else if (menuIndex == 1) {
                  File file = File(imgList[index]);
                  if (file.existsSync()) {
                    int location = WallpaperManagerFlutter
                        .HOME_SCREEN; //Choose screen type
                    await WallpaperManagerFlutter()
                        .setwallpaperfromFile(file, location);
                  }
                } else if (menuIndex == 2) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  Share.share(ConstantConfig.shareStr,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                } else if (menuIndex == 3) {
                  WidgetUtil.showAlertDialog(
                      context, 'Do you want to delete this wallpaper?', () {
                    deleteFile(index);
                  });
                }
              });
        });
  }

  deleteFile(int index) async {
    File file = File(imgList[index]);
    file.deleteSync();
    initData();
    await EquipmentPlugin.sendBroadcast(imgList[index]);
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
        return Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: SetColors.black,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            fit: BoxFit.fill,
            //width: 300,
            //height: 300,
          ),
        );
        break;
      case LoadState.failed:
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
