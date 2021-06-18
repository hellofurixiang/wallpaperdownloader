import 'dart:async';

import 'package:flutter/material.dart';

class ShowProgressWidget extends StatefulWidget {
  ShowProgressWidget(this.requestCallback);

  final Future<Null> requestCallback; //这里Null表示回调的时候不指定类型
  @override
  _ShowProgressWidgetState createState() => new _ShowProgressWidgetState();
}

class _ShowProgressWidgetState extends State<ShowProgressWidget> {
  @override
  initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 10), () {
      //每隔10ms回调一次
      widget.requestCallback.then((Null) {
        //这里Null表示回调的时候不指定类型
        Navigator.of(context).pop(); //所以pop()里面不需要传参,这里关闭对话框并获取回调的值
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new CircularProgressIndicator(), //获取控件实例
    );
  }
}
