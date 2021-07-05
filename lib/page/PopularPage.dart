import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/modal/PicInfo.dart';
import 'package:wallpaperdownloader/common/net/ApiUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///受欢迎的，下载量倒序
class PopularPage extends StatefulWidget {
  final String cat;

  const PopularPage({Key key, this.cat}) : super(key: key);

  @override
  PopularPageState createState() => new PopularPageState();
}

class PopularPageState extends State<PopularPage> {
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
    scrollController.dispose();
    super.dispose();
  }

  String operType = 'download';

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
    return WidgetUtil.getListWidget(
        onRefresh, loading, scrollController, imgList, operType, load);
  }
}
