import 'package:flutter_sound/flutter_sound.dart';

class AudioRecording {
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;

  Future<void> startRecording() async {
    await recorder.startRecorder(toFile: 'audio_recording.aac');
    isRecording = true;
  }

  Future<void> stopRecording() async {
    await recorder.stopRecorder();
    isRecording = false;
  }

  Future<void> openRecorder() async {
    await recorder.openRecorder();
  }

  Future<void> closeRecorder() async {
    await recorder.closeRecorder();
  }
}
