import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class EquipmentPlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/equipment');

  static Future<int> editImg(String picFile) async {
    final int platform =
        await _channel.invokeMethod('editImg', {"picFile": picFile});
    return platform;
  }

  static Future<Map<Object, Object>> saveImage(
      Uint8List imageBytes, String name, String dir,
      {int quality = 80}) async {
    final Map<Object, Object> platform = await _channel.invokeMethod(
        'saveImage', {
      "imageBytes": imageBytes,
      "name": name,
      'dir': dir,
      'quality': quality
    });
    return platform;
  }

  static Future<Map<Object, Object>> saveFile(
      String picFile, String dir) async {
    final Map<Object, Object> platform =
        await _channel.invokeMethod('saveFile', {
      "file": picFile,
      'dir': dir,
    });
    return platform;
  }

  static Future<void> sendBroadcast(String filePath) async {
    await _channel.invokeMethod('sendBroadcast', {
      "filePath": filePath,
    });
    return null;
  }
}
