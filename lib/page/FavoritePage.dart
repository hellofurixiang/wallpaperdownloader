import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/HangInfoProvider.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

class FavoritePage extends StatefulWidget {
  final String cat;

  const FavoritePage({Key key, this.cat}) : super(key: key);

  @override
  FavoritePageState createState() => new FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  ///信息列表
  List<HangInfoEntity> imgList = [];

  HangInfoProvider provider = new HangInfoProvider();

  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }
  int nativeAdCount = 0;
  ///加载数据
  Future<void> initData() async {
    List<HangInfoEntity> list = await provider.findAll();

    setState(() {
      //imgList = list;
      for (int i = 0; i < list.length; i++) {
        imgList.add(list[i]);
        if (imgList.length == Config.loadAdCount) {
          imgList.add(HangInfoEntity.nativeAd('-1'));
          nativeAdCount += 1;
        } else if (imgList.length > Config.loadAdCount &&
            (imgList.length - nativeAdCount) % Config.loadAdCount == 0) {
          imgList.add(HangInfoEntity.nativeAd('-1'));
          nativeAdCount += 1;
        }
      }
      isLoad = true;
    });
  }

  String operType = 'favorite';

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
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Favorite',
                      style: TextStyle(
                          fontSize: SetConstants.bigTextSize,
                          color: SetColors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: new Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: (isLoad && imgList.isEmpty)
                ? Container(
                    margin: EdgeInsets.only(
                      top: CommonUtil.getScreenHeight(context) * 0.4,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: SvgPicture.asset('assets/brokenHeart.svg',
                                width: 40.0,
                                height: 40.0,
                                color: SetColors.white)),
                        Container(
                          alignment: Alignment.center,
                          child: Text('What is your favorite...?',
                              style: TextStyle(color: SetColors.white)),
                        )
                      ],
                    ),
                  )
                : StaggeredGridView.countBuilder(
                    padding: EdgeInsets.all(2),
                    crossAxisCount: 3,
                    itemCount: imgList.length,
                    itemBuilder: (context, i) {
                      ///广告
                      if (imgList[i].imgId == '-1') {
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
                      String imgPath = Config.downloadUrl + imgList[i].fileName;
                      return GestureDetector(
                        onTap: () {
                          //AdMobService.showInterstitialAd();
                          WidgetUtil.goDetailPage(context, operType,
                              id: imgList[i].imgId,
                              fileName: imgList[i].fileName);
                        },
                        child: new CachedNetworkImage(
                          imageUrl: imgPath,
                          imageBuilder: (context, imageProvider) => Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: SetColors.black,
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
                    },
                    //mainAxisSpacing: 8.0,
                    //crossAxisSpacing: 8.0,
                  ),
          ),
        ],
      ),
    );
  }
}
