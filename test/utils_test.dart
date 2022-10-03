import 'package:friendly_fire_peripherals/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('hexColorToInt', () {
    test('invalid', () {
      expect(hexColorToInt(null), 0xFFFFFFFF);
      expect(hexColorToInt(''), 0xFFFFFFFF);
      expect(hexColorToInt('abc'), 0xFFFFFFFF);
      expect(hexColorToInt('xyz123'), 0xFFFFFFFF);
    });

    test('valid', () {
      expect(hexColorToInt('123456'), 0xFF123456);
      expect(hexColorToInt('abcdef'), 0xFFABCDEF);
      expect(hexColorToInt('123abc'), 0xFF123ABC);
      expect(hexColorToInt('123ABC'), 0xFF123ABC);
      expect(hexColorToInt('123AbC'), 0xFF123ABC);
    });
  });

  group('intColorToHex', () {
    test('invalid', () {
      expect(intColorToHex(null), 'ffffff');
    });

    test('valid', () {
      expect(intColorToHex(0xFF123456), '123456');
      expect(intColorToHex(0xFF123ABC), '123abc');
      expect(intColorToHex(0xFF1), '100000');
    });
  });
}
