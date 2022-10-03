import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboard_configuration.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/dynamic_library_client.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/keyboards_repository.dart';
import 'package:test/test.dart';

void main() {
  // group('LocalKeyboardsRepository', () {
  //   final libPath = '/home/sandro/Gamebay/gear_tuner/periph_lib/periph.so';
  //   final client = LocalDynamicLibraryClient(libPath);
  //   final repository = LocalKeyboardsRepository(client);

  //   final keyboard = Keyboard(id: '2ea8:2123', name: 'x');
  //   final options = repository.readConfigurationOptions(keyboard);
  //   final configuration = KeyboardConfiguration(
  //     rgb: options.rgb.random<KeyboardRGB>(),
  //   );

  //   test('getAll', () {
  //     final success = repository.writeConfiguration(keyboard, configuration);
  //     expect(success, isTrue);
  //   });
  // });
}
