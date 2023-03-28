import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:peloton_communicator/classes/button_state.dart';

class AudioRecording extends ChangeNotifier {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  ButtonState buttonState = ButtonState.idle;

  Future<void> startRecording() async {
    await openRecorder();
    await recorder.startRecorder(toFile: 'audio_recording.aac');
    buttonState = ButtonState.recording;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();
    buttonState = ButtonState.idle;
    notifyListeners();
    closeRecorder();
  }

  Future<void> openRecorder() async {
    await recorder.openRecorder();
  }

  Future<void> closeRecorder() async {
    await recorder.closeRecorder();
  }
}
