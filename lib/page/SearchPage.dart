import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/page/widget/InputWidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 0);

  int page = 1;
  int load = 0;

  ///信息列表
  List<PicInfo> imgList = [];

  String keyword;

  bool loading = false;

  double width = window.physicalSize.width;
  double height = window.physicalSize.height;

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
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _nativeAdController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String operType = 'search';

  ///加载数据
  Future<void> initData() async {
    Map<String, String> params = {
      'page': page.toString(),
      'size': '20',
      'keyword': keyword,
    };
    ApiUtil.getSearchList(context, params, successCallBack, errorCallBack);
  }

  ///刷新
  Future<void> onRefresh() async {
    setState(() {
      page = 1;
      load = 1;
    });
    initData();
  }

  ///加载更多
  onLoadMore() {
    if (load == 3) return;
    setState(() {
      load = 2;
    });
    page++;
    initData();
  }
  int nativeAdCount = 0;
  ///成功方法处理
  void successCallBack(res) {
    if (res['code'] == '1') {
      setState(() {
        if (page == 1) {
          imgList = [];
        }
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
    setState(() {
      loading = false;
    });
  }

  ///失败处理
  void errorCallBack() {
    setState(() {
      loading = false;
    });
  }

  Widget getLoadWidget() {
    if (loading) {
      return WidgetUtil.getEmptyLoadingWidget();
    } else {
      if (keyword != null && imgList.isEmpty) {
        return Container(
          margin:
              EdgeInsets.only(top: CommonUtil.getScreenHeight(context)) * 0.4,
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
                child: Text('No Wallpaper Found',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: SetColors.white)),
              )
            ],
          ),
        );
      }
    }

    return StaggeredGridView.countBuilder(
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
                picInfo: imgList[i], keyword: keyword);
          },
          child: CachedNetworkImage(
            imageUrl: imgPath,
            imageBuilder: (context, imageProvider) => Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: SetColors.black,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),

              ///限制大小无效是设置此属性
              alignment: Alignment.center,
              child: SvgPicture.asset('assets/pic_error.svg',
                  width: 40.0, height: 40.0, color: SetColors.white),
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

        /*if(index<10) {
          if ((index >= Config.loadAdCount) &&
              (index % Config.loadAdCount == 0)) {
            return StaggeredTile.count(3, 1.5);
          } else {
            return StaggeredTile.count(1, 1.5);
          }
        }else{
          if (
              ((index+1) % (Config.loadAdCount+1) == 0)) {
            return StaggeredTile.count(3, 1.5);
          } else {
            return StaggeredTile.count(1, 1.5);
          }
        }*/
        //横轴和纵轴的数量,控制瀑布流效果
      },
      //mainAxisSpacing: 8.0,
      //crossAxisSpacing: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SetColors.black,
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand, //未定位widget占满Stack整个空间
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      top: CommonUtil.getStatusBarHeight(context)),
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    child: getLoadWidget(),
                  ),
                ),
              ),
              WidgetUtil.getListLoadMoreOffstage(load),
            ],
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: CommonUtil.getScreenWidth(context) - 20,
              margin: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                //top: 10.0,
                top: CommonUtil.getStatusBarHeight(context) + 10,
              ),
              decoration: BoxDecoration(
                  color: SetColors.mainColor,
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: SetColors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      alignment: Alignment.centerLeft,
                      child: InputWidget(
                        textColor: SetColors.white,
                        textSize: SetConstants.bigTextSize,
                        containerFillColor: SetColors.mainColor,
                        textFillColor: SetColors.mainColor,
                        clearColor: SetColors.white,
                        height: 35.0,
                        isAutofocus: true,
                        onSubmitted: (v) {
                          if (v == '') {
                            return;
                          }
                          keyword = v;
                          page = 1;
                          setState(() {
                            loading = true;
                          });
                          initData();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*Positioned(
            bottom: 0.0,
            right: 0.0,
            child: _isAdLoaded
                ? Container(
                    color: SetColors.white,
                    width: CommonUtil.getScreenWidth(context),
                    height: 60.0,
                    child: AdWidget(ad: bannerAd),
                  )
                : Container(),
          ),*/

          Positioned(
            bottom: 0.0,
            right: 0.0,
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
