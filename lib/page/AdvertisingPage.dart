import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

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
      'size': ConstantConfig.pageSize,
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
  int nativeAdCount = 0;
  ///成功方法处理
  void successCallBack(res) {
    if (res[ConstantConfig.code] == '1') {
      if (page == 1) {
        imgList = [];
      }
      setState(() {
        loading = false;
        for (int i = 0; i < res[ConstantConfig.resBody]['records'].length; i++) {
          imgList.add(PicInfo.fromJson(res[ConstantConfig.resBody]['records'][i]));
          if (imgList.length == ConstantConfig.loadAdCount) {
            imgList.add(PicInfo.nativeAd('-1'));
            nativeAdCount += 1;
          } else if (imgList.length > ConstantConfig.loadAdCount &&
              (imgList.length - nativeAdCount) % ConstantConfig.loadAdCount == 0) {
            imgList.add(PicInfo.nativeAd('-1'));
            nativeAdCount += 1;
          }
        }
      });

      if (res[ConstantConfig.resBody]['records'] == null ||
          res[ConstantConfig.resBody]['records'].length == 0) {
        load = 3;
      } else {
        load = 0;
      }
    } else {
      WidgetUtil.showToast(msg: res[ConstantConfig.message]);
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
    return WidgetUtil.getListWidget(
        onRefresh, loading, scrollController, imgList, operType, load);
  }
}
