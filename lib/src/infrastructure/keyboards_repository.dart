import 'dart:convert';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client_consumer.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard_configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboards_repository.dart';

class LocalKeyboardsRepository extends DynamicLibraryClientConsumer
    implements KeyboardsRepository {
  LocalKeyboardsRepository(super.client);

  @override
  KeyboardConfigurationOptions readConfigurationOptions(Keyboard keyboard) {
    final response = client.keyboardRGB(
      keyboard.id,
      'config',
    );
    final messageJson = json.decode(response.dMessage);
    return KeyboardConfigurationOptions.fromJson({'rgb': messageJson});
  }

  @override
  KeyboardConfiguration readConfiguration(Keyboard keyboard) {
    final response = client.keyboardRGB(
      keyboard.id,
      'get',
    );
    late KeyboardConfiguration configuration;
    try {
      final messageJson = json.decode(response.dMessage);
      configuration = KeyboardConfiguration.fromJson({'rgb': messageJson});
    } catch (_) {
      configuration = keyboard.randomConfiguration;
    }
    return configuration;
  }

  @override
  bool writeConfiguration(
    Keyboard keyboard,
    KeyboardConfiguration configuration,
  ) {
    final response = client.keyboardRGB(
      keyboard.id,
      'set',
      configuration.rgb.mode,
      configuration.rgb.stringifiedColors,
      configuration.rgb.speed,
      configuration.rgb.brightness,
    );
    if (!response.success) {
      // return false;
    }
    return true;
  }
}

class FakeKeyboardsRepository implements KeyboardsRepository {
  final Map<String, KeyboardConfiguration> _currentConfigurations = {};

  @override
  KeyboardConfigurationOptions readConfigurationOptions(Keyboard keyboard) {
    return KeyboardConfigurationOptions.fromJson(
      {'rgb': _rgbOptions},
    );
  }

  @override
  KeyboardConfiguration readConfiguration(Keyboard keyboard) {
    _currentConfigurations[keyboard.name] = keyboard.randomConfiguration;
    return _currentConfigurations[keyboard.name]!;
  }

  @override
  bool writeConfiguration(
    Keyboard keyboard,
    KeyboardConfiguration configuration,
  ) {
    _currentConfigurations[keyboard.name] = configuration;
    keyboard.setConfiguration(configuration);
    return true;
  }
}

const Map<String, dynamic> _rgbOptions = {
  "predefined_colors": [
    "ff0000",
    "00ff00",
    "0000ff",
    "ffff00",
    "ff00ff",
    "00ffff",
    "ffffff"
  ],
  "modes": {
    "breath": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "center_surfing": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "disabled": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [],
      "brightness": []
    },
    "game_mode_1": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5]
    },
    "game_mode_2": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5]
    },
    "game_mode_3": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5]
    },
    "game_mode_4": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5]
    },
    "game_mode_5": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5]
    },
    "glowing_fish": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "heart": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "light_by_press": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "ripple": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "rotate_marquee": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "snake_marquee_middle": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "solid": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [],
      "brightness": [1, 2, 3, 4, 5]
    },
    "spectrum": {
      "color_spots": 0,
      "use_predefined_colors": false,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "surfing_right": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    },
    "wave_spectrum": {
      "color_spots": 1,
      "use_predefined_colors": true,
      "speed": [1, 2, 3],
      "brightness": [1, 2, 3, 4, 5]
    }
  }
};
