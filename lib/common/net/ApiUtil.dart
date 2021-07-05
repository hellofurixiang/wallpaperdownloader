import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/net/NetUtil.dart';

///方法
class ApiUtil {
  ///获取列表数据
  static void getList(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'getList';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取列表数据
  static void getSearchList(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'getSearchList';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取列表数据
  static void getListByCat(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'getListByCat';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  static void getCatList(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'getCatList';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取数据
  static void getDetailInfo(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'getDetailInfo';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取数据
  static void changeCollection(BuildContext context, String id,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'changeCollection';

    NetUtil.get(context, url,
        params: {'id': id},
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///更新收藏数
  static void removeCollection(BuildContext context, String id,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'removeCollection';

    NetUtil.get(context, url,
        params: {'id': id},
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///更新下载数
  static void changeDownload(BuildContext context, String id,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'changeDownload';

    NetUtil.get(context, url,
        params: {'id': id},
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///更新设置壁纸数
  static void changeSetWallpaperCount(BuildContext context, String id,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'changeSetWallpaperCount';

    NetUtil.get(context, url,
        params: {'id': id},
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }


  ///获取下一条数据
  static void getNextOrPrePicInfo(BuildContext context, Map<String, Object> params,
      Function successCallBack, Function errorCallBack) {
    String url = ConstantConfig.address + 'getNextOrPrePicInfo';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

}
