import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<String> getAppDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId;

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.serialNumber;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? 'test123';
  } else {
    throw Exception('Unsupported platform');
  }

  return deviceId;
}
