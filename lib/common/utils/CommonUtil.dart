import 'dart:convert';

/// 使用 File api
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/net/Code.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/common/utils/plugin/EquipmentPlugin.dart';

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
  static Future<String> saveImage(BuildContext context, String imageUrl,
      String fileName, String type) async {
    /// 权限检测
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus != PermissionStatus.granted) {
        WidgetUtil.showToast(
            msg: 'Cannot save picture, please authorize first！');
        return null;
      }
    }
    ProgressDialog progressDialog = new ProgressDialog(context,
        type: ProgressDialogType.Download, isDismissible: false);
    progressDialog.style(message: 'Downloading...');
    try {
      ///创建DIO
      Dio dio = new Dio();

      await Directory(ConstantConfig.saveImageDirForAndroid).create();

      String filePath =
          '${ConstantConfig.saveImageDirForAndroid}/$fileName.$type';

      progressDialog.update(progress: 0.0);

      progressDialog.show();

      ///参数一 文件的网络储存URL
      ///参数二 下载的本地目录文件
      ///参数三 下载监听
      Response response = await dio.download(imageUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          progressDialog.update(
              progress: received.toDouble(), maxProgress: total.toDouble());
        }
      });

      progressDialog.hide();

      if (response.statusCode != Code.SUCCESS) {
        throw '图片保存失败';
      }

      WidgetUtil.showToast(msg: 'Download successful');

      return filePath;
    } catch (e) {
      if (progressDialog.isShowing()) {
        progressDialog.hide();
      }
      //Navigator.pop(context);
      WidgetUtil.showToast(
          msgType: ConstantConfig.error, msg: 'Download error');
      //print(e.toString());
    }
    return null;
  }

  void Devinfo() async {
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

  static Uint8List encode(String s) {
    var encodedString = utf8.encode(s);
    var encodedLength = encodedString.length;
    var data = ByteData(encodedLength + 4);
    data.setUint32(0, encodedLength, Endian.big);
    var bytes = data.buffer.asUint8List();
    bytes.setRange(4, encodedLength + 4, encodedString);
    return bytes;
  }
}
