import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:peloton_communicator/permissions/permission_model.dart';
import 'permission_handler.dart';

class MicrophonePermissionHandler extends PermissionHandler {
  List<PermissionModel> microphonePermissions;

  factory MicrophonePermissionHandler() {
    return _instance;
  }

  MicrophonePermissionHandler._privateConstructor()
      : microphonePermissions = [];

  static final MicrophonePermissionHandler _instance =
      MicrophonePermissionHandler._privateConstructor();

  @override
  void addPermission(String operatingSystem) {
    this.microphonePermissions.add(PermissionModel(
          operatingSystem: operatingSystem,
          hasPermission: true,
        ));
  }

  @override
  bool hasPermission() {
    // if(this.microphonePermissions.where((element) => element.operatingSystem == Platform.operatingSystem).isNotEmpty
    if (Platform.isIOS) return true;
    if (Platform.isAndroid) return true;
    throw UnimplementedError();
  }

  @override
  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.microphone.request();

      if (await Permission.microphone.isGranted) {
        addPermission('Android');
      } else {
        throw UnsupportedError('Microphone permission not granted.');
      }
    }
  }
}
