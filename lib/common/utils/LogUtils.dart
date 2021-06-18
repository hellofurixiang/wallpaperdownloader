import 'package:let_log/let_log.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';

class LogUtils {
  static void i(String tag, String message) {
    if (Config.isDebug) {
      Logger.log(tag, message);
    }
  }

  static void w(String tag, String message) {
    if (Config.isDebug) {
      Logger.warn(tag, message);
    }
  }

  static void e(String tag, String message) {
    if (Config.isDebug) {
      Logger.error(tag, message);
    }
  }
}
