import 'package:flutter/material.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/button_state.dart';
import 'package:peloton_communicator/permissions/microphone_permission_handler.dart';
import 'package:peloton_communicator/permissions/permission_handler.dart';

import '../permissions/microphone_permission_handler.dart';

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
      // onForcePressStart: widget.audioModel.startRecording,
      onLongPress: widget.audioModel.startRecording,
      onLongPressEnd: (details) => widget.audioModel.stopRecording(),
      child: Container(
          key: ValueKey('longPressButton'),
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
        return Text('Recording...',
            style: TextStyle(fontSize: 24, color: Colors.white));
      } else {
        return Text('Long Press to Record...',
            style: TextStyle(fontSize: 24, color: Colors.white));
      }
    } else {
      Text('Communication Functionnality blocked - Access not granted',
          style: TextStyle(fontSize: 24, color: Colors.white));
    }
  }
}
