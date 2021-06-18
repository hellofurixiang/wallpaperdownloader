import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/AdMobService.dart';
import 'package:wallpaperdownloader/page/AdvertisingPage.dart';
import 'package:wallpaperdownloader/page/CatListPage.dart';
import 'package:wallpaperdownloader/page/PopularPage.dart';
import 'package:wallpaperdownloader/page/RandomPage.dart';
import 'package:wallpaperdownloader/page/RecentPage.dart';
import 'package:wallpaperdownloader/page/widget/MainTopWidget.dart';
import 'package:wallpaperdownloader/page/CommonState.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends CommonState<MainPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(initialIndex: 1, length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedIndex = _tabController.index);
      //print("liucheng-> ${_tabController.indexIsChanging}");
    });
    bannerAd = AdMobService.createBannerAd();
  }

  BannerAd bannerAd;

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    super.dispose();
  }

  TabController _tabController;

  int _selectedIndex = 1;

  List<String> tabs = ['CATEGORY', 'RECENT', 'FEATURED', 'POPULAR', 'RANDOM'];

  List<Widget> _buildPages() {
    List<Widget> pages = [];
    pages.add(CatListPage());
    pages.add(RecentPage());
    pages.add(AdvertisingPage());
    pages.add(PopularPage());
    pages.add(RandomPage());
    return pages;
  }

  buildBanner() async {
    if (bannerAd == null) {
      return Container();
    } else {
      bool bo = await bannerAd.isLoaded();

      return Positioned(
        bottom: 0.0,
        right: 0.0,
        child: Container(
          height: 50,
          width: 320,
          alignment: Alignment.center,
          child: AdWidget(
              ad: bo ? bannerAd : bannerAd
                ..load()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    Color fontColor = SetColors.black;
    Color containerColor = SetColors.white;

    //print('_selectedIndex:' + _selectedIndex.toString());

    for (int i = 0; i < tabs.length; i++) {
      if (i == _selectedIndex) {
        fontColor = SetColors.white;
        containerColor = SetColors.black;
      } else {
        fontColor = SetColors.black;
        containerColor = SetColors.white;
      }
      list.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5, bottom: 5),
        child: Text(tabs[i], style: TextStyle(fontSize: 16, color: fontColor)),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ));
    }

    return new WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        WidgetUtil.dialogExitApp(context);
      },

      child: Scaffold(
        key: _scaffoldKey,
        //appBar: AppBar(),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              MainTopWidget(),
              Expanded(
                child: Container(
                  color: SetColors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand, //未定位widget占满Stack整个空间
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(top: 5.0),
                        child: new Column(
                          children: <Widget>[
                            Container(
                              child: TabBar(
                                indicatorColor: SetColors.white,
                                //labelColor: SetColors.white,
                                //unselectedLabelColor: SetColors.black,
                                //unselectedLabelStyle: TextStyle(fontSize: 15),
                                //labelStyle: TextStyle(fontSize: 14),
                                isScrollable: true,
                                //labelPadding:
                                //EdgeInsets.only(left: 25.0, right: 25.0),
                                controller: _tabController,
                                tabs: list,
                              ),
                              alignment: Alignment.centerLeft,
                              color: SetColors.white,
                            ),
                            Expanded(
                              flex: 1,
                              child: TabBarView(
                                children: _buildPages(),
                                controller: _tabController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*bannerAd == null
                            ? Container()
                            : Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: Container(
                                  height: 50,
                                  width: 320,
                                  alignment: Alignment.center,
                                  child: AdWidget(ad: bannerAd..load()),
                                ),
                              ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
