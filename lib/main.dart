import 'dart:io';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

import 'package:peloton_communicator/permissions/microphone_permission_handler.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/long_press_button.dart';
import 'package:provider/provider.dart';

var packageInfo;
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Flutter is properly initialized before running any asynchronous code
  MicrophonePermissionHandler microphonePermissionHandler =
      MicrophonePermissionHandler();

  print('packageInfo: $packageInfo');

  await microphonePermissionHandler.requestPermission();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioRecording(),
      child: PelotonCommunicator(),
    ),
  );
  packageInfo = await PackageInfo.fromPlatform();
}

class PelotonCommunicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String appHeaderTitle =
        'Peloton Communicator - ${packageInfo?.version ?? 'no version found yet'}';
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(appHeaderTitle)),
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
