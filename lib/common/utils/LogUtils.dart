import 'package:let_log/let_log.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';

class LogUtils {
  static void i(String tag, String message) {
    if (ConstantConfig.isDebug) {
      Logger.log(tag, message);
    }
  }

  static void w(String tag, String message) {
    if (ConstantConfig.isDebug) {
      Logger.warn(tag, message);
    }
  }

  static void e(String tag, String message) {
    if (ConstantConfig.isDebug) {
      Logger.error(tag, message);
    }
  }
}
