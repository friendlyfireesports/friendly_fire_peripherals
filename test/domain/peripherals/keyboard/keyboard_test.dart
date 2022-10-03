// import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard_configuration.dart';
import 'package:test/test.dart';

void main() {
  group('Keyboard', () {
    // final keyboard = Keyboard(id: 'x');
  });

  group('KeyboardRGB', () {
    final keyboardRGB = KeyboardRGB(mode: 'xxx');

    test('copyWith', () {
      var keyboardRGB1 = keyboardRGB.copyWith(speed: 1);
      expect(keyboardRGB1.speed, 1);
      keyboardRGB1 = keyboardRGB1.copyWith(speed: 2);
      expect(keyboardRGB1.speed, 2);
    });

    test('equality', () {
      expect(keyboardRGB == keyboardRGB, isTrue);

      final keyboardRGB1 = keyboardRGB.copyWith(brightness: 1);
      final keyboardRGB2 = keyboardRGB.copyWith(brightness: 2);
      expect(keyboardRGB1 == keyboardRGB2, isFalse);

      final keyboardRGB3 = KeyboardRGB(
        mode: 'solid',
        colors: [0xffff0000],
        speed: 1,
        brightness: 2,
      );
      final keyboardRGB4 = KeyboardRGB(
        mode: 'disabled',
        colors: [0xff00ff00],
        speed: 2,
        brightness: 3,
      );
      expect(keyboardRGB3 == keyboardRGB4, isFalse);
    });

    test('hash', () {
      final set = <KeyboardRGB>{};
      set
        ..add(keyboardRGB.copyWith(brightness: 1))
        ..add(keyboardRGB.copyWith(brightness: 2));

      expect(set.length, 2);
    });
  });
}
