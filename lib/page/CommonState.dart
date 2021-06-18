import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/local/GlobalInfo.dart';
import 'package:wallpaperdownloader/page/widget/BannerAdWidget.dart';

///通用State
abstract class CommonState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    int showBannerAdState = GlobalInfo.instance.getShowBannerAdState();
    //print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        if (showBannerAdState == 0) {
          GlobalInfo.instance.setShowBannerAdState(2);
          showDialog<Null>(
              context: context, //BuildContext对象
              barrierDismissible: false,
              builder: (BuildContext context) {
                return BannerAdWidget();
              });
        } else if (showBannerAdState == 2) {
          GlobalInfo.instance.setShowBannerAdState(0);
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        /*if (showBannerAdState == 2) {
          GlobalInfo.instance.setShowBannerAdState(0);
        }*/
        break;
      /*case AppLifecycleState.suspending: // 申请将暂时暂停
        break;*/
      default:
        break;
    }
  }
}
