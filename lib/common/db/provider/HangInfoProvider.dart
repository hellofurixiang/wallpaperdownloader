import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:wallpaperdownloader/common/db/SqlProvider.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';

/**
 * 收藏数据
 * Created by furx
 * Date: 2021-05-21
 */
class HangInfoProvider extends BaseDbProvider {
  final String name = 'HangInfo';

  final String columnId = "_id";
  final String columnImgId = "imgId"; //图片ID
  final String columnFileName = "fileName"; //图片名称
  final String columnWatchAds = "watchAds"; //是否关看广告
  final String columnFavorite = "favorite"; //是否收藏

  int id;
  String imgId;
  String fileName;
  int watchAds;
  int favorite;

  HangInfoProvider();

  Map<String, dynamic> toMap(
      String imgId, String fileName, int watchAds, int favorite) {
    Map<String, dynamic> map = {
      columnImgId: imgId,
      columnFileName: fileName,
      columnWatchAds: watchAds,
      columnFavorite: favorite
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  HangInfoProvider.fromMap(Map map) {
    id = map[columnId];
    imgId = map[columnImgId];
    fileName = map[columnFileName];
    watchAds = map[columnWatchAds];
    favorite = map[columnFavorite];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnImgId text not null,
        $columnFileName text not null,
        $columnWatchAds int null,
        $columnFavorite int null
        )
      ''';
  }

  @override
  tableName() {
    return name;
  }

  ///插入到数据库
  Future<int> insert(
      String imgId, String fileName, int watchAds, int favorite) async {
    Database db = await getDataBase();

    return await db.insert(name, toMap(imgId, fileName, watchAds, favorite));
  }

  ///删除
  Future<bool> delete(String imgId) async {
    Database db = await getDataBase();

    int count =
        await db.delete(name, where: "$columnImgId = ? ", whereArgs: [imgId]);
    return count > 0;
  }

  ///获取单个数据
  Future<HangInfoEntity> findOne(String imgId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await db.query(name, where: "$columnImgId = ?", whereArgs: [imgId]);
    if (maps.length > 0) {
      return HangInfoEntity.fromJson(maps[0]);
    }
    return null;
  }

  ///获取下一条数据
  Future<HangInfoEntity> nextOne(String imgId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name,
        where: "$columnImgId > ?", whereArgs: [imgId], limit: 1);
    if (maps.length > 0) {
      return HangInfoEntity.fromJson(maps[0]);
    }
    return null;
  }

  ///获取上一条数据
  Future<HangInfoEntity> preOne(String imgId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name,
        where: "$columnImgId < ?", whereArgs: [imgId], limit: 1);
    if (maps.length > 0) {
      return HangInfoEntity.fromJson(maps[0]);
    }
    return null;
  }

  ///修改观看广告状态
  Future updateWatchAds(String imgId, String fileName, int watchAds) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db
        .query(name, where: "$columnFileName = ?", whereArgs: [fileName]);
    if (maps.length > 0) {
      String sql1 =
          'UPDATE $name SET $columnWatchAds=? WHERE $columnFileName=?';
      int count = await db.rawUpdate(sql1, [watchAds, fileName]);
      return count > 0;
    } else {
      int count = await db.insert(name, toMap(imgId, fileName, watchAds, 0));
      return count > 0;
    }
  }

  ///修改观看广告状态
  Future updateFavorite(String imgId, String fileName, int favorite) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db
        .query(name, where: "$columnFileName = ?", whereArgs: [fileName]);
    if (maps.length > 0) {
      String sql1 =
          'UPDATE $name SET $columnFavorite=? WHERE $columnFileName=?';
      int count = await db.rawUpdate(sql1, [favorite, fileName]);

      return count > 0;
    } else {
      int count = await db.insert(name, toMap(imgId, fileName, 0, favorite));
      return count > 0;
    }
  }

  ///根据模块获取数据
  Future<List<HangInfoEntity>> findAll() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(name);

    List<HangInfoEntity> list = [];
    for (var v in maps) {
      list.add(HangInfoEntity.fromJson(v));
    }

    return list;
  }
}
