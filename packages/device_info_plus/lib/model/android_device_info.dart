// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:device_info_plus/model/base_device_info.dart';

import 'supported_devices.dart';

/// Information derived from `android.os.Build`.
///
/// See: https://developer.android.com/reference/android/os/Build.html
class AndroidDeviceInfo implements BaseDeviceInfo {
  /// Android device Info class.
  AndroidDeviceInfo({
    required this.version,
    this.board,
    this.bootloader,
    this.brand,
    this.device,
    this.display,
    this.fingerprint,
    this.hardware,
    this.host,
    this.id,
    this.manufacturer,
    this.model,
    this.product,
    required List<String?> supported32BitAbis,
    required List<String?> supported64BitAbis,
    required List<String?> supportedAbis,
    this.tags,
    this.type,
    this.isPhysicalDevice,
    this.androidId,
    required List<String?> systemFeatures,
    this.deviceIdCommon,
    required List<String?> realWidthHeight,
  })  : supported32BitAbis = List<String?>.unmodifiable(supported32BitAbis),
        supported64BitAbis = List<String?>.unmodifiable(supported64BitAbis),
        supportedAbis = List<String?>.unmodifiable(supportedAbis),
        systemFeatures = List<String?>.unmodifiable(systemFeatures),
        realWidthHeight = List<String?>.unmodifiable(realWidthHeight);

  /// Android operating system version values derived from `android.os.Build.VERSION`.
  final AndroidBuildVersion version;

  /// The name of the underlying board, like "goldfish".
  final String? board;

  /// The system bootloader version number.
  final String? bootloader;

  /// The consumer-visible brand with which the product/hardware will be associated, if any.
  final String? brand;

  /// The name of the industrial design.
  final String? device;

  /// A build ID string meant for displaying to the user.
  final String? display;

  /// A string that uniquely identifies this build.
  final String? fingerprint;

  /// The name of the hardware (from the kernel command line or /proc).
  final String? hardware;

  /// Hostname.
  final String? host;

  /// Either a changelist number, or a label like "M4-rc20".
  final String? id;

  /// The manufacturer of the product/hardware.
  final String? manufacturer;

  /// The end-user-visible name for the end product.
  final String? model;

  /// The name of the overall product.
  final String? product;

  /// An ordered list of 32 bit ABIs supported by this device.
  final List<String?> supported32BitAbis;

  /// An ordered list of 64 bit ABIs supported by this device.
  final List<String?> supported64BitAbis;

  /// An ordered list of ABIs supported by this device.
  final List<String?> supportedAbis;

  /// Comma-separated tags describing the build, like "unsigned,debug".
  final String? tags;

  /// The type of build, like "user" or "eng".
  final String? type;

  /// `false` if the application is running in an emulator, `true` otherwise.
  final bool? isPhysicalDevice;

  /// The Android hardware device ID that is unique between the device + user and app signing.
  final String? androidId;

  /// Describes what features are available on the current device.
  ///
  /// This can be used to check if the device has, for example, a front-facing
  /// camera, or a touchscreen. However, in many cases this is not the best
  /// API to use. For example, if you are interested in bluetooth, this API
  /// can tell you if the device has a bluetooth radio, but it cannot tell you
  /// if bluetooth is currently enabled, or if you have been granted the
  /// necessary permissions to use it. Please *only* use this if there is no
  /// other way to determine if a feature is supported.
  ///
  /// This data comes from Android's PackageManager.getSystemAvailableFeatures,
  /// and many of the common feature strings to look for are available in
  /// PackageManager's public documentation:
  /// https://developer.android.com/reference/android/content/pm/PackageManager
  final List<String?> systemFeatures;

  final String? deviceIdCommon;

  final List<String?> realWidthHeight;

