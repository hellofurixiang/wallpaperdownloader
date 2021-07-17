package com.free.aesthetic.hd4k.hd.wallpaperdownloader.wallpaper

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO: Register the ListTileNativeAdFactory
        /*GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "bottomNativeAd", BottomNativeAdFactory(context))
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "lagerNativeAd", LagerNativeAdFactory(context))
*/
        flutterEngine.plugins.add(EquipmentPlugin())

    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // TODO: Unregister the ListTileNativeAdFactory
        //GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "bottomNativeAd")
        //GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "lagerNativeAd")
    }
}
