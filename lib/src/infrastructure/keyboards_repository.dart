import 'dart:convert';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client_consumer.dart';
import 'package:friendly_fire_peripherals/src/domain/core/types.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard_configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboards_repository.dart';

class LocalKeyboardsRepository extends DynamicLibraryClientConsumer
    implements KeyboardsRepository {
  LocalKeyboardsRepository(super.client);

  final Map<String, KeyboardConfiguration> _currentConfigurations = {};

  @override
  KeyboardConfigurationOptions readConfigurationOptions(Keyboard keyboard) {
    final rgbResponse = client.keyboardRGB(keyboard.id, 'config');
    final prResponse = client.keyboardPR(keyboard.id, 'config');
    final tdResponse = client.keyboardTD(keyboard.id, 'config');
    final dzResponse = client.keyboardDZ(keyboard.id, 'config');

    return KeyboardConfigurationOptions.fromJson({
      'rgb': json.decode(rgbResponse.dMessage),
      'pr': json.decode(prResponse.dMessage),
      'travel_distance': json.decode(tdResponse.dMessage),
      'dz': json.decode(dzResponse.dMessage),
    });
  }

  @override
  KeyboardConfiguration readConfiguration(Keyboard keyboard) {
    final rgbData = client.keyboardRGB(keyboard.id, 'get');
    final prData = client.keyboardPR(keyboard.id, 'get');
    final tdData = client.keyboardTD(keyboard.id, 'get');
    final dzData = client.keyboardDZ(keyboard.id, 'get');

    late KeyboardConfiguration configuration;
    try {
      dynamic decode(Response response) => json.decode(response.dMessage);
      configuration = KeyboardConfiguration.fromJson({
        'rgb': decode(rgbData),
        'pr': decode(prData),
        'travel_distance': decode(tdData),
        'dz': decode(dzData),
      });
    } catch (_) {
      configuration = keyboard.randomConfiguration;
    }
    _currentConfigurations[keyboard.id] = configuration.copyWith();
    return configuration;
  }

  @override
  bool writeConfiguration(
    Keyboard keyboard,
    KeyboardConfiguration configuration,
  ) {
    final currentConfiguration = _currentConfigurations[keyboard.id];

    if (currentConfiguration?.rgb != configuration.rgb) {
      final rgbResponse = client.keyboardRGB(
        keyboard.id,
        'set',
        configuration.rgb.mode,
        configuration.rgb.stringifiedColors,
        configuration.rgb.speed,
        configuration.rgb.brightness,
        configuration.rgb.shining,
      );
      if (!rgbResponse.success) {
        // return false;
      }
    }
    Future.delayed(Duration(milliseconds: 150), () {
      if (currentConfiguration?.pr != configuration.pr) {
        final prResponse = client.keyboardPR(
          keyboard.id,
          'set',
          // '--polling-rate=1000',
          configuration.pr.toString(),
        );
        if (!prResponse.success) {
          print('polling rate ${configuration.pr}::${prResponse.dMessage}');
          // return false;
        }
      }
    })
        .then(
          (value) => Future.delayed(Duration(milliseconds: 300), () {
            if (currentConfiguration?.td != configuration.td) {
              final tdResponse = client.keyboardTD(
                keyboard.id,
                'set',
                '--travel-distance=${configuration.td?.toStringAsPrecision(3)}',
              );
              if (!tdResponse.success) {
                print(
                    'travel distance ${configuration.td?.toString()}::${tdResponse.dMessage}');
                // return false;
              }
            }
          }),
        )
        .then(
          (value) => Future.delayed(Duration(milliseconds: 600), () {
            if (currentConfiguration?.dz != configuration.dz) {
              final dzResponse = client.keyboardDZ(
                keyboard.id,
                'set',
                '--top=${(configuration.dz?.top ?? 0.1).toStringAsPrecision(3)}',
                '--bottom=${(configuration.dz?.bottom ?? 0.1).toStringAsPrecision(3)}',
              );
              if (!dzResponse.success) {
                print(
                    'deadzone ${configuration.dz?.toJson().toString()}::${dzResponse.dMessage}');
                // return false;
              }
            }
          }),
        );

    _currentConfigurations[keyboard.id] = configuration.copyWith();
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
