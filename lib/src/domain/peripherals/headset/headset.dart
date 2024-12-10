import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset_configuration.dart';

import '../peripheral.dart';

class Headset extends Peripheral {
  Headset({
    required super.id,
    super.type = PeripheralType.headset,
    required super.name,
    required super.capabilities,
  });

  @override
  HeadsetConfiguration get configuration => config as HeadsetConfiguration;

  @override
  HeadsetConfigurationOptions get configurationOptions =>
      configOptions as HeadsetConfigurationOptions;

  @override
  HeadsetConfiguration get randomConfiguration => HeadsetConfiguration(
        speaker: HeadsetSpeaker.random,
        mic: HeadsetMic.random,
      );
}
