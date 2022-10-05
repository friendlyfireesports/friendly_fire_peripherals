import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/dynamic_library_client.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/profiles_repository.dart';
import 'package:test/test.dart';

void main() {
  // group('LocalProfilesRepository', () {
  //   final libPath = '/home/sandro/Gamebay/gear_tuner/periph_lib/periph.so';
  //   final client = LocalDynamicLibraryClient(libPath);

  //   final repository = LocalProfilesRepository(client);
  //   final profile = Profile.fake;

  //   test('save', () async {
  //     final success = await repository.save(profile);
  //     expect(success, isTrue);
  //   });

  //   test('get', () async {
  //     final profiles = await repository.get();
  //     print('profile: $profiles');
  //     expect(profiles.any((p) => p == profile), isTrue);
  //   });
  // });
}
