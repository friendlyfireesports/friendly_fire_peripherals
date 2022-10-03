import 'dart:convert';

import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';
import 'package:test/test.dart';

void main() {
  group('MouseDPI', () {
    test('fromJsonList', () {
      final jsonListString =
          '[{"x":100,"y":100,"independent_axis":false,"color":"f00000"},{"x":200,"y":200,"independent_axis":false,"color":"ff0000"},{"x":300,"y":300,"independent_axis":false,"color":"fff000"},{"x":400,"y":400,"independent_axis":false,"color":"ffff00"},{"x":500,"y":500,"independent_axis":false,"color":"fffff0"},{"x":600,"y":600,"independent_axis":false,"color":"ffffff"}]';
      final jsonList = json.decode(jsonListString);
      final mouseDPI = MouseDPI.fromJsonList(jsonList);

      expect(mouseDPI.values[0].color, 0xfff00000);
      expect(mouseDPI.values[0].value, 100);

      expect(mouseDPI.values[1].color, 0xffff0000);
      expect(mouseDPI.values[1].value, 200);

      expect(mouseDPI.values[2].color, 0xfffff000);
      expect(mouseDPI.values[2].value, 300);

      expect(mouseDPI.values[3].color, 0xffffff00);
      expect(mouseDPI.values[3].value, 400);

      expect(mouseDPI.values[4].color, 0xfffffff0);
      expect(mouseDPI.values[4].value, 500);

      expect(mouseDPI.values[5].color, 0xffffffff);
      expect(mouseDPI.values[5].value, 600);
    });

    test('fromString', () {
      final dpiString =
          'f00000:100,ff0000:200,fff000:300,ffff00:400,fffff0:500,ffffff:600';
      final mouseDPI = MouseDPI.fromString(dpiString);

      expect(mouseDPI.values[0].color, 0xfff00000);
      expect(mouseDPI.values[0].value, 100);

      expect(mouseDPI.values[1].color, 0xffff0000);
      expect(mouseDPI.values[1].value, 200);

      expect(mouseDPI.values[2].color, 0xfffff000);
      expect(mouseDPI.values[2].value, 300);

      expect(mouseDPI.values[3].color, 0xffffff00);
      expect(mouseDPI.values[3].value, 400);

      expect(mouseDPI.values[4].color, 0xfffffff0);
      expect(mouseDPI.values[4].value, 500);

      expect(mouseDPI.values[5].color, 0xffffffff);
      expect(mouseDPI.values[5].value, 600);
    });

    test('toString', () {
      final mouseDPI = MouseDPI(
        values: [
          DPIValue(0xfff00000, 100),
          DPIValue(0xffff0000, 200),
          DPIValue(0xfffff000, 300),
          DPIValue(0xffffff00, 400),
          DPIValue(0xfffffff0, 500),
          DPIValue(0xffffffff, 600),
        ],
      );

      expect(
        mouseDPI.toString(),
        'f00000:100,ff0000:200,fff000:300,ffff00:400,fffff0:500,ffffff:600',
      );
    });

    test('equality', () {
      final mouseDPI1 = MouseDPI.fromString(
        'f00000:100,ff0000:200,fff000:300,ffff00:400,fffff0:500,ffffff:600',
      );
      expect(mouseDPI1 == mouseDPI1, true);

      final mouseDPI2 = MouseDPI.fromString(
        'f00000:100,ff0000:200,fff000:300,ffff00:400,fffff0:500,ffffff:700',
      );
      expect(mouseDPI1 == mouseDPI2, false);

      final mouseDPI3 = MouseDPI.fromString(
        'f00000:100,ff0000:200,fff000:300,ffff00:400,fffff0:500,ffffff:600',
      );
      expect(mouseDPI1 == mouseDPI3, true);
    });
  });
}
