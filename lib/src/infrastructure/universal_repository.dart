import 'dart:convert';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client_consumer.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/peripheral.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/universal_repository.dart';

class LocalUniversalRepository extends DynamicLibraryClientConsumer
    implements UniversalRepository {
  LocalUniversalRepository(super.client);

  @override
  List<Peripheral> getPeripherals(PeripheralType type, bool connected) {
    final response = client.list(type.name, (!connected).toString());
    final message = response.dMessage;
    final devicesJson = json.decode(message) as Map<String, dynamic>;

    final devices = <Peripheral>[];
    devicesJson.forEach((key, value) {
      if (type == PeripheralType.all || type.name == key) {
        final list = value as List;
        for (var json in list) {
          devices.add(
            Peripheral.fromStrings(
              id: json['vid_pid'],
              type: key,
              name: json['name'],
            ),
          );
        }
      }
    });

    return devices;
  }

  @override
  void getProfile() {}

  @override
  bool setProfile() => true;
}

class FakeUniversalRepository implements UniversalRepository {
  @override
  List<Peripheral> getPeripherals(PeripheralType type, bool connected) {
    return List.generate(5, (_) => Peripheral.fake());
  }

  @override
  void getProfile() {}

  @override
  bool setProfile() => true;
}
