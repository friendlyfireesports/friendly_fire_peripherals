import '../peripheral.dart';
import '../configuration.dart';
import 'mouse_configuration.dart';

class Mouse extends Peripheral {
  Mouse({
    required super.id,
    super.type = PeripheralType.mouse,
    required super.name,
    required super.capabilities,
  });

  bool get supportsRGB => capabilities['supports_rgb'] ?? false;
  bool get supportsDPI => capabilities['supports_dpi'] ?? false;

  @override
  MouseConfiguration get configuration => config as MouseConfiguration;

  @override
  MouseConfigurationOptions get configurationOptions =>
      configOptions as MouseConfigurationOptions;

  RGBMode get currentModeOptions => configurationOptions.rgb.modes.firstWhere(
        (mode) => mode.name == configuration.rgb.mode,
      );

  @override
  MouseConfiguration get randomConfiguration => MouseConfiguration(
        rgb: configurationOptions.rgb.random<MouseRGB>(),
        pr: configurationOptions.randomPR,
        dpi: configurationOptions.dpi.random,
      );
}
