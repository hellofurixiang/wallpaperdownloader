import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/SearchPage.dart';

class CatPicListPage extends StatefulWidget {
  final String cat;

  const CatPicListPage({Key key, this.cat}) : super(key: key);

  @override
  CatPicListPageState createState() => new CatPicListPageState();
}

class CatPicListPageState extends State<CatPicListPage> {
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 0);

  int page = 1;
  int load = 0;

  bool loading = true;

  ///信息列表
  List<PicInfo> imgList = [];

  final _nativeAdController = NativeAdmobController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var px = scrollController.position.pixels;
      if (px == scrollController.position.maxScrollExtent) {
        onLoadMore();
      }
    });
    initData(page);
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
  Future<void> initData(int page) async {
    Map<String, String> params = {
      'page': page.toString(),
      'size': '20',
      'cat': widget.cat,
    };
    ApiUtil.getListByCat(context, params, successCallBack, errorCallBack);
  }

  ///刷新
  Future<void> onRefresh() async {
    setState(() {
      page = 1;
      load = 1;
    });
    initData(page);
  }

  ///加载更多
  onLoadMore() {
    if (load == 3) return;
    setState(() {
      load = 2;
    });
    page++;
    initData(page);
  }
  int nativeAdCount = 0;
  ///成功方法处理
  void successCallBack(res) {
    if (res['code'] == '1') {
      if (page == 1) {
        imgList = [];
      }
      setState(() {
        loading = false;
        for (int i = 0; i < res['resBody']['records'].length; i++) {
          imgList.add(PicInfo.fromJson(res['resBody']['records'][i]));
          if (imgList.length == Config.loadAdCount) {
            imgList.add(PicInfo.nativeAd('-1'));
            nativeAdCount += 1;
          } else if (imgList.length > Config.loadAdCount &&
              (imgList.length - nativeAdCount) % Config.loadAdCount == 0) {
            imgList.add(PicInfo.nativeAd('-1'));
            nativeAdCount += 1;
          }
        }
      });

      if (res['resBody']['records'] == null ||
          res['resBody']['records'].length == 0) {
        load = 3;
      } else {
        load = 0;
      }
    } else {
      WidgetUtil.showToast(msg: res['message']);
    }
  }

  ///失败处理
  void errorCallBack() {
    setState(() {
      loading = false;
    });
  }

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
                      widget.cat,
                      style: TextStyle(
                          fontSize: SetConstants.bigTextSize,
                          color: SetColors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return SearchPage();
                      }));
                    },
                    child: new Container(
                      color: SetColors.transparent,
                      margin: EdgeInsets.only(right: 15.0),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('assets/search.svg',
                          width: 25.0, height: 25.0, color: SetColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: loading
                  ? WidgetUtil.getEmptyLoadingWidget()
                  : StaggeredGridView.countBuilder(
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
                                picInfo: imgList[i], cat: widget.cat);
                          },
                          child: CachedNetworkImage(
                            imageUrl: imgPath,
                            imageBuilder: (context, imageProvider) => Container(
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
          ),
          WidgetUtil.getListLoadMoreOffstage(load),
          Container(
            height: 60,
            width: CommonUtil.getScreenWidth(context),
            //padding: EdgeInsets.all(10),
            //margin: EdgeInsets.only(bottom: 20.0),
            child: NativeAdmob(
              loading: Center(
                child: CircularProgressIndicator(
                  color: SetColors.white,
                ),
              ),
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
        ],
      ),
    );
  }
}
