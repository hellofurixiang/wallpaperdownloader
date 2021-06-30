// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.free.aesthetic.wallpaper.hd4k.hd.wallpaperdownloader.plugin.equipment;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


/**
 * The implementation of {@link MethodChannel.MethodCallHandler} for the plugin. Responsible for
 * receiving method calls from method channel.
 */
class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

  private final Context context;
  private final Activity activity;


  /** Constructs DeviceInfo. {@code contentResolver} and {@code packageManager} must not be null. */
  MethodCallHandlerImpl(Context context, Activity activity) {
    this.context = context;
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("editImg")) {
      
      /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        build.put("supported32BitAbis", Arrays.asList(Build.SUPPORTED_32_BIT_ABIS));
        build.put("supported64BitAbis", Arrays.asList(Build.SUPPORTED_64_BIT_ABIS));
        build.put("supportedAbis", Arrays.asList(Build.SUPPORTED_ABIS));
      } else {
        build.put("supported32BitAbis", Arrays.asList(EMPTY_STRING_LIST));
        build.put("supported64BitAbis", Arrays.asList(EMPTY_STRING_LIST));
        build.put("supportedAbis", Arrays.asList(EMPTY_STRING_LIST));
      }*/
      //使用Intent
      Intent intent = new Intent(Intent.ACTION_VIEW);
//Uri mUri = Uri.parse("file://" + picFile.getPath());Android3.0以后最好不要通过该方法，存在一些小Bug
      //intent.setDataAndType(Uri.fromFile(call.argument("picFile")), "image/*");
      intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
      intent.setDataAndType(Uri.parse(call.argument("picFile")), "image/*");
      startActivity(intent);

      result.success(1);
    } else {
      result.notImplemented();
    }
  }
  private void startActivity(Intent intent) {
    if (activity != null) {
      activity.startActivity(intent);
    } else if (context != null) {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      context.startActivity(intent);
    } else {
      throw new IllegalStateException("Both context and activity are null");
    }
  }
  
}
