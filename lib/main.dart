import 'package:peloton_communicator/classes/audio_recording.dart';
import 'package:peloton_communicator/classes/long_press_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'classes/button_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ButtonState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Peloton Communicator')),
        body: Center(
          child: Consumer<ButtonState>(
            // child: Consumer<AudioRecording>(
            // builder: (context, audioModel, child) => LongPressButton(audioModel: audioModel),
            /* */
            builder: (context, buttonState, child) {
              return GestureDetector(
                //   onLongPress: _startRecording,
                //   onLongPressEnd: (details) => _stopRecording(),
                //   child: RaisedButton(
                //     key: ValueKey('longPressButton'),
                //     color: _isRecording ? Colors.red : Colors.grey,
                //     onPressed: () {},
                //     child: Text('Long Press to Record'),
                //   ),
                // ),(
                onLongPress: () {
                  buttonState.setLongPressed(true);
                },
                onLongPressEnd: (details) {
                  buttonState.setLongPressed(false);
                },
                child: Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: buttonState.isLongPressed
                        ? Colors.orange[900]
                        : Colors.blue[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    buttonState.isLongPressed ? 'Speaking' : 'Listening',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
