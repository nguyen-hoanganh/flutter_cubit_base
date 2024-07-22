# sizer

<p align="center" >
  <strong>Sizer is helps you to create responsive UI easily.</strong>
  <br />
</p>

<br />

A flutter plugin for Easily make Flutter apps responsive. Automatically adapt UI to different screen sizes. Responsiveness made simple. 

# Installation ⬇️
Add to pubspec.yaml.
```dart
dependencies:
  ...
  sizer: ^2.0.14
```

# Parameters ⚙️ 

* `.s` - Returns a calculated widget size based on the device
* `.fs` - Returns a calculated font size based on the device
* `SizerUtil.orientation` - for screen orientation portrait or landscape
* `SizerUtil.deviceType` - for device type mobile or tablet

# Usage 💻

## Add the following imports to your Dart code: 
```dart
import 'package:sizer/sizer.dart';
```

## Wrap MaterialApp with ResponsiveSizer widget
```dart
ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp();
      }
 )
```

Whenever you use height and width first import sizer package.
```dart
import 'package:sizer/sizer.dart';
```

## Widget Size 🕓
```dart
    Container(
      width: 20.wp,    //It will take a 20% of screen width
      height: 30.hp     //It will take a 30% of screen height
    )
```

## Padding ⏹
```dart
    Padding(
      padding: EdgeInsets.symmetric(vertical: 5.s, horizontal: 3.s),
      child: Container(),
    );
```

## Font size 🆎
```dart
    Text(
      'Sizer',style: TextStyle(fontSize: 15.fs),
    );
```

## Orientation 🔄

If you want to support both portrait and landscape orientations
```dart
Device.orientation == Orientation.portrait
  ? Container(   // Widget for Portrait
      width: 100.s,
      height: 20.5.s,
   )
  : Container(   // Widget for Landscape
      width: 100.s,
      height: 12.5.s,
   )
```

## DeviceType 📱

If you want the same layout to look different in tablet and mobile, use the ``SizerUtil.deviceType`` method:

```dart
SizerUtil.deviceType == DeviceType.mobile
  ? Container(   // Widget for Mobile
      width: 100.w,
      height: 20.5.h,
   )
  : Container(   // Widget for Tablet
      width: 100.w,
      height: 12.5.h,
   )
```

# Suggestion
**Orientation**

If you want to give support for both portrait and landscape then make separate widget for both like orientation example.

**DeviceType**

If you want to give support for both mobile and tablet then make separate widget for both like deviceType example.  
