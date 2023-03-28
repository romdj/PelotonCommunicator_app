import 'dart:io';
import 'package:flutter/material.dart';

enum PermissionType {
  microphone,
  headphones,
}

class PermissionModel {
  String operatingSystem;
  PermissionType permissionType;
  bool hasPermission;

  PermissionModel({
    required this.operatingSystem,
    required this.permissionType,
    required this.hasPermission,
  });
}

class ApplicationPermissionSchema {
  List<PermissionModel> permissionModels;

  factory ApplicationPermissionSchema() {
    return _instance;
  }

  ApplicationPermissionSchema._privateConstructor() : permissionModels = [];

  static final ApplicationPermissionSchema _instance =
      ApplicationPermissionSchema._privateConstructor();

  bool hasMicrophonePermission() {
    /* return permissionModels
        .where((element) => element.permissionType == PermissionType.microphone)
        .first((element) => element.hasPermission);
 */
    //     element.operatingSystem == Platform.operatingSystem &&
    //     element.permissionType == PermissionType.microphone &&
    //     element.hasPermission)
    // .isNotEmpty;
    return false;
  }
}
