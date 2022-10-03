import 'dart:math' as math;

import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';
import 'package:friendly_fire_peripherals/src/domain/core/json_serializable.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset_configuration.dart';
import 'package:friendly_fire_peripherals/src/utils.dart';

abstract class Configuration with JsonSerializable {
  Configuration();

  factory Configuration.fromJson(
      PeripheralType type, Map<String, dynamic> json) {
    switch (type) {
      case PeripheralType.keyboard:
        return KeyboardConfiguration.fromJson(json);
      case PeripheralType.mouse:
        return MouseConfiguration.fromJson(json);
      case PeripheralType.headset:
        return HeadsetConfiguration.fromJson(json);
      default:
        throw Exception('Not supported');
    }
  }

  Configuration rectified(ConfigurationOptions configurationOptions);
}

abstract class ConfigurationOptions with JsonSerializable {}

abstract class PeripheralRGB with JsonSerializable {
  PeripheralRGB({
    required this.mode,
    this.colors,
    this.speed,
    this.brightness,
  });

  factory PeripheralRGB.fromJson(
    Map<String, dynamic> json,
    PeripheralType type,
  ) {
    switch (type) {
      case PeripheralType.keyboard:
        return KeyboardRGB(
          mode: json['mode'],
          colors: ((json['colors'] ?? []) as List)
              .map((c) => hexColorToInt(c))
              .toList(),
          speed: json['speed'],
          brightness: json['brightness'],
        );
      case PeripheralType.mouse:
        return MouseRGB(
          mode: json['mode'],
          colors: ((json['colors'] ?? []) as List)
              .map((c) => hexColorToInt(c))
              .toList(),
          speed: json['speed'],
          brightness: json['brightness'],
        );

      default:
        throw Exception('Not supported');
    }
  }

  final String mode;
  final List<int>? colors;
  final int? speed;
  final int? brightness;

  String? get stringifiedColors =>
      colors?.map((c) => intColorToHex(c)).join(',');

  PeripheralRGB rectified(RGBMode mode);

  @override
  PeripheralRGB fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() => {
        'mode': mode,
        'colors': colors?.map((c) => intColorToHex(c)).toList(),
        'speed': speed,
        'brightness': brightness,
      };

  @override
  operator ==(Object? other) =>
      other is PeripheralRGB &&
      other.mode == mode &&
      other.colors == colors &&
      other.speed == speed &&
      other.brightness == brightness;

  @override
  int get hashCode => Object.hash(mode, colors, speed, brightness);
}

abstract class PeripheralRGBOptions extends ConfigurationOptions {
  PeripheralRGBOptions({
    required this.colors,
    required this.modes,
  });

  final List<int> colors;
  final List<RGBMode> modes;

  factory PeripheralRGBOptions.fromJson(
    Map<String, dynamic> json,
    PeripheralType type,
  ) {
    switch (type) {
      case PeripheralType.keyboard:
        return KeyboardRGBOptions(
          colors: json['predefined_colors'] != null
              ? List<String>.from(json['predefined_colors'])
                  .map((color) => hexColorToInt(color))
                  .toList()
              : [],
          modes: (json['modes'] as Map)
              .map((key, value) => MapEntry(key, RGBMode.fromJson(key, value)))
              .values
              .toList(),
        );
      case PeripheralType.mouse:
        return MouseRGBOptions(
          colors: json['predefined_colors'] != null
              ? List<String>.from(json['predefined_colors'])
                  .map((color) => hexColorToInt(color))
                  .toList()
              : [0xffff0000],
          modes: (json['modes'] as Map)
              .map((key, value) => MapEntry(key, RGBMode.fromJson(key, value)))
              .values
              .toList(),
        );

      default:
        throw Exception('Not supported');
    }
  }

  final _rng = math.Random();
  T random<T extends PeripheralRGB>() {
    final mode = modes[_rng.nextInt(modes.length)];
    if (T == KeyboardRGB) {
      return KeyboardRGB(
        mode: mode.name,
        colors: mode.colorSpots > 0
            ? List.generate(
                mode.colorSpots,
                (_) => colors[_rng.nextInt(colors.length)],
              )
            : null,
        speed: mode.speeds.isNotEmpty
            ? mode.speeds[_rng.nextInt(mode.speeds.length)]
            : null,
        brightness: mode.brightnesses.isNotEmpty
            ? mode.brightnesses[_rng.nextInt(mode.brightnesses.length)]
            : null,
      ) as T;
    }
    if (T == MouseRGB) {
      return MouseRGB(
        mode: mode.name,
        colors: mode.colorSpots > 0
            ? List.generate(
                mode.colorSpots,
                (_) => colors[_rng.nextInt(colors.length)],
              )
            : null,
        speed: mode.speeds.isNotEmpty
            ? mode.speeds[_rng.nextInt(mode.speeds.length)]
            : null,
        brightness: mode.brightnesses.isNotEmpty
            ? mode.brightnesses[_rng.nextInt(mode.brightnesses.length)]
            : null,
      ) as T;
    }
    throw Exception('Not supported');
  }

  @override
  PeripheralRGBOptions fromJson(Map<String, dynamic> json);

  @override
  Map<String, dynamic> toJson() => {
        'colors': colors,
        'modes': modes.map((mode) => mode.toJson()).toList(),
      };
}

class RGBMode with JsonSerializable {
  RGBMode({
    required this.name,
    required this.colorSpots,
    required this.speeds,
    required this.brightnesses,
  });

  final String name;
  final int colorSpots;
  final List<int> speeds;
  final List<int> brightnesses;

  List<int> get defaultColors => List.generate(colorSpots, (_) => 0xffff0000);
  int? get defaultSpeed => speeds.isNotEmpty ? speeds.first : null;
  int? get defaultBrightness =>
      brightnesses.isNotEmpty ? brightnesses.first : null;

  String get features =>
      '${colorSpots > 0 ? 'C' : ''}${speeds.isNotEmpty ? 'S' : ''}${brightnesses.isNotEmpty ? 'B' : ''}';

  factory RGBMode.fromJson(String name, Map<String, dynamic> json) => RGBMode(
        name: name,
        colorSpots: json['color_spots'],
        speeds: List<int>.from(json['speed']),
        brightnesses: List<int>.from(json['brightness']),
      );

  bool isValidRGB(PeripheralRGB rgb) =>
      isValidName(rgb.mode) &&
      isValidColors(rgb.colors) &&
      isValidSpeed(rgb.speed) &&
      isValidBrightness(rgb.brightness);

  bool isValidName(String mode) => mode == name;
  bool isValidColors(List<int>? colors) => colors?.length == colorSpots;
  bool isValidSpeed(int? speed) =>
      (speed == null && speeds.isEmpty) || speeds.contains(speed);
  bool isValidBrightness(int? brightness) =>
      (brightness == null && brightnesses.isEmpty) ||
      brightnesses.contains(brightness);

  @override
  RGBMode fromJson(Map<String, dynamic> json) =>
      RGBMode.fromJson(json['name'], json);

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'color_spots': colorSpots,
        'speeds': speeds,
        'brightnesses': brightnesses,
      };
}
