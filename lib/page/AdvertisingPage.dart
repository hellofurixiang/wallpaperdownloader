import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/PicDetailPage.dart';

///广告
class AdvertisingPage extends StatefulWidget {
  final String cat;

  const AdvertisingPage({Key key, this.cat}) : super(key: key);

  @override
  AdvertisingPageState createState() => new AdvertisingPageState();
}

class AdvertisingPageState extends State<AdvertisingPage> {
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

  String operType = 'advertising';

  ///加载数据
  Future<void> initData(int page) async {
    Map<String, String> params = {
      'page': page.toString(),
      'size': '20',
      'operType': operType,
    };
    ApiUtil.getList(context, params, successCallBack, errorCallBack);
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
    return Column(
      children: <Widget>[
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
                              context, imgList[i].id, operType);
                        },
                        child: new Material(
                          //elevation: 8.0,
                          //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
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
                                  alignment:Alignment.center,
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: SetColors.darkGrey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/failed.jpg",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                top: 5.0,
                                right: 5.0,
                                child: Container(
                                  color: Colors.transparent,
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: SetColors.white,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
