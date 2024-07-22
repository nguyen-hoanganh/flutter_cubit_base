// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:device_info_plus/plugin_platform_interface.dart';

import 'package:device_info_plus/method_channel/method_channel_device_info.dart';

import 'package:device_info_plus/model/android_device_info.dart';
import 'package:device_info_plus/model/ios_device_info.dart';
import 'package:device_info_plus/model/linux_device_info.dart';
import 'package:device_info_plus/model/macos_device_info.dart';
import 'package:device_info_plus/model/web_browser_info.dart';
import 'package:device_info_plus/model/windows_device_info.dart';

export 'model/android_device_info.dart';
export 'model/base_device_info.dart';
export 'model/ios_device_info.dart';
export 'model/linux_device_info.dart';
export 'model/macos_device_info.dart';
export 'model/web_browser_info.dart';
export 'model/windows_device_info.dart';

/// The interface that implementations of device_info must implement.
///
/// Platform implementations should extend this class rather than implement it as `device_info`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [DeviceInfoPlatform] methods.
abstract class DeviceInfoPlatform extends PlatformInterface {
  /// Constructs a UrlLauncherPlatform.
  DeviceInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceInfoPlatform _instance = MethodChannelDeviceInfo();

  /// The default instance of [DeviceInfoPlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceInfo].
  static DeviceInfoPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [DeviceInfoPlatform] when they register themselves.
  static set instance(DeviceInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Gets the Android device information.
  // ignore: public_member_api_docs
  Future<AndroidDeviceInfo> androidInfo() {
    throw UnimplementedError('androidInfo() has not been implemented.');
  }

  // Gets the iOS device information.
  // ignore: public_member_api_docs
  Future<IosDeviceInfo> iosInfo() {
    throw UnimplementedError('iosInfo() has not been implemented.');
  }

  // Gets the Linux device information.
  // ignore: public_member_api_docs
  Future<LinuxDeviceInfo> linuxInfo() {
    throw UnimplementedError('linuxInfo() has not been implemented.');
  }

  // Gets the web browser information.
  // ignore: public_member_api_docs
  Future<WebBrowserInfo> webBrowserInfo() {
    throw UnimplementedError('webBrowserInfo() has not been implemented.');
  }

  // Gets the Macos device information.
  // ignore: public_member_api_docs
  Future<MacOsDeviceInfo> macosInfo() {
    throw UnimplementedError('macosInfo() has not been implemented.');
  }

  // Gets the Windows device information
  // ignore: public_member_api_docs
  Future<WindowsDeviceInfo>? windowsInfo() {
    throw UnimplementedError('windowsInfo() has not been implemented.');
  }
}
