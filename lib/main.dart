import 'dart:io';

import 'package:peloton_communicator/classes/application_permission_schema.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/long_press_button.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioRecording(),
      child: PelotonCommunicator(),
    ),
  );
  if (Platform.isAndroid) requestAndroidPermissions();
}

class PelotonCommunicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Peloton Communicator')),
        body: Center(
          child: Consumer<AudioRecording>(
            builder: (context, audioModel, child) =>
                LongPressButton(audioModel: audioModel),
          ),
        ),
      ),
    );
  }
}

Future<void> requestAndroidPermissions() async {
  await Permission.microphone.request();

  if (await Permission.microphone.isGranted) {
    ApplicationPermissionSchema().permissionModels.add(
          PermissionModel(
            operatingSystem: Platform.operatingSystem,
            permissionType: PermissionType.microphone,
            hasPermission: true,
          ),
        );
    print('Microphone permission granted.');
  } else {
    ApplicationPermissionSchema().permissionModels.add(PermissionModel(
          operatingSystem: Platform.operatingSystem,
          permissionType: PermissionType.microphone,
          hasPermission: true,
        ));
    print('Microphone permission not granted.');
  }
}
