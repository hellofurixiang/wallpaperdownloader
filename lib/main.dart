import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/TelAndSmsService.dart';
import 'package:wallpaperdownloader/page/MainPage.dart';
import 'package:wallpaperdownloader/page/PicEditPage.dart';
import 'package:wallpaperdownloader/page/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdMobService.initialize();

  GetIt.instance.registerSingleton(TelAndSmsService());

  runApp(MyApp());


  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。
    // 写在组件渲染之后，是为了在渲染后进行set赋值,覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final routes = <String, WidgetBuilder>{
    'PicEditPage': (BuildContext context) => new PicEditPage(),
    'MainPage': (BuildContext context) => new MainPage(),
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // 设置这一属性即可去掉右上角debug
      home: SplashScreen(),
      routes: routes,
      theme: ThemeData(
        brightness: Brightness.dark, //指定亮度主题，有白色/黑色两种可选。
        primaryColor: SetColors.black,
      ), //这里我们选蓝色为基准色值。
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
}
