import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

/// 使用 File api
import 'dart:io';

/// 使用 DefaultCacheManager 类（可能无法自动引入，需要手动引入）
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///通用逻辑
class CommonUtil {
  ///获取屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  ///获取屏幕宽度
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getStatusBarHeight(context) {
    return MediaQuery.of(context).padding.top;
    //await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

  ///获取正则表达式
  static getRegExp(String type) {
    return RegExp(
        r'^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$');
  }

  ///为空判断
  static bool isEmpty(Object obj) {
    if (null == obj || '' == obj.toString().trim()) {
      return true;
    }
    return false;
  }

  ///不为空判断
  static bool isNotEmpty(Object obj) {
    return !isEmpty(obj);
  }

  /// 保存图片到相册
  ///
  ///下载网络图片
  static Future<String> saveImage(BuildContext context, String imageUrl) async {
    try {
      /// 权限检测
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus != PermissionStatus.granted) {
        storageStatus = await Permission.storage.request();
        if (storageStatus != PermissionStatus.granted) {
          throw '无法存储图片，请先授权！';
        }
      }

      /// 保存的图片数据
      Uint8List imageBytes;

      /// 保存网络图片
      CachedNetworkImage image = CachedNetworkImage(imageUrl: imageUrl);
      DefaultCacheManager manager = image.cacheManager ?? DefaultCacheManager();
      Map<String, String> headers = image.httpHeaders;
      File file = await manager.getSingleFile(
        image.imageUrl,
        headers: headers,
      );
      imageBytes = await file.readAsBytes();

      /// 保存图片
      final result = await ImageGallerySaver.saveImage(imageBytes);

      if (result == null || result == '') throw '图片保存失败';
      Navigator.pop(context);

      WidgetUtil.showToast(msg: 'Download successful');



      return result['filePath'].toString();


    } catch (e) {
      Navigator.pop(context);
      //print(e.toString());
    }
    return null;
  }


  void Devinfo() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;


    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    print(iosDeviceInfo.identifierForVendor);
    print(iosDeviceInfo.localizedModel);
    print(iosDeviceInfo.model);
    print(iosDeviceInfo.name);
    print(iosDeviceInfo.systemVersion);
    print(iosDeviceInfo.systemName);

    // print(androidInfo.androidId);// Android硬件设备ID。
    // print(androidInfo.manufacturer); // 产品/硬件的制造商。
    // print(androidInfo.device); //设备名称
    // print(androidInfo.model); //最终产品的最终用户可见名称。
    // print(androidInfo.board);//设备基板名称
    // print(androidInfo.bootloader); //获取设备引导程序版本号
    // print(androidInfo.product); //整个产品的名称
  }

}
