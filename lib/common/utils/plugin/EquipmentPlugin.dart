import 'dart:async';

import 'package:flutter/services.dart';

class EquipmentPlugin {
  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/equipment');

  static Future<int> editImg(String picFile) async {
    final int platform =
        await _channel.invokeMethod('editImg', {"picFile": picFile});
    return platform;
  }
}
