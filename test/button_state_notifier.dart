import 'package:flutter_test/flutter_test.dart';
import 'package:peloton_communicator/classes/long_press_button.dart';

void main() {
  group('ButtonStateNotifier', () {
    test('Initial state is not pressed', () {
      final buttonStateNotifier = ButtonStateNotifier();
      expect(buttonStateNotifier.state, ButtonState.notPressed);
    });

    test('Set state to pressed', () {
      final buttonStateNotifier = ButtonStateNotifier();
      buttonStateNotifier.setPressedState();
      expect(buttonStateNotifier.state, ButtonState.pressed);
    });

    test('Set state to not pressed', () {
      final buttonStateNotifier = ButtonStateNotifier();
      buttonStateNotifier.setNotPressedState();
      expect(buttonStateNotifier.state, ButtonState.notPressed);
    });
  });
}
