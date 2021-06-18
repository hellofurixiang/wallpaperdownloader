import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/net/NetUtil.dart';

///方法
class ApiUtil {
  ///获取列表数据
  static void getList(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'getList';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取列表数据
  static void getSearchList(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'getSearchList';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取列表数据
  static void getListByCat(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'getListByCat';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  static void getCatList(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'getCatList';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取数据
  static void getDetailInfo(BuildContext context, Map<String, String> params,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'getDetailInfo';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取数据
  static void changeCollection(BuildContext context, String id,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'changeCollection';

    NetUtil.get(context, url,
        params: {'id': id},
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取数据
  static void removeCollection(BuildContext context, String id,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'removeCollection';

    NetUtil.get(context, url,
        params: {'id': id},
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///获取下一条数据
  static void getNextOrPrePicInfo(BuildContext context, Map<String, Object> params,
      Function successCallBack, Function errorCallBack) {
    String url = Config.address + 'getNextOrPrePicInfo';

    NetUtil.get(context, url,
        params: params,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

}
