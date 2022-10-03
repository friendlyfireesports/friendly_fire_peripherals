import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard_configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/mouse/mouse_configuration.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('PeripheralRGB', () {
    test('Stringified colors', () {
      var rgb = MouseRGB(
        mode: 'solid',
        colors: [0xffff0000, 0xff00ff00, 0xff0000ff],
        speed: 2,
        brightness: 3,
      );
      expect(rgb.stringifiedColors, 'ff0000,00ff00,0000ff');

      rgb = MouseRGB(
        mode: 'solid',
        colors: [],
        speed: 2,
        brightness: 3,
      );
      expect(rgb.stringifiedColors, '');
    });

    test('Keyboard Rectification', () {
      final mode = RGBMode(
        name: 'solid',
        colorSpots: 1,
        speeds: [],
        brightnesses: [1, 2, 3],
      );

      var rgb = KeyboardRGB(
        mode: 'solid',
        colors: [0xffff0000],
        speed: 1,
        brightness: 6,
      );
      var rectifiedRGB = rgb.rectified(mode);
      expect(rectifiedRGB.mode, 'solid');
      expect(rectifiedRGB.colors, [0xffff0000]);
      expect(rectifiedRGB.speed, null);
      expect(rectifiedRGB.brightness, 1);

      rgb = KeyboardRGB(
        mode: 'solid',
        colors: [0xff000000, 0xff00ff00],
        speed: 1,
        brightness: 2,
      );
      rectifiedRGB = rgb.rectified(mode);
      expect(rectifiedRGB.mode, 'solid');
      expect(rectifiedRGB.colors, [0xffff0000]);
      expect(rectifiedRGB.speed, null);
      expect(rectifiedRGB.brightness, 2);
    });

    test('Mouse Rectification', () {
      final mode = RGBMode(
        name: 'solid',
        colorSpots: 3,
        speeds: [1, 2],
        brightnesses: [1, 2, 3],
      );

      var rgb = MouseRGB(
        mode: 'solid',
        colors: [0xff000000],
        speed: 2,
        brightness: 3,
      );
      var rectifiedRGB = rgb.rectified(mode);
      expect(rectifiedRGB.mode, 'solid');
      expect(rectifiedRGB.colors, [0xffff0000, 0xffff0000, 0xffff0000]);
      expect(rectifiedRGB.speed, 2);
      expect(rectifiedRGB.brightness, 3);

      rgb = MouseRGB(
        mode: 'solid',
        colors: [0xff000000],
        speed: 3,
        brightness: 3,
      );
      rectifiedRGB = rgb.rectified(mode);
      expect(rectifiedRGB.mode, 'solid');
      expect(rectifiedRGB.colors, [0xffff0000, 0xffff0000, 0xffff0000]);
      expect(rectifiedRGB.speed, 1);
      expect(rectifiedRGB.brightness, 3);

      rgb = MouseRGB(
        mode: 'solid',
        colors: [0xff000000],
        speed: 3,
        brightness: 4,
      );
      rectifiedRGB = rgb.rectified(mode);
      expect(rectifiedRGB.mode, 'solid');
      expect(rectifiedRGB.colors, [0xffff0000, 0xffff0000, 0xffff0000]);
      expect(rectifiedRGB.speed, 1);
      expect(rectifiedRGB.brightness, 1);

      rgb = MouseRGB(
        mode: 'solid',
        colors: [0xffff0000, 0xffff0000, 0xffff0000],
        speed: 2,
        brightness: 2,
      );
      rectifiedRGB = rgb.rectified(mode);
      expect(rectifiedRGB.mode, 'solid');
      expect(rectifiedRGB.colors, [0xffff0000, 0xffff0000, 0xffff0000]);
      expect(rectifiedRGB.speed, 2);
      expect(rectifiedRGB.brightness, 2);
    });
  });
}
