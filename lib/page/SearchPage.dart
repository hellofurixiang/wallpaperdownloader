import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/AdMobService.dart';
import 'package:wallpaperdownloader/page/widget/InputWidget.dart';
import 'package:wallpaperdownloader/page/CommonState.dart';

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
    super.dispose();
    scrollController.dispose();
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

  ///成功方法处理
  void successCallBack(res) {
    if (res['code'] == '1') {
      if (page == 1) {
        imgList = [];
      }
      setState(() {
        for (int i = 0; i < res['resBody']['records'].length; i++) {
          imgList.add(PicInfo.fromJson(res['resBody']['records'][i]));
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
              Container(
                margin: EdgeInsets.only(
                    top: CommonUtil.getStatusBarHeight(context)),
                color: SetColors.black,
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
                          textColor: SetColors.black,
                          textSize: SetConstants.bigTextSize,
                          containerFillColor: SetColors.white,
                          textFillColor: SetColors.white,
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
                            String imgPath = WidgetUtil.getPicUrl(imgList[i]);
                            return GestureDetector(
                              onTap: () {
                                //AdMobService.showInterstitialAd();
                                WidgetUtil.goDetailPage(
                                    context, imgList[i].id, operType,
                                    keyword: keyword);
                              },
                              child: Material(
                                //elevation: 8.0,
                                //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                child: CachedNetworkImage(
                                  imageUrl: imgPath,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: SetColors.darkGrey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (int index) {
                            return StaggeredTile.count(1, 2); //横轴和纵轴的数量,控制瀑布流效果
                          },
                          //mainAxisSpacing: 8.0,
                          //crossAxisSpacing: 8.0,
                        ),
                ),
              ),
              WidgetUtil.getListLoadMoreOffstage(load),
            ],
          ),
          /*Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Container(
              height: 50,
              width: 320,
              alignment: Alignment.center,
              child: AdWidget(ad: AdMobService.createBannerAd()..load()),
            ),
          ),*/
        ],
      ),
    );
  }
}
