import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';
import 'package:friendly_fire_peripherals/src/domain/core/json_serializable.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';

class Profile with JsonSerializable {
  Profile({
    required this.id,
    required this.name,
    required this.priority,
    this.isLocked = false,
    this.peripherals = const {},
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    final peripherals = <Peripheral, Configuration>{};
    if (json['peripherals'] is List) {
      for (final p in json['peripherals']) {
        final peripheral = Peripheral.fromStrings(
          id: p['id'],
          type: p['type'],
          name: p['name'],
        );
        peripherals[peripheral] = Configuration.fromJson(
          peripheral.type,
          p['configuration'],
        );
      }
    }
    return Profile(
      id: json['id'] ?? -1, // TODO
      name: json['name'],
      priority: json['priority'] ?? 999,
      isLocked: json['is_locked'] ?? false,
      peripherals: peripherals,
    );
  }

  factory Profile.fromPeripherals({
    required int id,
    required String name,
    required int priority,
    bool? isLocked,
    required List<Peripheral> peripherals,
  }) {
    final peripheralsMap = <Peripheral, Configuration>{};
    for (final peripheral in peripherals) {
      peripheralsMap[peripheral] = peripheral.configuration;
    }
    return Profile(
      id: id,
      name: name,
      priority: priority,
      isLocked: isLocked ?? false,
      peripherals: peripheralsMap,
    );
  }

  factory Profile.fromDefault() => Profile.fromJson(defaultJson);

  final int id;
  final String name;
  final int priority;
  final bool isLocked;
  final Map<Peripheral, Configuration> peripherals;

  List<Peripheral> get peripheralsList => peripherals
      .map(
        (peripheral, configuration) => MapEntry(
          peripheral.name,
          peripheral..setConfiguration(configuration),
        ),
      )
      .values
      .toList();

  static Profile get fake {
    final now = DateTime.now();
    return Profile(
      id: now.millisecond + now.microsecond,
      name: 'Profile-${now.microsecond}',
      priority: now.second,
      peripherals: {
        for (final peripheral in List.generate(
          DateTime.now().millisecond % 5 + 1,
          (_) => Peripheral.fake(),
        ))
          peripheral: peripheral.randomConfiguration
      },
    );
  }

  bool supports(Peripheral peripheral) =>
      peripheralsList.indexWhere((p) => p == peripheral) != -1;

  Profile rectified(List<Peripheral> loadedPeripherals) {
    for (final loadedPeripheral in loadedPeripherals) {
      final peripheralKeyIndex = peripherals.keys
          .toList()
          .indexWhere((k) => k.id == loadedPeripheral.id);
      if (peripheralKeyIndex == -1) {
        continue;
      }
      final peripheralKey = peripherals.keys.toList()[peripheralKeyIndex];
      final configuration = peripherals[peripheralKey]!;
      peripherals[peripheralKey] =
          configuration.rectified(loadedPeripheral.configurationOptions);
    }
    return this;
  }

  @override
  Profile fromJson(Map<String, dynamic> json) => Profile.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'priority': priority,
        'is_locked': isLocked,
        'peripherals': peripherals
            .map(
              (peripheral, configuration) => MapEntry(
                peripheral.name,
                {
                  'id': peripheral.id,
                  'name': peripheral.name,
                  'type': peripheral.type.name,
                  'configuration': configuration.toJson(),
                },
              ),
            )
            .values
            .toList(),
      };

  @override
  operator ==(Object? other) => other is Profile && other.id == id;

  @override
  int get hashCode => name.hashCode;
}

const defaultJson = <String, dynamic>{
  "id": 0,
  "name": "Default",
  "priority": 0,
  "is_locked": true,
  "peripherals": [
    {
      "id": "258a:4401",
      "name": "No-Scope Master GEN 1",
      "type": "mouse",
      "configuration": {
        "rgb": {
          "mode": "colorful_streaming",
          "colors": [],
          "speed": 3,
          "brightness": null
        },
        "pr": 1000,
        "dpi":
            "ff0000:400,00ff00:500,0000ff:600,00ffff:800,ffff00:1200,ff00ff:2400"
      }
    },
    {
      "id": "258a:4402",
      "name": "No-Scope Master GEN 2",
      "type": "mouse",
      "configuration": {
        "rgb": {
          "mode": "colorful_streaming",
          "colors": [],
          "speed": 3,
          "brightness": null
        },
        "pr": 1000,
        "dpi":
            "ff0000:400,00ff00:500,0000ff:600,00ffff:800,ffff00:1200,ff00ff:2400"
      }
    },
    {
      "id": "2ea8:2123",
      "name": "Penta Keys GEN 2",
      "type": "keyboard",
      "configuration": {
        "rgb": {
          "mode": "center_surfing",
          "colors": [],
          "speed": 3,
          "brightness": 5
        }
      }
    },
    {
      "id": "2ea8:2123",
      "name": "eSport Arena Penta Keys",
      "type": "keyboard",
      "configuration": {
        "rgb": {
          "mode": "center_surfing",
          "colors": [],
          "speed": 3,
          "brightness": 5
        }
      }
    },
    {
      "id": "0d8c:0024",
      "name": "Headshot Melody GEN 2",
      "type": "headset",
      "configuration": {
        "speaker": {
          "mute": 0,
          "volume": 100,
          "left_channel_volume": 100,
          "right_channel_volume": 100
        },
        "mic": {"mute": 0, "volume": 30}
      }
    },
    {
      "id": "0c76:161f",
      "name": "Whispering Wings GEN 1",
      "type": "headset",
      "configuration": {
        "speaker": {
          "mute": 0,
          "volume": 100,
          "left_channel_volume": 100,
          "right_channel_volume": 100
        },
        "mic": {"mute": 0, "volume": 50}
      }
    }
  ]
};
