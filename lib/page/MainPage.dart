import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:wallpaperdownloader/common/style/Styles.dart';
import 'package:wallpaperdownloader/common/utils/AdMobService.dart';
import 'package:wallpaperdownloader/common/utils/CommonUtil.dart';
import 'package:wallpaperdownloader/common/utils/WidgetUtil.dart';
import 'package:wallpaperdownloader/page/AdvertisingPage.dart';
import 'package:wallpaperdownloader/page/CatListPage.dart';
import 'package:wallpaperdownloader/page/CommonState.dart';
import 'package:wallpaperdownloader/page/PopularPage.dart';
import 'package:wallpaperdownloader/page/RandomPage.dart';
import 'package:wallpaperdownloader/page/RecentPage.dart';
import 'package:wallpaperdownloader/page/widget/MainTopWidget.dart';

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
  }

  final _nativeAdController = NativeAdmobController();

  ///当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    _nativeAdController.dispose();
    super.dispose();
  }

  TabController _tabController;

  int _selectedIndex = 1;

  List<String> tabs = ['Category', 'Recent', 'Featured', 'Popular', 'Random'];

  List<Widget> _buildPages() {
    List<Widget> pages = [];
    pages.add(CatListPage());
    pages.add(RecentPage());
    pages.add(AdvertisingPage());
    pages.add(PopularPage());
    pages.add(RandomPage());
    return pages;
  }

  NativeAdmobOptions nativeAdmobOptions= NativeAdmobOptions(

    adLabelTextStyle : NativeTextStyle(
      fontSize: 12,
      color: Colors.white,
      backgroundColor: Color(0xFFFFCC66),
    ),
    headlineTextStyle : NativeTextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    advertiserTextStyle : NativeTextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    bodyTextStyle : NativeTextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),
    storeTextStyle : NativeTextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    priceTextStyle : NativeTextStyle(
      fontSize: 12,
      color: Colors.black,
    ),
    callToActionStyle : NativeTextStyle(
      fontSize: 15,
      color: Colors.white,
      backgroundColor: Color(0xFF4CBE99),
    ),
  );


  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    Color fontColor = SetColors.white;
    Color containerColor = SetColors.mainColor;

    //print('_selectedIndex:' + _selectedIndex.toString());

    for (int i = 0; i < tabs.length; i++) {
      if (i == _selectedIndex) {
        fontColor = SetColors.black;
        containerColor = SetColors.white;
      } else {
        fontColor = SetColors.white;
        containerColor = SetColors.black;
      }
      list.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5, bottom: 5),
        child: Text(tabs[i], style: TextStyle(color: fontColor)),
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
        backgroundColor: SetColors.black,
        key: _scaffoldKey,
        //appBar: AppBar(),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              MainTopWidget(),
              Expanded(
                child: Container(
                  //color: SetColors.mainColor,
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
                                //去掉下划线
                                indicator: const BoxDecoration(),
                                indicatorColor: SetColors.black,
                                //labelColor: SetColors.mainColor,
                                //unselectedLabelColor: SetColors.mainColor,
                                //labelStyle: TextStyle(fontSize: 14),
                                isScrollable: true,
                                //EdgeInsets.only(left: 25.0, right: 25.0),
                                controller: _tabController,
                                tabs: list,
                              ),
                              alignment: Alignment.centerLeft,
                              color: SetColors.black,
                              margin: EdgeInsets.only(bottom: 10.0),
                            ),
                            Container(
                              height: 60,
                              width: CommonUtil.getScreenWidth(context),
                              //padding: EdgeInsets.all(10),
                              //margin: EdgeInsets.only(bottom: 20.0),
                              child: NativeAdmob(
                                loading: Center(
                                  child: CircularProgressIndicator(
                                    color: SetColors.white,
                                  ),
                                ),
                                adUnitID: AdMobService.nativeAdGeneralUnitId,
                                numberAds: 5,
                                controller: _nativeAdController,
                                type: NativeAdmobType.banner,
                                options: NativeAdmobOptions(
                                  headlineTextStyle: NativeTextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
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
                      /*Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        child: Container(
                          height: 60,
                          width: CommonUtil.getScreenWidth(context),
                          //padding: EdgeInsets.all(10),
                          //margin: EdgeInsets.only(bottom: 20.0),
                          child: NativeAdmob(
                            loading: Center(child: CircularProgressIndicator(color: SetColors.white,),),
                            adUnitID: AdMobService.nativeAdGeneralUnitId,
                            numberAds: 5,
                            controller: _nativeAdController,
                            type: NativeAdmobType.banner,
                          ),
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
