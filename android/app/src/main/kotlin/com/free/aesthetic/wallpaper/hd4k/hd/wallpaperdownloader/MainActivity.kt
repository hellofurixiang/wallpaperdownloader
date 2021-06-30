package com.free.aesthetic.wallpaper.hd4k.hd.wallpaperdownloader

import com.free.aesthetic.wallpaper.hd4k.hd.wallpaperdownloader.plugin.equipment.EquipmentPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

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
