import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peloton_communicator/main.dart';

void main() {
  testWidgets('App renders the button and changes color on long press',
      (WidgetTester tester) async {
    await tester.pumpWidget(PelotonCommunicator());

    // Check if the button is rendered
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Initial button color
    var button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(
        button.style?.backgroundColor, MaterialStateProperty.all(Colors.blue));

    // Long press on the button
    await tester.longPress(find.byType(ElevatedButton));
    await tester.pump();

    // Button color after long press
    button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(
        button.style?.backgroundColor, MaterialStateProperty.all(Colors.red));

    // Release long press
    await tester.longPressEnd(find.byType(ElevatedButton), const Offset(0, 0));
    await tester.pump();

    // Button color after releasing long press
    button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(
        button.style?.backgroundColor, MaterialStateProperty.all(Colors.blue));
  });
}
