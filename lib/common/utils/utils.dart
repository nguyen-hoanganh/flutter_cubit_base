import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  static void copyToClipBoard(String? content) async {
    try {
      await Clipboard.setData(ClipboardData(text: content));

      ScaffoldMessenger.of(AppRouter.rootNavigatorKey.currentContext!)
          .showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppLocalizations.current.copySuccess,
            style: CommonTextStyle.bodyB4
                .copyWith(color: CommonColors.neutralColor7),
          ),
          backgroundColor: CommonColors.primaryColor2,
          clipBehavior: Clip.hardEdge,
        ),
      );
    } catch (_) {}
  }

  static Future<dynamic> getDeviceInformation() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, String> deviceInfo = {};

    try {
      if (Platform.isAndroid) {
        // For Android devices
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceInfo['deviceId'] = androidInfo.deviceIdCommon.toString();
        deviceInfo['deviceOS'] = 'Android';
        deviceInfo['deviceModel'] = androidInfo.model.toString();
        deviceInfo['deviceVendor'] = androidInfo.brand.toString();
        deviceInfo['deviceOsVersion'] = androidInfo.version.release.toString();
      } else if (Platform.isIOS) {
        // For iOS devices
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceInfo['deviceId'] = iosInfo.deviceIdCommon.toString();
        deviceInfo['deviceOS'] = 'iOS';
        deviceInfo['deviceModel'] = iosInfo.utsname.machine.toString();
        deviceInfo['deviceVendor'] = 'Apple';
        deviceInfo['deviceOsVersion'] = iosInfo.systemVersion.toString();
      }
    } catch (_) {
      // print('Error: $e');
    }

    return deviceInfo;
  }

  static Future<String> getIpAddress() async {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    return data['ip'];
  }

  static String formatDateTimeNow() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy – kk:mm').format(now);
    return formattedDate;
  }

  static Image convertBase64toImage(codeBase64, {BoxFit fit = BoxFit.cover}) {
    var image = base64.decode(codeBase64.toString());
    return Image.memory(
      image,
      fit: fit,
    );
  }

  static MemoryImage convertBase64toMemoryImage(codeBase64) {
    Uint8List img = base64Decode(codeBase64.toString());
    return MemoryImage(
      img,
    );
  }

  static void contactCustomerService() {
    launchUrlString("tel://${ConfigConst.customerServicePhone}");
  }

  // static Future<String> encodeEncryptedDataBase64(dynamic data) async {
  //   dynamic dataEncrypt;
  //   try {
  //     final getPublicKey = await FlutterCbpRsa.dataEncryption();
  //     String publicKeyString =
  //         '-----BEGIN PUBLIC KEY-----\n$getPublicKey\n-----END PUBLIC KEY-----';
  //     final publicKeyParser = RSAKeyParser();
  //     dynamic publicKey = publicKeyParser.parse(publicKeyString);
  //     final encrypter = Encrypter(RSA(publicKey: publicKey));
  //     dataEncrypt = encrypter.encrypt(jsonEncode(data));
  //   } catch (_) {}
  //   String encryptedDataString = base64.encode(dataEncrypt.bytes);
  //   return encryptedDataString;
  // }

  // static Future<String> decodeEncryptedDataBase64(
  //   String encryptedDataString,
  // ) async {
  //   List<int> encryptedDataBytes = base64.decode(encryptedDataString);
  //   Encrypted encryptedData = Encrypted(Uint8List.fromList(encryptedDataBytes));
  //   dynamic decryptData;
  //   try {
  //     final getPrivateKey = await FlutterCbpRsa.dataDecryption();
  //     String privateKeyString =
  //         '-----BEGIN PRIVATE KEY-----\n$getPrivateKey\n-----END PRIVATE KEY-----';

  //     final privateKeyParser = RSAKeyParser();
  //     dynamic privateKey =
  //         privateKeyParser.parse(privateKeyString) as RSAPrivateKey;

  //     final encrypter = Encrypter(RSA(privateKey: privateKey));
  //     decryptData = encrypter.decrypt(encryptedData);
  //   } catch (_) {}
  //   return decryptData;
  // }

  static Future<void> posisionPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      LocationPermission requestPermission =
          await Geolocator.requestPermission();

      if (requestPermission == LocationPermission.denied ||
          requestPermission == LocationPermission.deniedForever) {
        AppManager.shared.locationPermission = false;
        return Future.value(null);
      }
    }
    AppManager.shared.locationPermission = true;
  }

  static Future<void> pdfAndShare({
    required BuildContext context,
    required String base64Pdf,
    String? fileName,
  }) async {
    try {
      var bytes = base64Decode(
        base64Pdf.replaceAll('\n', ''),
      );
      LoadingManager.shared.show(context: context);

      final directory = await getApplicationDocumentsDirectory();
      String pathName = fileName ?? 'Receipt.pdf';
      final filePath = "${directory.path}/$pathName";

      await File(filePath).writeAsBytes(bytes.buffer.asUint8List());

      final xfile = XFile(filePath);
      Share.shareXFiles([xfile]);
    } catch (e) {
      // log(e.toString(), name: "transfer_success_page-captureAndShare");
    } finally {
      LoadingManager.shared.hide();
    }
  }

  static Future<Uint8List?> captureImage(
    BuildContext context,
    ScreenshotController controller,
  ) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final Uint8List? image = await controller.capture(
      pixelRatio: pixelRatio,
    );

    return image;
  }

  static Future<void> captureAndSave(
    BuildContext context,
    ScreenshotController controller,
  ) async {
    try {
      LoadingManager.shared.show(context: context);
      final image = await captureImage(context, controller);
      if (image == null) return;

      final savedResult = await ImageGallerySaver.saveImage(image);

      if (savedResult?["isSuccess"] == true) {
        log(savedResult, name: "transfer_success_page-captureAndSave-Success");
      } else {
        log(savedResult, name: "transfer_success_page-captureAndSave-Fail");
      }
    } catch (e) {
      log(e.toString(), name: "transfer_success_page-captureAndSave-e");
    } finally {
      LoadingManager.shared.hide();
      ModalDialog(
        configs: ModalDialogConfigs(
          customIconWidget:
              Assets.svgs.icInformation.svg(width: 32.s, height: 32.s),
          customTitleWidget: Column(
            children: [
              Gap(12.s),
              Text(
                "Save To Gallery Successful",
                style: CommonTextStyle.bodyB2.copyWith(
                  color: CommonColors.neutralColor2,
                ),
              ),
            ],
          ),
          isVisibleCloseButton: false,
          buttonConfigs: [
            ButtonConfigs(
              state: ButtonState.default$,
              type: ButtonType.primary,
              content: 'Close',
              contentStyle: CommonTextStyle.bodyB2.copyWith(
                color: CommonColors.neutralColor7,
              ),
              onTap: ((() {
                AppRouter.router.pop();
              })),
            )
          ],
        ),
      ).show();
    }
  }
}
