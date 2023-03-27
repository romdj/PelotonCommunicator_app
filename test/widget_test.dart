/* import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peloton_communicator/main.dart';

void main() {
  testWidgets('Long press on button changes its color',
      (WidgetTester tester) async {
    // Build the MaterialApp with the LongPressButton widget
    await tester.pumpWidget(MyApp());

    // Find the button by key
    final buttonFinder = find.byKey(ValueKey('longPressButton'));

    // Perform a long press on the button
    await tester.longPress(buttonFinder);

    // Wait for 300ms to exceed the duration of a long press
    await tester.pump(Duration(milliseconds: 300));

    // Verify that the button color changed to the active color
    Color activeColor = Colors.red;
    var button = tester.widget<RaisedButton>(buttonFinder);
    expect(button.color, activeColor);
  });

  testWidgets(
      'Releasing long press on button changes its color back to initial color',
      (WidgetTester tester) async {
    // Build the MaterialApp with the LongPressButton widget
    await tester.pumpWidget(MyApp());

    // Find the button by key
    final buttonFinder = find.byKey(ValueKey('longPressButton'));

    // Perform a long press on the button
    await tester.longPress(buttonFinder);

    // Wait for 300ms to exceed the duration of a long press
    await tester.pump(Duration(milliseconds: 300));

    // Release the long press
    await tester.longPressEnd(buttonFinder);

    // Verify that the button color changed back to the initial color
    Color initialColor = Colors.grey;
    var button = tester.widget<RaisedButton>(buttonFinder);
    expect(button.color, initialColor);
  });
}
 */