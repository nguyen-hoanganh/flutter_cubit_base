part of sizer;

extension SizerExt on num {
  /// Calculates the height depending on the device's screen size
  ///
  /// Eg: 20.h -> will take 20% of the screen's height
  double get hp => this * SizerUtil.height / 100;

  double get s {
    double result = toDouble();
    try {
      result = (SizerUtil.deviceType == DeviceType.tablet
          ? result * SizerUtil.width / 810
          : result * SizerUtil.width / 375);
    } catch (_) {}

    return result;
  }

  /// Calculates the width depending on the device's screen size
  ///
  /// Eg: 20.w -> will take 20% of the screen's width
  double get wp => this * SizerUtil.width / 100;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  double get fs {
    double result = toDouble();
    try {
      result = (SizerUtil.deviceType == DeviceType.tablet
          ? result * SizerUtil.width / 810
          : result * SizerUtil.width / 375);
    } catch (_) {}

    return result;
  }
}
