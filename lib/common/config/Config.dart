class Config {
  //static const address = 'http://192.168.1.21:8088/api/app/picInfo/';
  //static const address = 'http://192.168.48.192:8088/api/app/picInfo/';
  static const String address = 'http://47.251.45.10:8900/api/app/picInfo/';

  static const String downloadUrl = 'http://dl.followerstiktok.com/bucket/img/';

  ///主类型
  static const String primaryType = 'application';

  ///子类型
  static const String subType = 'x-www-form-urlencoded';

  ///编码
  static const String charset = 'utf-8';

  ///连接超时时间（秒）
  static const int connectTimeout = 15000;

  ///接收数据超时时间（秒）
  static const int receiveTimeout = 15000;

  ///请求方式
  static const String method_post = 'POST';
  static const String method_get = 'GET';

  static const String warning = 'warning';
  static const String error = 'error';
  static const String success = 'success';

  ///标准屏幕宽度
  static const int screenWidth = 600;

  static const String versionName = 'V1.05';
  static const String appName = 'Wallpaper HD';

  static const String mainPage = 'MainPage';

  ///调试状态
  static const bool isDebug = true;

  static const String emailUrl='qiangzi1688@gmail.com';


  static const String shareStr='Wallpaper HD - Unique collection of 4K and Live Wallpapers.Available on Play Store,Download Now - https://play.google.com/store/apps/details?id=com.hdwallpaper.wallpaper';


  ///列表加载广告间隔数
  static const int loadAdCount = 9;

}
