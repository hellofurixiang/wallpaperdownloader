import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallpaperdownloader/common/config/Config.dart';
import 'package:wallpaperdownloader/common/db/provider/HangInfoProvider.dart';
import 'package:wallpaperdownloader/common/modal/HangInfoEntity.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/widget/AppBarWidget.dart';

class FavoritePage extends StatefulWidget {
  final String cat;

  const FavoritePage({Key key, this.cat}) : super(key: key);

  @override
  FavoritePageState createState() => new FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  ///信息列表
  List<HangInfoEntity> imgList = [];

  HangInfoProvider provider = new HangInfoProvider();

  @override
  void initState() {
    super.initState();
    initData();
  }

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  ///加载数据
  Future<void> initData() async {
    List<HangInfoEntity> list = await provider.findAll();
    setState(() {
      imgList = list;
    });
  }

  String operType = 'favorite';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Favorite',
        isBack: true,
      ),
      body: SafeArea(
        top: true,
        child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(2),
          crossAxisCount: 3,
          itemCount: imgList.length,
          itemBuilder: (context, i) {
            String imgPath = Config.downloadUrl + imgList[i].fileName;
            return GestureDetector(
              onTap: () {
                //AdMobService.showInterstitialAd();
                WidgetUtil.goDetailPage(context, imgList[i].imgId, operType);
              },
              child: new Material(
                //elevation: 8.0,
                //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: new CachedNetworkImage(
                  imageUrl: imgPath,
                  imageBuilder: (context, imageProvider) => Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: SetColors.darkGrey,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: CupertinoActivityIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          },
          staggeredTileBuilder: (int index) {
            return StaggeredTile.count(1, 2); //横轴和纵轴的数量,控制瀑布流效果
          },
          //mainAxisSpacing: 8.0,
          //crossAxisSpacing: 8.0,
        ),
      ),
    );
  }
}
