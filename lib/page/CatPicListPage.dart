import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/CommonState.dart';
import 'package:wallpaperdownloader/page/widget/AppBarWidget.dart';

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
      body: Column(
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: CommonUtil.getStatusBarHeight(context)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
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
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      widget.cat,
                      style: TextStyle(
                          fontSize: SetConstants.bigTextSize,
                          color: SetColors.black),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: new IconButton(
                      icon: new Icon(
                        Icons.search,
                        color: SetColors.black,
                        size: 40.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
                                cat: widget.cat);
                          },
                          child: new Material(
                            //elevation: 8.0,
                            //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            child: new CachedNetworkImage(
                              imageUrl: imgPath,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
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
    );
  }
}
