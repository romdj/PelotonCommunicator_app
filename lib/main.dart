import 'dart:io';

import 'package:peloton_communicator/permissions/microphone_permission_handler.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/long_press_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Flutter is properly initialized before running any asynchronous code
  MicrophonePermissionHandler microphonePermissionHandler =
      MicrophonePermissionHandler();
  await microphonePermissionHandler.requestPermission();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioRecording(),
      child: PelotonCommunicator(),
    ),
  );
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
