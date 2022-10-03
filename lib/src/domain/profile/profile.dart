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
      peripheralsList.indexWhere((p) => p.name == peripheral.name) != -1;

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
  operator ==(Object? other) => other is Profile && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
