import 'dart:math' as math;

import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/peripheral.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/deadzone.dart';

class KeyboardConfiguration extends Configuration {
  KeyboardConfiguration({
    required this.rgb,
    this.pr,
    this.td,
    this.dz,
  });

  final KeyboardRGB rgb;
  final int? pr;
  final double? td;
  final Deadzone? dz;

  factory KeyboardConfiguration.fromJson(Map<String, dynamic> json) {
    if ((json['pr'] ?? json['td'] ?? json['dz']) == null) {
      return KeyboardConfiguration(rgb: KeyboardRGB.fromJson(json['rgb']));
    }
    return KeyboardConfiguration(
      rgb: KeyboardRGB.fromJson(json['rgb']),
      pr: json['pr'] is int ? json['pr'] : (json['pr']?['value'] ?? 8000),
      td: json['td'] is num
          ? (json['td'] as num).toDouble()
          : ((json['td']?['value'] ?? 2.0) as num).toDouble(),
      dz: Deadzone.fromJson(json['dz']),
    );
  }

  KeyboardConfiguration copyWith({
    KeyboardRGB? rgb,
    int? pr,
    double? td,
    Deadzone? dz,
  }) =>
      KeyboardConfiguration(
        rgb: rgb ?? this.rgb,
        pr: pr ?? this.pr,
        td: td ?? this.td,
        dz: dz ?? this.dz,
      );

  @override
  KeyboardConfiguration rectified(ConfigurationOptions configurationOptions) {
    final options = configurationOptions as KeyboardConfigurationOptions;
    late RGBMode mode;
    try {
      mode = options.rgb.modes.firstWhere((mode) => mode.name == rgb.mode);
    } catch (_) {
      mode = options.rgb.modes.first;
    }
    return KeyboardConfiguration(
      rgb: rgb.rectified(mode),
      pr: pr,
      td: td,
      dz: dz?.rectified(),
    );
  }

  @override
  KeyboardConfiguration fromJson(Map<String, dynamic> json) =>
      KeyboardConfiguration.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'rgb': rgb.toJson(),
        if (pr != null) 'pr': pr,
        if (td != null) 'td': td,
        if (dz != null) 'dz': dz!.toJson(),
      };
}

class KeyboardConfigurationOptions extends ConfigurationOptions {
  KeyboardConfigurationOptions({
    required this.rgb,
    required this.prs,
    required this.td,
    required this.dz,
  });

  final KeyboardRGBOptions rgb;
  final List<int> prs;
  final KeyboardTravelDistanceOptions td;
  final KeyboardDeadzoneOptions dz;

  final _rng = math.Random();
  int get randomPR => prs[_rng.nextInt(prs.length)];
  double get randomTD => td.random;
  Deadzone get randomDZ => dz.random;

  factory KeyboardConfigurationOptions.fromJson(Map<String, dynamic> json) =>
      KeyboardConfigurationOptions(
        rgb: KeyboardRGBOptions.fromJson(json['rgb']),
        prs: (json['pr'] as List).map((pr) => pr as int).toList(),
        td: KeyboardTravelDistanceOptions.fromJson(json['td']),
        dz: KeyboardDeadzoneOptions.fromJson(json['dz']),
      );

  @override
  KeyboardConfiguration fromJson(Map<String, dynamic> json) =>
      KeyboardConfiguration.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'rgb': rgb.toJson(),
        'prs': prs,
        'td': td.toJson(),
        'dz': dz.toJson(),
      };
}

class KeyboardRGB extends PeripheralRGB {
  KeyboardRGB({
    required String mode,
    List<int>? colors,
    int? speed,
    int? brightness,
    bool? shining,
  }) : super(
          mode: mode,
          colors: colors,
          speed: speed,
          brightness: brightness,
          shining: shining,
        );

  factory KeyboardRGB.fromJson(Map<String, dynamic> json) =>
      PeripheralRGB.fromJson(json, PeripheralType.keyboard) as KeyboardRGB;

  KeyboardRGB copyWith({
    String? mode,
    List<int>? colors,
    int? speed,
    int? brightness,
    bool? shining,
  }) =>
      KeyboardRGB(
        mode: mode ?? this.mode,
        colors: colors ?? this.colors,
        speed: speed ?? this.speed,
        brightness: brightness ?? this.brightness,
        shining: shining ?? this.shining,
      );

  @override
  KeyboardRGB rectified(RGBMode mode) {
    return KeyboardRGB(
      mode: mode.isValidName(this.mode) ? this.mode : mode.name,
      colors: mode.isValidColors(colors) ? colors : mode.defaultColors,
      speed: mode.isValidSpeed(speed) ? speed : mode.defaultSpeed,
      brightness: mode.isValidBrightness(brightness)
          ? brightness
          : mode.defaultBrightness,
      shining: mode.isValidShining(shining) ? shining : mode.defaultShining,
    );
  }

  @override
  PeripheralRGB fromJson(Map<String, dynamic> json) =>
      KeyboardRGB.fromJson(json);
}

class KeyboardRGBOptions extends PeripheralRGBOptions {
  KeyboardRGBOptions({
    required List<int> colors,
    required List<RGBMode> modes,
  }) : super(colors: colors, modes: modes);

  factory KeyboardRGBOptions.fromJson(Map<String, dynamic> json) =>
      PeripheralRGBOptions.fromJson(json, PeripheralType.keyboard)
          as KeyboardRGBOptions;

  @override
  KeyboardRGBOptions fromJson(Map<String, dynamic> json) =>
      KeyboardRGBOptions.fromJson(json);
}

class KeyboardTravelDistanceOptions extends ConfigurationOptions {
  KeyboardTravelDistanceOptions({
    required this.min,
    required this.max,
    required this.increment,
  });

  final double min;
  final double max;
  final double increment;

  factory KeyboardTravelDistanceOptions.fromJson(Map<String, dynamic> json) =>
      KeyboardTravelDistanceOptions(
        min: (json['min_value'] as num).toDouble(),
        max: (json['max_value'] as num).toDouble(),
        increment: (json['increment'] as num).toDouble(),
      );

  final _rng = math.Random();
  double get random {
    final steps = ((max - min) / increment).floor();
    return min + (_rng.nextInt(steps + 1) * increment);
  }

  @override
  KeyboardTravelDistanceOptions fromJson(Map<String, dynamic> json) =>
      KeyboardTravelDistanceOptions.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'min': min,
        'max': max,
        'increment': increment,
      };
}

class KeyboardDeadzoneOptions extends ConfigurationOptions {
  KeyboardDeadzoneOptions({
    required this.min,
    required this.max,
    required this.increment,
  });

  final double min;
  final double max;
  final double increment;

  factory KeyboardDeadzoneOptions.fromJson(Map<String, dynamic> json) =>
      KeyboardDeadzoneOptions(
        min: (json['min_value'] as num).toDouble(),
        max: (json['max_value'] as num).toDouble(),
        increment: (json['increment'] as num).toDouble(),
      );

  final _rng = math.Random();
  Deadzone get random {
    // return Deadzone(top: 0.45, bottom: 0.43);
    final steps = ((max - min) / increment).floor();
    final topValue = min + (_rng.nextInt(steps + 1) * increment);
    final bottomValue = min + (_rng.nextInt(steps + 1) * increment);
    return Deadzone(
      top: topValue,
      bottom: bottomValue,
    );
  }

  @override
  KeyboardDeadzoneOptions fromJson(Map<String, dynamic> json) =>
      KeyboardDeadzoneOptions.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'min': min,
        'max': max,
        'increment': increment,
      };
}
