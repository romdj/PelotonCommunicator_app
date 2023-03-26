import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Long Press Color Change'),
        ),
        body: Center(
          child: LongPressButton(),
        ),
      ),
    );
  }
}

class LongPressButton extends StatefulWidget {
  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton> {
  bool _isLongPressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isLongPressing = true;
        });
      },
      onLongPressEnd: (details) {
        setState(() {
          _isLongPressing = false;
        });
      },
      child: Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isLongPressing ? Colors.red : Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Press and hold',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
