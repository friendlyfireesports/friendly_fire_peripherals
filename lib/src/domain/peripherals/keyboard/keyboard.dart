import '../peripheral.dart';
import '../configuration.dart';
import 'keyboard_configuration.dart';

class Keyboard extends Peripheral {
  Keyboard({
    required super.id,
    super.type = PeripheralType.keyboard,
    required super.name,
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
      );
}