  /// Serializes [AndroidDeviceInfo] to map.
  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'host': host,
      'tags': tags,
      'type': type,
      'model': model,
      'board': board,
      'brand': brand,
      'device': device,
      'product': product,
      'display': display,
      'hardware': hardware,
      'androidId': androidId,
      'bootloader': bootloader,
      'version': version.toMap(),
      'fingerprint': fingerprint,
      'manufacturer': manufacturer,
      'supportedAbis': supportedAbis,
      'systemFeatures': systemFeatures,
      'isPhysicalDevice': isPhysicalDevice,
      'supported32BitAbis': supported32BitAbis,
      'supported64BitAbis': supported64BitAbis,
      'deviceIdCommon': deviceIdCommon,
      'realWidthHeight': realWidthHeight,
    };
  }

  /// Deserializes from the message received from [_kChannel].
  static AndroidDeviceInfo fromMap(Map<String, dynamic> map) {
    return AndroidDeviceInfo(
      version: AndroidBuildVersion._fromMap(
        map['version']?.cast<String, dynamic>() ?? {},
      ),
      board: map['board'],
      bootloader: map['bootloader'],
      brand: map['brand'],
      device: map['device'],
      display: map['display'],
      fingerprint: map['fingerprint'],
      hardware: map['hardware'],
      host: map['host'],
      id: map['id'],
      manufacturer: map['manufacturer'],
      model: map['model'],
      product: map['product'],
      supported32BitAbis: _fromList(map['supported32BitAbis'] ?? []),
      supported64BitAbis: _fromList(map['supported64BitAbis'] ?? []),
      supportedAbis: _fromList(map['supportedAbis'] ?? []),
      tags: map['tags'],
      type: map['type'],
      isPhysicalDevice: map['isPhysicalDevice'],
      androidId: map['androidId'],
      systemFeatures: _fromList(map['systemFeatures'] ?? []),
      deviceIdCommon: map['deviceIdCommon'],
      realWidthHeight: _fromList(map['realWidthHeight'] ?? []),
    );
  }

  /// Deserializes message as List<String>
  static List<String?> _fromList(dynamic message) {
    final List<dynamic> list = message;
    return List<String?>.from(list);
  }

  String? get deviceName => DeviceName.androidNames[model];
}

/// Version values of the current Android operating system build derived from
/// `android.os.Build.VERSION`.
///
/// See: https://developer.android.com/reference/android/os/Build.VERSION.html
class AndroidBuildVersion {
  const AndroidBuildVersion._({
    this.baseOS,
    this.codename,
    this.incremental,
    this.previewSdkInt,
    this.release,
    this.sdkInt,
    this.securityPatch,
  });

  /// The base OS build the product is based on.
  final String? baseOS;

  /// The current development codename, or the string "REL" if this is a release build.
  final String? codename;

  /// The internal value used by the underlying source control to represent this build.
  final String? incremental;

  /// The developer preview revision of a prerelease SDK.
  final int? previewSdkInt;

  /// The user-visible version string.
  final String? release;

  /// The user-visible SDK version of the framework.
  ///
  /// Possible values are defined in: https://developer.android.com/reference/android/os/Build.VERSION_CODES.html
  final int? sdkInt;

  /// The user-visible security patch level.
  final String? securityPatch;

  /// Serializes [ AndroidBuildVersion ] to map.
  Map<String, dynamic> toMap() {
    return {
      'baseOS': baseOS,
      'sdkInt': sdkInt,
      'release': release,
      'codename': codename,
      'incremental': incremental,
      'previewSdkInt': previewSdkInt,
      'securityPatch': securityPatch,
    };
  }

  /// Deserializes from the map message received from [_kChannel].
  static AndroidBuildVersion _fromMap(Map<String, dynamic> map) {
    return AndroidBuildVersion._(
      baseOS: map['baseOS'],
      codename: map['codename'],
      incremental: map['incremental'],
      previewSdkInt: map['previewSdkInt'],
      release: map['release'],
      sdkInt: map['sdkInt'],
      securityPatch: map['securityPatch'],
    );
  }
}
