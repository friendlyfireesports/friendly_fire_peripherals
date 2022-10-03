import 'package:friendly_fire_peripherals/src/domain/peripherals/peripheral.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/universal_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/dynamic_library_client.dart';
import 'package:test/test.dart';

void main() {
  group('LocalDevicesRepository', () {
    final libPath = '/home/sandro/Gamebay/gear_tuner/periph_lib/periph.so';
    final client = LocalDynamicLibraryClient(libPath);
    final repository = LocalUniversalRepository(client);

    test('getDevices', () {
      final devices = repository.getPeripherals(PeripheralType.all, true);
      expect(devices, isNotEmpty);
    });

    test('getProfile', () {
      repository.getProfile();
      expect(true, isTrue);
    });

    test('setProfile', () {
      final success = repository.setProfile();
      expect(success, isTrue);
    });
  });
}
