import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share/share.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/FavoritePage.dart';
import 'package:wallpaperdownloader/page/SettingPage.dart';
import 'package:wallpaperdownloader/page/widget/InputWidget.dart';

class FeedbackWidget extends StatefulWidget {
  final double rate;

  const FeedbackWidget({Key key, this.rate}) : super(key: key);

  @override
  FeedbackWidgetState createState() => new FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget> {
  TextEditingController tec = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = CommonUtil.getScreenHeight(context);

    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Opacity(
                  opacity: 0.1,
                  child: Container(
                    color: SetColors.transparent,
                  ),
                )),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: SetColors.mainColor,
              ),
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    alignment: Alignment.centerLeft,
                    height: 60.0,
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                        color: SetColors.white,
                        fontSize: SetConstants.lagerTextSize,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      child:
                          /*InputWidget(
                        controller: tec,
                        textColor: SetColors.white,
                        textSize: SetConstants.bigTextSize,
                        containerFillColor: SetColors.white,
                        textFillColor: SetColors.mainColor,
                        clearColor: SetColors.white,
                        //height: 35.0,
                        maxLines: 3,
                        isAutofocus: true,
                        showClear: false,
                      ),*/

                          TextField(
                        keyboardType: TextInputType.multiline,

                        ///不限制行数
                        maxLines: null,
                            minLines: 3,
                        ///字数限制
                        maxLength: 500,
                        autofocus: true,
                        controller: tec,
                        decoration: InputDecoration(
                          hintText:
                              "Suggest us what went wrong and we'll work on it!",
                          /*border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide:
                                BorderSide(color: SetColors.white, width: 1.0),
                          ),*/
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide:
                                BorderSide(color: SetColors.white, width: 1.0),
                          ),
                        ),

                        /* decoration:InputDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            color: widget.containerFillColor,
                          )*/
                        //maxLines:5, 限制5行
                        //maxLines:null 不限制行数
                      ),
                    ),
                  ),
                  Container(
                    height: 60.0,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: SetColors.darkDarkGrey),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if (tec.text.isEmpty) {
                                return;
                              }
                              if (tec.text.trim().isEmpty) {
                                return;
                              }
                              Navigator.pop(context);
                              //widget.callback(tec.text);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Submit',
                                style: TextStyle(color: SetColors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Opacity(
                  opacity: 0.1,
                  child: Container(
                    color: SetColors.transparent,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
