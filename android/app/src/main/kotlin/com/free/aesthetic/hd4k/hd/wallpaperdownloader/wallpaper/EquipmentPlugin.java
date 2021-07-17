// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.free.aesthetic.hd4k.hd.wallpaperdownloader.wallpaper;

import android.app.Activity;
import android.content.Context;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/** DeviceInfoPlugin */
public class EquipmentPlugin implements FlutterPlugin {

  MethodChannel channel;

  /** Plugin registration. */
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    EquipmentPlugin plugin = new EquipmentPlugin();
    plugin.setupMethodChannel(registrar.messenger(), registrar.context(),registrar.activity());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    setupMethodChannel(binding.getBinaryMessenger(), binding.getApplicationContext(),null);
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    tearDownChannel();
  }

  private void setupMethodChannel(BinaryMessenger messenger, Context context, Activity activity) {
    channel = new MethodChannel(messenger, "plugins.flutter.io/equipment");
    final MethodCallHandlerImpl handler =
        new MethodCallHandlerImpl(context, activity);
    channel.setMethodCallHandler(handler);
  }

  private void tearDownChannel() {
    channel.setMethodCallHandler(null);
    channel = null;
  }
}
