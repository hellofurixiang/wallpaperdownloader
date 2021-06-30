import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:wallpaperdownloader/common/db/SqlProvider.dart';
import 'package:wallpaperdownloader/common/modal/WatchAdEntity.dart';

/**
 * 观看广告
 * Created by furx
 * Date: 2021-06-29
 */
class WatchAdProvider extends BaseDbProvider {
  final String name = 'WatchAd';

  final String columnId = "_id";
  final String columnWatchDate = "watchDate"; //图片ID
  final String columnWatchInterstitialAd = "watchInterstitialAd"; //观看插页广告
  final String columnWatchRewardedAd = "watchRewardedAd"; //观看激励广告

  int id;
  String watchDate;
  String watchInterstitialAd;
  int watchRewardedAd;

  WatchAdProvider();

  Map<String, dynamic> toMap(
      String watchDate, int watchInterstitialAd, int watchRewardedAd) {
    Map<String, dynamic> map = {
      columnWatchDate: watchDate,
      columnWatchInterstitialAd: watchInterstitialAd,
      columnWatchRewardedAd: watchRewardedAd,
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  WatchAdProvider.fromMap(Map map) {
    id = map[columnId];
    watchDate = map[columnWatchDate];
    watchInterstitialAd = map[columnWatchInterstitialAd];
    watchRewardedAd = map[columnWatchRewardedAd];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnWatchDate text not null,
        $columnWatchInterstitialAd int null,
        $columnWatchRewardedAd int null
        )
      ''';
  }

  @override
  tableName() {
    return name;
  }

  ///插入到数据库
  Future<int> insert(
      String watchDate, int watchInterstitialAd, int watchRewardedAd) async {
    Database db = await getDataBase();

    return await db.insert(name, toMap(watchDate, watchInterstitialAd, watchRewardedAd));
  }

  ///删除
  Future<bool> delete(String watchDate) async {
    Database db = await getDataBase();

    int count =
        await db.delete(name, where: "$columnWatchDate = ? ", whereArgs: [watchDate]);
    return count > 0;
  }

  ///获取单个数据
  Future<WatchAdEntity> findOne(String watchDate) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await db.query(name, where: "$columnWatchDate = ?", whereArgs: [watchDate]);
    if (maps.length > 0) {
      return WatchAdEntity.fromJson(maps[0]);
    }
    return null;
  }

  ///插页广告
  Future updateWatchInterstitialAd(String watchDate) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db
        .query(name, where: "$columnWatchDate = ?", whereArgs: [watchDate]);
    if (maps.length > 0) {
      String sql1 =
          'UPDATE $name SET $columnWatchInterstitialAd=$columnWatchInterstitialAd+1 WHERE $columnWatchDate=?';
      int count = await db.rawUpdate(sql1, [watchDate]);
      return count > 0;
    } else {
      int count = await db.insert(name, toMap(watchDate, 1, 0));
      return count > 0;
    }
  }

  ///激励广告
  Future updateWatchRewardedAd(String watchDate) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db
        .query(name, where: "$columnWatchDate = ?", whereArgs: [watchDate]);
    if (maps.length > 0) {
      String sql1 =
          'UPDATE $name SET $columnWatchRewardedAd=$columnWatchRewardedAd+1 WHERE $columnWatchDate=?';
      int count = await db.rawUpdate(sql1, [watchDate]);

      return count > 0;
    } else {

      await db.delete(name, where: "$columnWatchDate != ? ", whereArgs: [watchDate]);

      int count = await db.insert(name, toMap(watchDate, 0, 1));
      return count > 0;
    }
  }

  ///根据模块获取数据
  Future<List<WatchAdEntity>> findAll() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);

    List<WatchAdEntity> list = [];
    for (var v in maps) {
      list.add(WatchAdEntity.fromJson(v));
    }

    return list;
  }
}
