import '../peripheral.dart';
import '../configuration.dart';
import 'keyboard_configuration.dart';

class Keyboard extends Peripheral {
  Keyboard({
    required super.id,
    super.type = PeripheralType.keyboard,
    required super.name,
    required super.capabilities,
  });

  @override
  KeyboardConfiguration get configuration => config as KeyboardConfiguration;

  @override
  KeyboardConfigurationOptions get configurationOptions =>
      configOptions as KeyboardConfigurationOptions;

  RGBMode get currentModeOptions => configurationOptions.rgb.modes.firstWhere(
        (mode) => mode.name == configuration.rgb.mode,
      );

  @override
  KeyboardConfiguration get randomConfiguration => KeyboardConfiguration(
        rgb: configurationOptions.rgb.random<KeyboardRGB>(),
        pr: configurationOptions.randomPR,
        td: configurationOptions.randomTD,
        dz: configurationOptions.randomDZ,
      );
}

extension SupportedCapabilities on Keyboard {
  bool get supportsShining => capabilities['supports_shining'] ?? false;
  bool get supportsPollingRate =>
      capabilities['supports_polling_rate'] ?? false;
  bool get supportsTravelDistance =>
      capabilities['supports_travel_distance'] ?? false;
  bool get supportsDeadzones => capabilities['supports_deadzones'] ?? false;
}
