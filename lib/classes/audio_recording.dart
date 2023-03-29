import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:peloton_communicator/classes/button_state.dart';

class AudioRecording extends ChangeNotifier {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  FlutterSoundPlayer player = FlutterSoundPlayer(); // Add the player instance
  ButtonState buttonState = ButtonState.idle;

  Future<void> init() async {
    await openRecorder();
    await openPlayer();
  }

  Future<void> startRecording() async {
    print('starting to record');
    if (recorder.isStopped) {
      await openRecorder();
    }
    await recorder.startRecorder(toFile: 'audio_recording.aac');
    // await recorder.
    buttonState = ButtonState.recording;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();
    buttonState = ButtonState.idle;
    notifyListeners();
    closeRecorder();
  }

  // New method to start playing the recorded file
  Future<void> startPlaying() async {
    if (player.isStopped) {
      await openPlayer();
    }
    await player.startPlayer(fromURI: 'audio_recording.aac');
  }

  Future<void> openRecorder() async {
    await recorder.openRecorder();
  }

  Future<void> closeRecorder() async {
    await recorder.closeRecorder();
  }

  // New methods to open and close the player
  Future<void> openPlayer() async {
    await player.openPlayer();
  }

  Future<void> closePlayer() async {
    await player.closePlayer();
  }

  Future<void> stopRecordingAndPlayIt() async {
    await stopRecording();
    await startPlaying();
  }
}
