import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/peripheral.dart';

class KeyboardConfiguration extends Configuration {
  KeyboardConfiguration({required this.rgb});

  final KeyboardRGB rgb;

  factory KeyboardConfiguration.fromJson(Map<String, dynamic> json) =>
      KeyboardConfiguration(
        rgb: KeyboardRGB.fromJson(json['rgb']),
      );

  @override
  KeyboardConfiguration rectified(ConfigurationOptions configurationOptions) {
    final mode = (configurationOptions as KeyboardConfigurationOptions)
        .rgb
        .modes
        .firstWhere(
          (mode) => mode.name == rgb.mode,
        );
    return KeyboardConfiguration(
      rgb: rgb.rectified(mode),
    );
  }

  @override
  KeyboardConfiguration fromJson(Map<String, dynamic> json) =>
      KeyboardConfiguration.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {'rgb': rgb.toJson()};
}

class KeyboardConfigurationOptions extends ConfigurationOptions {
  KeyboardConfigurationOptions({required this.rgb});

  final KeyboardRGBOptions rgb;

  factory KeyboardConfigurationOptions.fromJson(Map<String, dynamic> json) =>
      KeyboardConfigurationOptions(
        rgb: KeyboardRGBOptions.fromJson(json['rgb']),
      );

  @override
  KeyboardConfiguration fromJson(Map<String, dynamic> json) =>
      KeyboardConfiguration.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {'rgb': rgb.toJson()};
}

class KeyboardRGB extends PeripheralRGB {
  KeyboardRGB({
    required String mode,
    List<int>? colors,
    int? speed,
    int? brightness,
  }) : super(mode: mode, colors: colors, speed: speed, brightness: brightness);

  factory KeyboardRGB.fromJson(Map<String, dynamic> json) =>
      PeripheralRGB.fromJson(json, PeripheralType.keyboard) as KeyboardRGB;

  KeyboardRGB copyWith({
    String? mode,
    List<int>? colors,
    int? speed,
    int? brightness,
  }) =>
      KeyboardRGB(
        mode: mode ?? this.mode,
        colors: colors ?? this.colors,
        speed: speed ?? this.speed,
        brightness: brightness ?? this.brightness,
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
