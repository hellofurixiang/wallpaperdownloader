// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.free.aesthetic.hd4k.hd.wallpaperdownloader.wallpaper;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Environment;
import android.text.TextUtils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


/**
 * The implementation of {@link MethodChannel.MethodCallHandler} for the plugin. Responsible for
 * receiving method calls from method channel.
 */
class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

    private final Context context;
    private final Activity activity;


    /**
     * Constructs DeviceInfo. {@code contentResolver} and {@code packageManager} must not be null.
     */
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
        } else if (call.method.equals("sendBroadcast")) {
            String filePath = call.argument("filePath");

            sendBroadcast(filePath);
        } else if (call.method.equals("saveImage")) {



            byte[] image = call.argument("imageBytes");
            Integer quality = call.argument("quality");
            String name = call.argument("name");
            String dir = call.argument("dir");

            result.success(
                    saveImageToGallery(
                            BitmapFactory.decodeByteArray(
                                    image,
                                    0,
                                    image.length
                            ), quality, name, dir
                    )
            );
        } else if (call.method.equals("saveFile")) {

            String path = call.argument("file");
            String dir = call.argument("dir");
            result.success(saveFileToGallery(path, dir));
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


    private File generateFile(String name, String dir) {
        String storePath =
                Environment.getExternalStorageDirectory().getPath() + File.separator + dir;
        File appDir = new File(storePath);
        if (!appDir.exists()) {
            appDir.mkdir();
        }
        return new File(appDir, name);
    }

    private void sendBroadcast(String filePath) {
        File file = new File(filePath);
        Uri uri = Uri.fromFile(file);
        context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri));

    }

    private HashMap<String, Object> saveImageToGallery(Bitmap bmp, Integer quality, String name, String dir) {
        File file = generateFile(name, dir);
        try {
            FileOutputStream fos = new FileOutputStream(file);

            bmp.compress(Bitmap.CompressFormat.JPEG, quality, fos);
            fos.flush();
            fos.close();
            Uri uri = Uri.fromFile(file);
            context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri));
            bmp.recycle();
            return toHashMap(!TextUtils.isEmpty(uri.toString()), uri.toString(), null);
        } catch (IOException e) {
            return toHashMap(false, null, e.toString());
        }
    }

    private HashMap<String, Object> saveFileToGallery(String filePath, String dir) {
        try {
            File file = generateFile(filePath.substring(filePath.lastIndexOf("/") + 1), dir);

            InputStream is = new FileInputStream(filePath);
            //file.getParentFile()，获取文件的路径，不包括后面的文件filename
            FileOutputStream fos = new FileOutputStream(file);

            byte[] buffer = new byte[1024];
            int byteCount = 0;
            //is.read(buffer)代表实际读取到的字符的个数,实现读取内容到字节数组中
            while ((byteCount = is.read(buffer)) != -1) {
                fos.write(buffer, 0, byteCount);
            }
            fos.flush();
            fos.close();
            is.close();

            Uri uri = Uri.fromFile(file);
            context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri));
            return toHashMap(!TextUtils.isEmpty(uri.toString()), uri.toString(), null);
        } catch (IOException e) {
            return toHashMap(false, null, e.toString());
        }
    }

    HashMap<String, Object> toHashMap(Boolean isSuccess,
                                      String filePath,
                                      String errorMessage) {
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put("isSuccess", isSuccess);
        hashMap.put("filePath", filePath);
        hashMap.put("errorMessage", errorMessage);
        return hashMap;
    }

}


