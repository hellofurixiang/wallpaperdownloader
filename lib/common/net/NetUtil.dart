import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperdownloader/common/config/ConstantConfig.dart';
import 'package:wallpaperdownloader/common/net/Code.dart';
import 'package:wallpaperdownloader/common/style/StringZh.dart';
import 'package:wallpaperdownloader/common/utils/LogUtils.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';

///网络请求
class NetUtil {
  static String logTag = 'NetUtil';

  ///get请求
  static void get(BuildContext context, String url,
      {Object params,
        String contentType,
        ResponseType responseType,
        Function successCallBack,
        Function errorCallBack}) async {
    request(context, url, ConstantConfig.method_get,
        params: params,
        contentType: contentType,
        responseType: responseType,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///post请求
  static void post(BuildContext context, String url,
      {Object params,
        String contentType,
        ResponseType responseType,
        Function successCallBack,
        Function errorCallBack}) async {
    request(context, url, ConstantConfig.method_post,
        params: params,
        contentType: contentType,
        responseType: responseType,
        successCallBack: successCallBack,
        errorCallBack: errorCallBack);
  }

  ///请求头初始化
  static Map<String, String> headers = {
    'x-user-agent': 'mobile-web-app',
    'Source': 'Android',
    'Accept': 'application/json'
  };

  ///获取请求头
  static Future<Map<String, String>> getHeaders() async {
    //var brandModel = await DeviceUtil.getBrandModel();
    //var identity = await DeviceUtil.getIdentity();
    //var token = await MySelfInfo.getToken();
    //var sob = await MySelfInfo.getSob();

    //headers['Device'] = brandModel ?? '';
    //headers['DeviceId'] = identity ?? '';
    //headers['x-user-token'] = token ?? '';
    //headers['x-request-datasource'] = sob;

    return headers;
  }

  ///Content-Type
  ///text/html：HTML格式
  ///text/pain：纯文本格式
  ///image/jpeg：jpg图片格式
  ///application/json：JSON数据格式
  ///application/octet-stream：二进制流数据（如常见的文件下载）
  ///application/x-www-form-urlencoded：form表单encType属性的默认格式，表单数据将以key/value的形式发送到服务端
  ///multipart/form-data：表单上传文件的格式

  ///请求配置
  static getBaseOptions({String contentType,
    ResponseType responseType,
    String method}) async {
    await getHeaders();

    LogUtils.i(logTag, '<net> headers:');
    headers.forEach((key, value) => LogUtils.i(logTag, '$key:$value'));
    LogUtils.i(logTag, '<net> headers end');

    Options options = new Options();

    ///网络文件的类型和网页的编码
    if (contentType != null) {
      options.contentType = contentType;
    }

    ///接收格式
    if (responseType != null) {
      options.responseType = responseType;
    }

    ///请求头
    options.headers.addAll(headers);

    ///超时时间
    options.sendTimeout = ConstantConfig.connectTimeout;
    options.receiveTimeout = ConstantConfig.receiveTimeout;

    options.method = method ?? ConstantConfig.method_get;

    return options;
  }

  ///请求配置
  static getOptions({String contentType,
    ResponseType responseType,
    String method}) async {
    await getHeaders();

    LogUtils.i(logTag, '<net> headers:');
    headers.forEach((key, value) => LogUtils.i(logTag, '$key:$value'));
    LogUtils.i(logTag, '<net> headers end');

    Options options = new Options();

    ///网络文件的类型和网页的编码
    if (contentType != null) {
      options.contentType = contentType;
    }

    ///接收格式
    if (responseType != null) {
      options.responseType = responseType;
    }

    ///请求头
    //options.headers.addAll(headers);

    ///超时时间
    options.sendTimeout = ConstantConfig.connectTimeout;
    options.receiveTimeout = ConstantConfig.receiveTimeout;

    options.method = method ?? ConstantConfig.method_get;

    return options;
  }

  ///具体的还是要看返回数据的基本结构
  ///公共代码部分
  static void request(BuildContext context, String url, String method,
      {Object params,
        String contentType,
        ResponseType responseType,
        Function successCallBack,
        Function errorCallBack}) async {
    ///网络连接判断
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      WidgetUtil.showToast(msgType: ConstantConfig.error, msg: StringZh.net_error);
      return;
    }

    if (params != null && params != '') {
      LogUtils.i(logTag, '<net> params :' + params.toString());
    } else {
      LogUtils.i(logTag, '<net> no params');
    }

    LogUtils.i(logTag, '<net> url:' + url);

    Options options = await getOptions(
        contentType: contentType, responseType: responseType, method: method);

    try {
      Response response;

      if (ConstantConfig.method_post == method) {
        response =
        await Dio().post(url, data: params, options: options);
      } else {
        response =
        await Dio().get(url, queryParameters: params, options: options);
      }

      int statusCode = response.statusCode;

      ///处理错误部分
      if (statusCode != Code.SUCCESS) {
        handError(
            Code.errorHandleFunction(
                statusCode, '网络请求错误,状态码:' + statusCode.toString()),
            errorCallBack: errorCallBack);
        return;
      }

      LogUtils.i(logTag, '<net> response data:');
      LogUtils.i(logTag, response.data.toString());
      LogUtils.i(logTag, '<net> response data end');

      try {
        successCallBack(response.data);
      } catch (e) {
        catchError(e, context, errorCallBack: (err) {
          WidgetUtil.showToast(msgType: ConstantConfig.error, msg: err);
        });
      }
    } on DioError catch (e) {
      try {
        if (e.response.data["name"] != null &&
            e.response.data["name"].contains('token')) {
          if (e.response.data["message"] != null) {
            WidgetUtil.showToast(
                msgType: ConstantConfig.error, msg: e.response.data["message"]);
          }
        } else {
          catchError(e, context, errorCallBack: errorCallBack);
        }
      } catch (ek) {
        catchError(e, context, errorCallBack: errorCallBack);
      }
    }
  }

  static void catchError(e, BuildContext context, {Function errorCallBack}) {
    LogUtils.e(logTag, e.toString());

    var error = '';
    var statusCode = 666;
    try {
      if (e.response != null) {
        if (e.response.data != null) {
          try {
            statusCode = e.response.statusCode;
            error = json.decode(e.response.data)['message'];
          } catch (ex) {
            error = e.response.data['message'];
          }
        }
      }
      if (e.type == DioErrorType.connectTimeout) {
        statusCode = Code.NETWORK_TIMEOUT;
      } else if (e.type == DioErrorType.other) {
        statusCode = Code.NETWORK_ERROR;
      }
      if (e.type == DioErrorType.response) {
        //statusCode = 404;
        if ('' == error) {
          error = '请求服务器异常';
        }
      }
    } catch (ex) {
      error = e.toString();
    }
    handError(Code.errorHandleFunction(statusCode, error),
        errorCallBack: errorCallBack);
  }

  ///处理异常
  static void handError(String errorMsg, {Function errorCallBack}) {
    LogUtils.e(logTag, '<net> errorMsg :' + errorMsg);
    WidgetUtil.showToast(msgType: ConstantConfig.error, msg: errorMsg);
    if (errorCallBack != null) {
      errorCallBack(errorMsg);
    }
  }
}
