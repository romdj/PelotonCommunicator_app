import 'package:flutter/material.dart';
import 'package:peloton_communicator/classes/audio_recording.dart';

class LongPressButton extends StatefulWidget {
  final AudioRecording audioModel;

  LongPressButton({required this.audioModel});

  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: widget.audioModel.startRecording,
      onLongPressEnd: (details) => widget.audioModel.stopRecording(),
      child: Container(
        key: ValueKey('longPressButton'),
        alignment: Alignment.center,
        color: widget.audioModel.isRecording ? Colors.red : Colors.green,
        child: Text(
          widget.audioModel.isRecording
              ? 'Recording...'
              : 'Long Press to Record',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}