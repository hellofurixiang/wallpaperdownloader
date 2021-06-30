import 'dart:convert';

class GlobalInfo {
  // 工厂模式
  factory GlobalInfo() => _getInstance();

  static GlobalInfo get instance => _getInstance();
  static GlobalInfo _instance;

  GlobalInfo._internal() {
    // 初始化
  }

  static GlobalInfo _getInstance() {
    if (_instance == null) {
      _instance = new GlobalInfo._internal();
    }
    return _instance;
  }

  bool debug;

  isDebug() {
    return debug ?? false;
    //return debug ?? true;
  }

  setDebug(bool isDebug) {
    debug = isDebug;
  }

  String ocrToken;

  getOcrToken() {
    return ocrToken;
  }

  setOcrToken(String ocrToken) {
    this.ocrToken = ocrToken;
  }

  int showBannerAdState;

  int getShowBannerAdState() {
    return showBannerAdState ?? 0;
  }

  setShowBannerAdState(int showBannerAdState) {
    this.showBannerAdState = showBannerAdState;
  }

  Future<Null> bannerAd;

  Future<Null> getBannerAd() {
    return bannerAd;
  }

  setBannerAd(Future<Null> banner) {
    this.bannerAd = banner;
  }

  DateTime watchDateTime;

  DateTime getWatchDateTime() {
    return watchDateTime;
  }

  setWatchDateTime(DateTime dateTime) {
    this.watchDateTime = dateTime;
  }
}
