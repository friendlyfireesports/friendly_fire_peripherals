import 'package:friendly_fire_peripherals/src/domain/peripherals/peripheral.dart';
import 'package:test/test.dart';

void main() {
  group('Peripheral', () {
    test('toString', () {
      final device = Peripheral.fromStrings(id: 'x', type: 'mouse', name: 'X');
      final str = device.toString();
      expect(str, '{"id":"x","type":"mouse","name":"X"}');
    });

    test('equality', () {
      final device1 = Peripheral.fromStrings(id: 'x', type: 'mouse', name: 'X');
      final device2 = Peripheral.fromStrings(id: 'x', type: 'mouse', name: 'X');
      expect(device1 == device2, isTrue);

      final device3 = Peripheral.fromStrings(id: 'x', type: 'mouse', name: 'X');
      final device4 = Peripheral.fromStrings(id: 'y', type: 'mouse', name: 'X');
      expect(device3 == device4, isFalse);

      final device5 = Peripheral.fromStrings(id: 'x', type: 'mouse', name: 'X');
      final device6 =
          Peripheral.fromStrings(id: 'y', type: 'keyboard', name: 'X');
      expect(device5 == device6, isFalse);
    });

    test('hash', () {
      final set = <Peripheral>{};
      set
        ..add(Peripheral.fromStrings(id: 'x', type: 'keyboard', name: 'X'))
        ..add(Peripheral.fromStrings(id: 'y', type: 'keyboard', name: 'X'));

      expect(set.length, 2);
    });
  });
}
