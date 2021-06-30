import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///设置
class SettingPage extends StatefulWidget {
  const SettingPage({
    Key key,
  }) : super(key: key);

  @override
  SettingPageState createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    loadCache();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SetColors.black,
        body: Column(
          children: [
            Container(
              width: CommonUtil.getScreenWidth(context),
              margin: EdgeInsets.only(
                top: CommonUtil.getStatusBarHeight(context),
              ),
              decoration: BoxDecoration(
                  //color: SetColors.black,
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: SetColors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text('Settings',
                          style: TextStyle(
                              color: SetColors.white,
                              fontSize: SetConstants.middleTextSize)),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0),
                    height: 60.0,
                    alignment: Alignment.centerLeft,
                    child: Text('Clear Cache',
                        style: TextStyle(
                            color: SetColors.white,
                            fontSize: SetConstants.middleTextSize)),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(right: 15.0),
                    alignment: Alignment.centerRight,
                    child: Text(_cacheSize,
                        style: TextStyle(color: SetColors.white)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      WidgetUtil.showConfirmDialog(
                          context, 'Are you sure want to clear cache?', () {
                        _clearCache();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 15.0),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.delete,
                        color: SetColors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            WidgetUtil.getDivider(height: 0.5, color: SetColors.white),
            GestureDetector(
              onTap: () {
                WidgetUtil.showAlertDialogForAbout(context);
              },
              child: Container(
                color: SetColors.transparent,
                padding: EdgeInsets.only(left: 15.0),
                height: 60.0,
                alignment: Alignment.centerLeft,
                child: Text(
                  'About',
                  style: TextStyle(
                      color: SetColors.white,
                      fontSize: SetConstants.middleTextSize),
                ),
              ),
            ),
            WidgetUtil.getDivider(height: 0.5, color: SetColors.white),
          ],
        ));
  }

  String _cacheSize = '0 Bytes';

  ///加载缓存
  Future<Null> loadCache() async {
    try {
      Directory _tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(_tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      //print('临时目录大小: ' + value.toString());
      setState(() {
        _cacheSize = _renderSize(value);
      });
    } catch (err) {
      //print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      //print(e);
      return 0;
    }
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      //print(e);
    }
  }

  ///格式化文件大小
  _renderSize(double value) {
    if (null == value || value == 0) {
      return '0 Bytes';
    }
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  Future _clearCache() async {
    //此处展示加载loading
    try {
      Directory _tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(_tempDir);
      //print("$value");
      /*if (value <= 0) {
        WidgetUtil.showToast(msg: 'No cache');
      } else if (value >= 0) {*/
      WidgetUtil.showLoadingDialog(context, text: 'Clearing cache...');
      Future.delayed(Duration(seconds: 2), () async {
        //删除缓存目录
        await delDir(_tempDir);
        await loadCache();
        Navigator.pop(context);
        WidgetUtil.showToast(msg: 'Cache has been cleared');
      });
      //}
    } catch (e) {
      //LogUtils.e(e);
      WidgetUtil.showToast(msg: 'Clear error:' + e);
    } finally {}
  }
}
