import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';

///页面跳转服务类
class NavigatorUtil {

  ///页面跳转
  static goToPage(BuildContext context, Widget url,
      {String permissions, String permissionsText:'',Function backCall}) async {

      Navigator.push(context, new MaterialPageRoute(builder: (context) => url))
          .then((Object obj) {
        if (null != backCall) backCall(obj);
      });
  }

  static pushNamedAndRemoveUntil(BuildContext context, String urlName) async {
    Navigator.pushNamedAndRemoveUntil(
        context, urlName, (route) => route == null);
  }

  static pushReplacementNamed(BuildContext context, String urlName) async {
    Navigator.pushReplacementNamed(context, urlName);
  }

}
