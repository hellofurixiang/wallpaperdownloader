import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/CatInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/CatPicListPage.dart';

class CatListPage extends StatefulWidget {
  final String cat;

  const CatListPage({Key key, this.cat}) : super(key: key);

  @override
  CatListPageState createState() => new CatListPageState();
}

class CatListPageState extends State<CatListPage> {
  ScrollController scrollController =
      new ScrollController(initialScrollOffset: 0);

  int page = 1;
  int load = 0;

  bool loading = true;

  ///信息列表
  List<CatInfo> imgList = [];

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
    super.dispose();
  }

  ///加载数据
  Future<void> initData(int page) async {
    Map<String, String> params = {
      'page': page.toString(),
      'size': '5',
    };
    ApiUtil.getCatList(context, params, successCallBack, errorCallBack);
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

  ///成功方法处理
  void successCallBack(res) {
    if (res['code'] == '1') {
      if (page == 1) {
        imgList = [];
      }
      setState(() {
        loading = false;
        for (int i = 0; i < res['resBody'].length; i++) {
          imgList.add(CatInfo.fromJson(res['resBody'][i]));
        }
      });

      if (res['resBody'] == null || res['resBody'].length == 0) {
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
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: loading
                ? WidgetUtil.getEmptyLoadingWidget()
                : ListView.builder(
                    controller: scrollController,
                    itemBuilder: (context, i) {
                      String imgPath = Config.downloadUrl +
                          imgList[i].fileName +
                          '_thumbnail.' +
                          imgList[i].type;

                      return GestureDetector(
                        onTap: () {
                          //AdMobService.showInterstitialAd();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CatPicListPage(cat: imgList[i].cat);
                          }));
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: new CachedNetworkImage(
                                imageUrl: imgPath,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: SetColors.darkDarkGrey,
                                  size: 40.0,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(4.0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    Container(
                                        child: Text(
                                      imgList[i].cat,
                                      style: TextStyle(
                                          fontSize: SetConstants.bigTextSize,
                                          color: SetColors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    Container(
                                        child: Text(
                                      imgList[i].count +
                                          ' wallpaperdownloaders',
                                      style: TextStyle(
                                        fontSize: SetConstants.bigTextSize,
                                        color: SetColors.white,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: imgList.length,
                  ),
          ),
        ),
        WidgetUtil.getListLoadMoreOffstage(load),
      ],
    );
  }
}
