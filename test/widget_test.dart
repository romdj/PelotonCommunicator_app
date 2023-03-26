import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peloton_communicator/main.dart';

void main() {
  testWidgets('LongPressButton changes color on long press',
      (WidgetTester tester) async {
    // Build the LongPressButton widget.
    await tester.pumpWidget(MaterialApp(home: LongPressButton()));

    // Find the button widget.
    final buttonFinder = find.byType(Container);

    // Check the initial color of the button.
    Container container = tester.firstWidget(buttonFinder);
    expect(
        container.decoration,
        BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ));

    // Trigger a long press on the button.
    await tester.longPress(buttonFinder);
    await tester.pump(const Duration(milliseconds: 1000));

    // Check the color of the button after the long press.
    container = tester.firstWidget(buttonFinder);
    expect(
        container.decoration,
        BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ));

    // Release the long press.
    await tester.pumpAndSettle();

    // Check the color of the button after the long press has ended.
    container = tester.firstWidget(buttonFinder);
    expect(
        container.decoration,
        BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ));
  });
}
