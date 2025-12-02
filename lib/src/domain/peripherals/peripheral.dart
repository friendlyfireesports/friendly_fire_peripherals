import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/headset_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/keyboards_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/mouse_repository.dart';

import 'keyboard/keyboard.dart';
import 'mouse/mouse.dart';
import 'configuration.dart';

enum PeripheralType { mouse, keyboard, headset, unknown, all }

abstract class Peripheral {
  Peripheral({
    required this.id,
    required this.type,
    required this.name,
    required this.capabilities,
    this.image,
  });

  final String id;
  final PeripheralType type;
  final String name;
  final Map<String, bool> capabilities;
  final String? image;

  late Configuration config;
  Configuration get configuration => config;
  late ConfigurationOptions configOptions;
  ConfigurationOptions get configurationOptions => configOptions;

  bool _configurationSet = false;
  bool _configurationOptionsSet = false;
  bool get isSet => _configurationSet && _configurationOptionsSet;

  Configuration get randomConfiguration;

  factory Peripheral.fromStrings({
    required String id,
    required String type,
    required String name,
    required Map<String, bool> capabilities,
    bool withFakeConfiguration = false,
  }) {
    switch (type) {
      case 'keyboard':
        final keyboard = Keyboard(
            id: id,
            name: id == '2ea8:2124' ? 'Hammerwolf' : name,
            capabilities: capabilities);
        if (withFakeConfiguration) {
          final repository = FakeKeyboardsRepository();
          keyboard.configOptions =
              repository.readConfigurationOptions(keyboard);
          keyboard.config = repository.readConfiguration(keyboard);
        }
        return keyboard;
      case 'mouse':
        final mouse = Mouse(id: id, name: name, capabilities: capabilities);
        if (withFakeConfiguration) {
          final repository = FakeMouseRepository();
          mouse.configOptions = repository.readConfigurationOptions(mouse);
          mouse.config = repository.readConfiguration(mouse);
        }
        return mouse;
      case 'headset':
        final headset = Headset(id: id, name: name, capabilities: capabilities);
        if (withFakeConfiguration) {
          final repository = FakeHeadsetRepository();
          headset.configOptions = repository.readConfigurationOptions(headset);
          headset.config = repository.readConfiguration(headset);
        }
        return headset;
      default:
        throw Exception('Not supported');
    }
  }

  factory Peripheral.fake() => Peripheral.fromStrings(
        id: faker.lorem.word(),
        name: faker.lorem
            .words(faker.randomGenerator.integer(5, min: 2))
            .join(' '),
        type: faker.randomGenerator.integer(3) == 0
            ? 'mouse'
            : faker.randomGenerator.boolean()
                ? 'keyboard'
                : 'headset',
        capabilities: {'supports_rgb': true},
        withFakeConfiguration: true,
      );

  void setConfiguration(
    Configuration? configuration, [
    ConfigurationOptions? configurationOptions,
  ]) {
    if (configuration != null) {
      config = configuration;
      _configurationSet = true;
    }
    if (configurationOptions != null) {
      configOptions = configurationOptions;
      _configurationOptionsSet = true;
    }
  }

  @override
  String toString() => json.encode(
        {
          'id': id,
          'type': type.name,
          'name': name,
          'capabilities': capabilities,
        },
      );

  @override
  bool operator ==(Object? other) =>
      other is Peripheral && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
