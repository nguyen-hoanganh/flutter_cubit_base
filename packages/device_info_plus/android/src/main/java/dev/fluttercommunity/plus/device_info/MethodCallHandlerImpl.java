// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.device_info;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Context;
import android.content.pm.FeatureInfo;
import android.content.pm.PackageManager;
import android.graphics.Point;
import android.os.Build;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.view.WindowMetrics;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * The implementation of {@link MethodChannel.MethodCallHandler} for the plugin. Responsible for
 * receiving method calls from method channel.
 */
class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

    private final ContentResolver contentResolver;
    private final PackageManager packageManager;
    private final Context context;

    /**
     * Substitute for missing values.
     */
    private static final String[] EMPTY_STRING_LIST = new String[]{};

    /**
     * Constructs DeviceInfo. {@code contentResolver} and {@code packageManager} must not be null.
     */
    MethodCallHandlerImpl(ContentResolver contentResolver, PackageManager packageManager, Context context) {
        this.contentResolver = contentResolver;
        this.packageManager = packageManager;
        this.context = context;
    }

    public String getDeviceId() {
        if (context == null) return "";

        String deviceID = "";
        String simID = "";

//    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
//      TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
//      deviceID = tm.getDeviceId();
//      simID = tm.getSimSerialNumber();
//    }
        String uuid;
        String androidID = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);

        if ("9774d56d682e549c".equals(androidID) || androidID == null) {
            androidID = "";
        }

        if (deviceID == null) {
            deviceID = "";
        }

        if (simID == null) {
            simID = "";
        }

        uuid = androidID + deviceID + simID;
        uuid = String.format("%32s", uuid).replace(' ', '0');
        uuid = uuid.substring(0, 32);
        uuid = uuid.replaceAll("(\\w{8})(\\w{4})(\\w{4})(\\w{4})(\\w{12})", "$1-$2-$3-$4-$5");


//        //LogMBB.d(this, "uuid: " + uuid);

        // return BuildConfig.DEBUG ? "66E005F7-F1D2-4A63-8E38-5736F87B6BFB" : uuid;
        return uuid;

    }

    public List<String> getRealWidthHeight() {
        if (context == null) return new ArrayList<>();

        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);

        List<String> result = new ArrayList<>();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowMetrics windowMetrics =
                    wm.getCurrentWindowMetrics();
            result.add(String.valueOf(windowMetrics.getBounds().width()));
            result.add(String.valueOf(windowMetrics.getBounds().height()));
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            Point size = new Point();
            wm.getDefaultDisplay().getRealSize(size);
            result.add(String.valueOf(size.x));
            result.add(String.valueOf(size.y));
        } else {
            DisplayMetrics displayMetrics = new DisplayMetrics();
            wm.getDefaultDisplay().getMetrics(displayMetrics);
            result.add(String.valueOf(displayMetrics.widthPixels));
            result.add(String.valueOf(displayMetrics.heightPixels));
        }

        return result;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("getAndroidDeviceInfo")) {
            Map<String, Object> build = new HashMap<>();
            build.put("board", Build.BOARD);
            build.put("bootloader", Build.BOOTLOADER);
            build.put("brand", Build.BRAND);
            build.put("device", Build.DEVICE);
            build.put("display", Build.DISPLAY);
            build.put("fingerprint", Build.FINGERPRINT);
            build.put("hardware", Build.HARDWARE);
            build.put("host", Build.HOST);
            build.put("id", Build.ID);
            build.put("manufacturer", Build.MANUFACTURER);
            build.put("model", Build.MODEL);
            build.put("product", Build.PRODUCT);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                build.put("supported32BitAbis", Arrays.asList(Build.SUPPORTED_32_BIT_ABIS));
                build.put("supported64BitAbis", Arrays.asList(Build.SUPPORTED_64_BIT_ABIS));
                build.put("supportedAbis", Arrays.asList(Build.SUPPORTED_ABIS));
            } else {
                build.put("supported32BitAbis", Arrays.asList(EMPTY_STRING_LIST));
                build.put("supported64BitAbis", Arrays.asList(EMPTY_STRING_LIST));
                build.put("supportedAbis", Arrays.asList(EMPTY_STRING_LIST));
            }
            build.put("tags", Build.TAGS);
            build.put("type", Build.TYPE);
            build.put("isPhysicalDevice", !isEmulator());
            build.put("androidId", getAndroidId());

            build.put("systemFeatures", Arrays.asList(getSystemFeatures()));

            Map<String, Object> version = new HashMap<>();
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                version.put("baseOS", Build.VERSION.BASE_OS);
                version.put("previewSdkInt", Build.VERSION.PREVIEW_SDK_INT);
                version.put("securityPatch", Build.VERSION.SECURITY_PATCH);
            }
            version.put("codename", Build.VERSION.CODENAME);
            version.put("incremental", Build.VERSION.INCREMENTAL);
            version.put("release", Build.VERSION.RELEASE);
            version.put("sdkInt", Build.VERSION.SDK_INT);
            build.put("version", version);
            build.put("deviceIdCommon", getDeviceId());
            build.put("realWidthHeight", getRealWidthHeight());

            result.success(build);
        } else {
            result.notImplemented();
        }
    }

    private String[] getSystemFeatures() {
        FeatureInfo[] featureInfos = packageManager.getSystemAvailableFeatures();
        if (featureInfos == null) {
            return EMPTY_STRING_LIST;
        }
        String[] features = new String[featureInfos.length];
        for (int i = 0; i < featureInfos.length; i++) {
            features[i] = featureInfos[i].name;
        }
        return features;
    }

    /**
     * Returns the Android hardware device ID that is unique between the device + user and app
     * signing. This key will change if the app is uninstalled or its data is cleared. Device factory
     * reset will also result in a value change.
     *
     * @return The android ID
     */
    @SuppressLint("HardwareIds")
    private String getAndroidId() {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID);
    }

    /**
     * A simple emulator-detection based on the flutter tools detection logic and a couple of legacy
     * detection systems
     */
    private boolean isEmulator() {
        return (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.HARDWARE.contains("goldfish")
                || Build.HARDWARE.contains("ranchu")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.PRODUCT.contains("sdk_google")
                || Build.PRODUCT.contains("google_sdk")
                || Build.PRODUCT.contains("sdk")
                || Build.PRODUCT.contains("sdk_x86")
                || Build.PRODUCT.contains("vbox86p")
                || Build.PRODUCT.contains("emulator")
                || Build.PRODUCT.contains("simulator");
    }
}
