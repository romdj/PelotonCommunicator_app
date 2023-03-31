import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peloton_communicator/classes/button_state.dart';
import 'package:peloton_communicator/classes/mqtt_manager.dart';

final logger = Logger();

class AudioRecording extends ChangeNotifier {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  FlutterSoundPlayer player = FlutterSoundPlayer(); // Add the player instance
  MqttManager mqttManager = MqttManager();
  ButtonState buttonState = ButtonState.idle;
  late final String recordingFileName;

  Future<void> init() async {
    final Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = appDocumentsDirectory.path;
    await createAudioFilesFolder();
    recordingFileName = '$path/audioFiles/audio_recording.aac';
    await openRecorder();
    await openPlayer();
    await mqttManager.connectToAwsIotCore();
  }

  Future<void> startRecording() async {
    logger.i('starting to record');
    if (recorder.isStopped) {
      await openRecorder();
    }
    await recorder.startRecorder(toFile: recordingFileName);
    buttonState = ButtonState.recording;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    buttonState = ButtonState.idle;
    await recorder.stopRecorder();
    notifyListeners();
    closeRecorder();
  }

  // New method to start playing the recorded file
  Future<void> startPlaying() async {
    if (player.isStopped) {
      await openPlayer();
    }
    try {
      await player.startPlayer(fromURI: recordingFileName);
    } catch (e) {
      logger.i('Exception: $e');
      closePlayer();
    }
  }

  Future<void> openRecorder() async {
    await recorder.openRecorder();
  }

  Future<void> closeRecorder() async {
    await recorder.closeRecorder();
  }

  // New methods to open and close the player
  Future<void> openPlayer() async {
    await player.openPlayer(enableVoiceProcessing: true);
  }

  Future<void> closePlayer() async {
    await player.closePlayer();
  }

  Future<void> publishAudioFile() async {
    await mqttManager.publishFileToTopic(recordingFileName);
  }

  Future<void> stopRecordingAndPlayIt() async {
    await stopRecording();
    buttonState = ButtonState.idle;
    notifyListeners();
    await startPlaying();
  }

  Future<String> createAudioFilesFolder() async {
    final Directory appDocumentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = appDocumentsDirectory.path;
    String audioFilesPath = '$path/audioFiles';
    Directory audioFilesDir = Directory(audioFilesPath);

    if (!await audioFilesDir.exists()) {
      await audioFilesDir.create();
    }

    return audioFilesPath;
  }
}
