import 'dart:convert';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client_consumer.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/mouse/mouse.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/mouse/mouse_configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/mouse/mouse_repository.dart';

class LocalMouseRepository extends DynamicLibraryClientConsumer
    implements MouseRepository {
  LocalMouseRepository(super.client);

  final Map<String, MouseConfiguration> _currentConfigurations = {};

  @override
  MouseConfigurationOptions readConfigurationOptions(Mouse mouse) {
    final rgbResponse = client.mouseRGB(mouse.id, 'config');
    final prResponse = client.mousePR(mouse.id, 'config');
    final dpiResponse = client.mouseDPI(mouse.id, 'config');
    return MouseConfigurationOptions.fromJson({
      'rgb': json.decode(rgbResponse.dMessage),
      'pr': json.decode(prResponse.dMessage),
      'dpi': json.decode(dpiResponse.dMessage),
    });
  }

  @override
  MouseConfiguration readConfiguration(Mouse mouse) {
    final rgbResponse = client.mouseRGB(mouse.id, 'get');
    final prResponse = client.mousePR(mouse.id, 'get');
    final dpiResponse = client.mouseDPI(mouse.id, 'get');
    late MouseConfiguration configuration;
    if (!rgbResponse.success || !prResponse.success || !dpiResponse.success) {
      configuration = mouse.randomConfiguration;
    } else {
      configuration = MouseConfiguration.fromJson({
        'rgb': json.decode(rgbResponse.dMessage),
        'pr': int.tryParse(prResponse.dMessage) ?? 125,
        'dpi': json.decode(dpiResponse.dMessage),
      });
    }
    _currentConfigurations[mouse.id] = configuration.copyWith();
    return configuration;
  }

  @override
  bool writeConfiguration(
    Mouse mouse,
    MouseConfiguration configuration,
  ) {
    final currentConfiguration = _currentConfigurations[mouse.id];

    if (currentConfiguration?.rgb != configuration.rgb) {
      final rgbResponse = client.mouseRGB(
        mouse.id,
        'set',
        configuration.rgb.mode,
        configuration.rgb.stringifiedColors,
        configuration.rgb.speed,
        configuration.rgb.brightness,
      );
      if (!rgbResponse.success) {
        // return false;
      }
    }
    if (currentConfiguration?.pr != configuration.pr) {
      final prResponse = client.mousePR(
        mouse.id,
        'set',
        configuration.pr.toString(),
      );
      if (!prResponse.success) {
        // return false;
      }
    }
    if (currentConfiguration?.dpi != configuration.dpi) {
      final dpiResponse = client.mouseDPI(
        mouse.id,
        'set',
        configuration.dpi.toString(),
      );
      if (!dpiResponse.success) {
        // return false;
      }
    }
    _currentConfigurations[mouse.id] = configuration.copyWith();
    return true;
  }
}

class FakeMouseRepository implements MouseRepository {
  final Map<String, MouseConfiguration> _currentConfigurations = {};

  @override
  MouseConfigurationOptions readConfigurationOptions(Mouse mouse) {
    return MouseConfigurationOptions.fromJson({
      'rgb': _rgbOptions,
      'pr': _pollingRateOptions,
      'dpi': _dpiOptions,
    });
  }

  @override
  MouseConfiguration readConfiguration(Mouse mouse) {
    _currentConfigurations[mouse.id] = mouse.randomConfiguration;
    return _currentConfigurations[mouse.id]!;
  }

  @override
  bool writeConfiguration(
    Mouse mouse,
    MouseConfiguration configuration,
  ) {
    if (_currentConfigurations[mouse.id]?.rgb.mode != configuration.rgb.mode) {
      final mode = mouse.configurationOptions.rgb.modes.firstWhere(
        (mode) => mode.name == configuration.rgb.mode,
      );
      final mouseRGB = MouseRGB(
        mode: mode.name,
        colors: List.generate(mode.colorSpots, (_) => 0xffff0000),
        speed: mode.speeds.isNotEmpty ? mode.speeds.first : null,
        brightness:
            mode.brightnesses.isNotEmpty ? mode.brightnesses.first : null,
      );
      _currentConfigurations[mouse.id] = configuration.copyWith(rgb: mouseRGB);
    } else {
      _currentConfigurations[mouse.id] = configuration;
    }
    mouse.setConfiguration(_currentConfigurations[mouse.id]);
    return true;
  }
}

const Map<String, dynamic> _rgbOptions = {
  "modes": {
    "breathing": {
      "color_spots": 6,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "colorful_steady": {"color_spots": 7, "speed": [], "brightness": []},
    "colorful_streaming": {
      "color_spots": 0,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "colorful_tail": {
      "color_spots": 0,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "flicker": {"color_spots": 2, "speed": [], "brightness": []},
    "neon": {
      "color_spots": 0,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "off": {"color_spots": 0, "speed": [], "brightness": []},
    "response": {
      "color_spots": 7,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "steady": {
      "color_spots": 1,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5, 6, 7, 8, 9]
    },
    "streaming": {
      "color_spots": 0,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "tail": {
      "color_spots": 0,
      "speed": [1, 2, 3],
      "brightness": []
    },
    "wave": {
      "color_spots": 0,
      "speed": [1, 2, 3],
      "brightness": []
    }
  }
};

const Map<String, dynamic> _dpiOptions = {
  "predefined_colors": [
    "ff0000",
    "00ff00",
    "0000ff",
    "00ffff",
    "ffff00",
    "ff00ff",
    "ffffff"
  ],
  "dpi_slots": 6,
  "min_value": 100,
  "max_value": 17000
};

const List<String> _pollingRateOptions = ["1000", "125", "250", "500"];
