import 'dart:math' as math;

import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/peripheral.dart';
import 'package:friendly_fire_peripherals/src/utils.dart';

class MouseConfiguration extends Configuration {
  MouseConfiguration({
    required this.rgb,
    required this.pr,
    required this.dpi,
  });

  final MouseRGB rgb;
  final int pr;
  final MouseDPI dpi;

  factory MouseConfiguration.fromJson(Map<String, dynamic> json) =>
      MouseConfiguration(
        rgb: MouseRGB.fromJson(json['rgb']),
        pr: json['pr'],
        dpi: MouseDPI.fromData(json['dpi']),
      );

  MouseConfiguration copyWith({
    MouseRGB? rgb,
    int? pr,
    MouseDPI? dpi,
  }) =>
      MouseConfiguration(
        rgb: rgb ?? this.rgb,
        pr: pr ?? this.pr,
        dpi: dpi ?? this.dpi,
      );

  @override
  MouseConfiguration rectified(ConfigurationOptions configurationOptions) {
    final options = configurationOptions as MouseConfigurationOptions;
    late RGBMode mode;
    try {
      if (options.rgb.modes.isEmpty) {
        mode = RGBMode(
            name: 'default', colorSpots: 0, speeds: [1], brightnesses: [1]);
      } else {
        mode = options.rgb.modes.firstWhere((mode) => mode.name == rgb.mode);
      }
    } catch (_) {
      mode = options.rgb.modes.first;
    }
    return MouseConfiguration(
      rgb: rgb.rectified(mode),
      dpi: dpi, // TODO
      pr: pr, // TODO
    );
  }

  @override
  MouseConfiguration fromJson(Map<String, dynamic> json) =>
      MouseConfiguration.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'rgb': rgb.toJson(),
        'pr': pr,
        'dpi': dpi.toString(),
      };
}

class MouseConfigurationOptions extends ConfigurationOptions {
  MouseConfigurationOptions({
    required this.rgb,
    required this.prs,
    required this.dpi,
  });

  final MouseRGBOptions rgb;
  final List<int> prs;
  final MouseDPIOptions dpi;

  final _rng = math.Random();
  int get randomPR => prs[_rng.nextInt(prs.length)];

  factory MouseConfigurationOptions.fromJson(Map<String, dynamic> json) {
    return MouseConfigurationOptions(
      rgb: MouseRGBOptions.fromJson(json['rgb']),
      prs: (json['pr'] as List).map((pr) => int.tryParse(pr) ?? 125).toList(),
      dpi: MouseDPIOptions.fromJson(json['dpi']),
    );
  }
  @override
  MouseConfigurationOptions fromJson(Map<String, dynamic> json) =>
      MouseConfigurationOptions.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'rgb': rgb.toJson(),
        'prs': prs,
        'dpi': dpi.toJson(),
      };
}

class MouseRGB extends PeripheralRGB {
  MouseRGB({
    required String mode,
    List<int>? colors,
    int? speed,
    int? brightness,
  }) : super(mode: mode, colors: colors, speed: speed, brightness: brightness);

  factory MouseRGB.fromJson(Map<String, dynamic> json) =>
      PeripheralRGB.fromJson(json, PeripheralType.mouse) as MouseRGB;

  MouseRGB copyWith({
    String? mode,
    List<int>? colors,
    int? speed,
    int? brightness,
  }) =>
      MouseRGB(
        mode: mode ?? this.mode,
        colors: colors ?? this.colors,
        speed: speed ?? this.speed,
        brightness: brightness ?? this.brightness,
      );

  @override
  MouseRGB rectified(RGBMode mode) {
    return MouseRGB(
      mode: mode.isValidName(this.mode) ? this.mode : mode.name,
      colors: mode.isValidColors(colors) ? colors : mode.defaultColors,
      speed: mode.isValidSpeed(speed) ? speed : mode.defaultSpeed,
      brightness: mode.isValidBrightness(brightness)
          ? brightness
          : mode.defaultBrightness,
    );
  }

  @override
  PeripheralRGB fromJson(Map<String, dynamic> json) => MouseRGB.fromJson(json);
}

class MouseRGBOptions extends PeripheralRGBOptions {
  MouseRGBOptions({
    required List<int> colors,
    required List<RGBMode> modes,
  }) : super(colors: colors, modes: modes);

  factory MouseRGBOptions.fromJson(Map<String, dynamic> json) =>
      PeripheralRGBOptions.fromJson(json, PeripheralType.mouse)
          as MouseRGBOptions;

  @override
  MouseRGBOptions fromJson(Map<String, dynamic> json) =>
      MouseRGBOptions.fromJson(json);
}

class DPIValue {
  DPIValue(this.color, this.value);

  final int color;
  final int value;

  @override
  String toString() => '${intColorToHex(color)}:$value';
}

class MouseDPI {
  MouseDPI({required this.values});

  factory MouseDPI.fromData(dynamic dpis) {
    if (dpis is List) {
      return MouseDPI.fromJsonList(dpis);
    } else {
      return MouseDPI.fromString(dpis);
    }
  }

  factory MouseDPI.fromJsonList(List<dynamic> dpis) {
    final values = <DPIValue>[];
    for (var json in dpis) {
      values.add(
        DPIValue(
          hexColorToInt(json['color']),
          json['x'],
        ),
      );
    }
    return MouseDPI(values: values);
  }

  factory MouseDPI.fromString(String dpis) {
    final split = dpis.split(',');
    final values = <DPIValue>[];
    for (var dpi in split) {
      final cv = dpi.split(':');
      values.add(
        DPIValue(
          hexColorToInt(cv[0]),
          int.tryParse(cv[1]) ?? 100,
        ),
      );
    }
    return MouseDPI(values: values);
  }

  final List<DPIValue> values;

  @override
  String toString() => values.map((value) => value.toString()).join(',');

  @override
  operator ==(Object? other) =>
      other is MouseDPI && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;
}

class MouseDPIOptions extends ConfigurationOptions {
  MouseDPIOptions({
    required this.colors,
    required this.slots,
    required this.min,
    required this.max,
  });

  final List<int> colors;
  final int slots;
  final int min;
  final int max;

  factory MouseDPIOptions.fromJson(Map<String, dynamic> json) =>
      MouseDPIOptions(
        colors: List<String>.from(json['predefined_colors'])
            .map((color) => hexColorToInt(color))
            .toList(),
        slots: json['dpi_slots'],
        min: json['min_value'],
        max: json['max_value'],
      );

  final _rng = math.Random();
  MouseDPI get random {
    return MouseDPI(
      values: List.generate(
        6,
        (_) => DPIValue(
          colors.isNotEmpty ? colors[_rng.nextInt(colors.length)] : 0xffff0000,
          ((min + _rng.nextInt(max - min)) ~/ 100) * 100,
        ),
      ),
    );
  }

  @override
  MouseDPIOptions fromJson(Map<String, dynamic> json) =>
      MouseDPIOptions.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'colors': colors,
        'slots': slots,
        'min': min,
        'max': max,
      };
}
