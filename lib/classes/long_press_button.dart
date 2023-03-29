import 'package:flutter/material.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/button_state.dart';
import 'package:peloton_communicator/permissions/microphone_permission_handler.dart';

class LongPressButton extends StatefulWidget {
  final AudioRecording audioModel;

  LongPressButton({required this.audioModel});

  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton> {
  MicrophonePermissionHandler microphonePermissionHandler =
      MicrophonePermissionHandler();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.audioModel.startRecording,
      onLongPressEnd: (details) => widget.audioModel.stopRecordingAndPlayIt(),
      // onLongPressEnd: (details) => {
      //   widget.audioModel.stopRecordingAndPlayIt();
      //   widget.audioModel.closeRecorder();
      //   },
      child: Container(
          key: const ValueKey('longPressButton'),
          alignment: Alignment.center,
          color: getColor(),
          child: getText()),
    );
  }

  getColor() {
    if (microphonePermissionHandler.hasPermission()) {
      if (widget.audioModel.buttonState == ButtonState.recording) {
        return Colors.orange[900];
      } else {
        return Colors.green;
      }
    } else {
      return Colors.red[900];
    }
  }

  getText() {
    if (microphonePermissionHandler.hasPermission()) {
      if (widget.audioModel.buttonState == ButtonState.recording) {
        return const Text('Recording...',
            style: TextStyle(fontSize: 24, color: Colors.white));
      } else {
        return const Text('Long Press to Record...',
            style: TextStyle(fontSize: 24, color: Colors.white));
      }
    } else {
      const Text('Communication Functionnality blocked - Access not granted',
          style: TextStyle(fontSize: 24, color: Colors.white));
    }
  }
}
