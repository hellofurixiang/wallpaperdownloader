import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///搜索输入框
class InputWidget extends StatefulWidget {
  ///初始值
  final String initText;

  ///文本改变事件
  final ValueChanged<String> onChanged;

  ///回车提交事件
  final ValueChanged<String> onSubmitted;

  ///描述文本
  final String hintText;

  ///文字居中
  final bool isCenter;

  ///清除按钮回调
  final Function clearCallBack;

  ///所有边框有阴影效果
  final bool isAllBorder;

  ///显示搜索图标
  final bool isSearch;

  ///自动获取焦点
  final bool isAutofocus;

  ///明文显示
  final bool obscureText;

  final TextEditingController controller;

  ///键盘类型
  final TextInputType keyboardType;

  ///文本框填充颜色
  final Color textFillColor;

  ///文本框父控件填充颜色
  final Color containerFillColor;

  ///空提示
  final bool isShowPrompt;

  ///提示信息
  final String promptText;

  ///字体颜色、大小
  final Color textColor;
  final double textSize;

  ///是否可编辑
  final bool enabled;

  ///数字类型
  final bool isNumber;

  ///最大行数
  final int maxLines;
  final double height;

  final FocusNode focusNode;

  ///简单文本
  final bool isSimple;

  ///文本为空回车不起作用
  final bool isNullReturn;

  final bool showScanIcon;

  InputWidget(
      {this.onChanged,
      this.onSubmitted,
      this.hintText,
      this.isCenter: false,
      this.clearCallBack,
      this.isAllBorder: false,
      this.isSearch: false,
      this.isAutofocus: false,
      this.initText,
      this.obscureText: false,
      this.controller,
      this.keyboardType,
      this.textFillColor: Colors.white,
      this.containerFillColor: Colors.white,
      this.isShowPrompt: false,
      this.promptText,
      this.textColor: Colors.black,
      this.textSize: SetConstants.normalTextSize,
      this.enabled: true,
      this.isNumber: false,
      this.maxLines: 1,
      this.height,
      this.focusNode,
      this.isSimple: false,
      this.isNullReturn: true,
      this.showScanIcon: true});

  @override
  InputWidgetState createState() => new InputWidgetState();
}

class InputWidgetState extends State<InputWidget> {
  FocusNode focusNode;

  @override
  initState() {
    super.initState();

    controller = widget.controller ?? new TextEditingController();
    controller.addListener(() {
      if (controller.text == '') {
        setState(() {
          showClear = false;
        });
      }
    });

    if (null != widget.initText) controller.text = widget.initText;

    if (controller.text != '') {
      showClear = true;
    }
    /*controller.selection = TextSelection.fromPosition(TextPosition(
        affinity: TextAffinity.downstream, offset: controller.text.length));
*/
    if (widget.focusNode == null) {
      focusNode = new FocusNode();
    } else {
      focusNode = widget.focusNode;
    }
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  ///文本控制器
  TextEditingController controller;

  ///回车触发搜索
  bool isEnterSearch = false;

  ///清除图标显示
  bool showClear = false;

  ///回车提交
  void onSubmitted(String v) {
    if (widget.isNullReturn && v.trim().isEmpty) {
      if (widget.isShowPrompt) {
        WidgetUtil.showToast(msg: widget.promptText);
      }
      return;
    }
    //isEnterSearch = true;
    if (null != widget.onSubmitted) widget.onSubmitted(v.trim());
  }

  ///输入内容改变
  void onChanged(String v) {
    setState(() {
      if (v != '') {
        showClear = true;
      } else {
        showClear = false;
      }
    });
    if (null != widget.onChanged) widget.onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [];

    TextInputType keyboardType = widget.keyboardType;

    if (widget.isNumber) {
      inputFormatters = [
        WhitelistingTextInputFormatter(CommonUtil.getRegExp('number'))
      ];

      keyboardType = TextInputType.number;
    } else {
      if (widget.maxLines > 1) {
        keyboardType = TextInputType.multiline;
      }
    }

    Widget clearWidget;
    if (widget.enabled) {
      clearWidget = new GestureDetector(
        onTap: () {
          ///解决报错：invalid text selection: TextSelection(baseOffset: 7, extentOffset: 7
          ///保证在组件build的第一帧时才去触发取消清空内容
          WidgetsBinding.instance
              .addPostFrameCallback((_) => controller.clear());

          controller =
              TextEditingController.fromValue(TextEditingValue(
                ///设置内容
                text: controller.text,

                ///保持光标在最后
                selection: TextSelection.fromPosition(
                  TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: controller.text.length),
                ),
              ));
          if (showClear) {
            if (null != widget.clearCallBack) widget.clearCallBack();
            if (null != widget.onChanged) widget.onChanged('');
          }
          setState(() {
            showClear = false;
          });
        },
        child: showClear?new Icon(
           Icons.clear,
          //SetIcons.barcode_input,
          size: 25.0,
          color: SetColors.black,
        ):Container(),
      );
    }
    InputDecoration inputDecoration;
    if (widget.isSimple) {
      inputDecoration = new InputDecoration(
        suffixIcon: clearWidget,

        ///输入内容距离上下左右的距离 ，可通过这个属性来控制 TextField的高度
        hintText: widget.hintText,
        fillColor:
            widget.enabled ? widget.textFillColor : SetColors.lightLightGrey,
        filled: true,
      );
    } else {
      inputDecoration = new InputDecoration(
        suffixIcon: clearWidget,

        ///输入内容距离上下左右的距离 ，可通过这个属性来控制 TextField的高度
        contentPadding: EdgeInsets.all(widget.enabled && showClear ? 2.0 : 4.0),
        hintText: widget.hintText,
        fillColor:
            widget.enabled ? widget.textFillColor : SetColors.lightLightGrey,
        filled: true,
        // 以下属性可用来去除TextField的边框
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide:
              new BorderSide(color: SetColors.lightLightGrey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: new BorderSide(color: SetColors.transparent, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: new BorderSide(color: SetColors.transparent, width: 1.0),
        ),
      );
    }

    Widget textFieldWidget = new TextField(
        focusNode: focusNode,
        maxLines: widget.maxLines,
        inputFormatters: inputFormatters,
        enabled: widget.enabled,
        style:
            new TextStyle(fontSize: widget.textSize, color: widget.textColor),
        textAlign: widget.isCenter ? TextAlign.center : TextAlign.left,
        autofocus: widget.isAutofocus,
        decoration: inputDecoration,
        controller: controller,
        onChanged: (v) {
          onChanged(v);
        },
        onSubmitted: (v) {
          onSubmitted(v);
        },
        obscureText: widget.obscureText,
        keyboardType: keyboardType);

    if (widget.isSimple) {
      return new Container(height: widget.height, child: textFieldWidget);
    } else {
      return new Container(
        height: widget.height,
        padding: new EdgeInsets.all(0.5),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: SetColors.transparent,
        ),
        //padding: new EdgeInsets.all(10.0),
        child: new Container(
          padding: new EdgeInsets.all(1.0),
          height: widget.maxLines * 24.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: SetColors.transparent,
          ),
          //padding: new EdgeInsets.all(10.0),
          child: textFieldWidget,
        ),
      );
    }
  }
}
