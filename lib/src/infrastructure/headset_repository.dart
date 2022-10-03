import 'dart:convert';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client_consumer.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset_configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset_repository.dart';

class LocalHeadsetRepository extends DynamicLibraryClientConsumer
    implements HeadsetRepository {
  LocalHeadsetRepository(super.client);

  late HeadsetConfiguration _currentConfiguration;

  @override
  HeadsetConfigurationOptions readConfigurationOptions(Headset peripheral) {
    final response = client.headset('config');
    final messageJson = json.decode(response.dMessage);
    return HeadsetConfigurationOptions.fromJson(messageJson);
  }

  @override
  HeadsetConfiguration readConfiguration(Headset peripheral) {
    final response = client.headset('get', 'all');
    final messageJson = json.decode(response.dMessage);
    _currentConfiguration = HeadsetConfiguration.fromJson(messageJson);
    return _currentConfiguration;
  }

  @override
  bool writeConfiguration(
    Headset peripheral,
    HeadsetConfiguration configuration,
  ) {
    configuration.speaker.toJson().forEach((setting, value) {
      if (_currentConfiguration.speaker.toJson()[setting] != value) {
        if (value is bool) {
          value = value ? 1 : 0;
        }
        final response = client.headset('set', setting, value);
        if (!response.success) {
          //
        }
      }
    });
    configuration.mic.toJson().forEach((setting, value) {
      if (_currentConfiguration.mic.toJson()[setting] != value) {
        if (value is bool) {
          value = value ? 1 : 0;
        }
        final response = client.headset('set', 'mic_$setting', value);
        if (!response.success) {
          //
        }
      }
    });
    _currentConfiguration = configuration;
    return true;
  }
}

class FakeHeadsetRepository implements HeadsetRepository {
  late HeadsetConfiguration _currentConfiguration;

  @override
  HeadsetConfigurationOptions readConfigurationOptions(Headset headset) {
    return HeadsetConfigurationOptions.fromJson(_options);
  }

  @override
  HeadsetConfiguration readConfiguration(Headset headset) {
    _currentConfiguration = headset.randomConfiguration;
    return _currentConfiguration;
  }

  @override
  bool writeConfiguration(
    Headset headset,
    HeadsetConfiguration configuration,
  ) {
    return true;
  }
}

const _options = {
  "settings": {
    "left_channel_volume": {
      "key": "left_channel_volume",
      "type": "range",
      "min_value": 0,
      "max_value": 100
    },
    "mic_mute": {
      "key": "mic_mute",
      "type": "checkbox",
      "min_value": 0,
      "max_value": 100
    },
    "mic_volume": {
      "key": "mic_volume",
      "type": "range",
      "min_value": 0,
      "max_value": 100
    },
    "mute": {"key": "mute", "type": "checkbox", "min_value": 0, "max_value": 1},
    "right_channel_volume": {
      "key": "right_channel_volume",
      "type": "range",
      "min_value": 0,
      "max_value": 100
    },
    "volume": {
      "key": "volume",
      "type": "range",
      "min_value": 0,
      "max_value": 100
    }
  }
};
