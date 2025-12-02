import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';

void main() {
  final libPath = '/home/sandro/Gamebay/gear_tuner/periph_lib/periph.so';
  final manager = PeripheralsManager(dynamicLibraryPath: libPath);

  final devices = manager.getPeripherals();
  print('Devices: $devices\n');

  final keyboards = manager.getPeripherals(type: PeripheralType.keyboard);
  print('Keyboards: $keyboards\n');
  for (final Keyboard keyboard in keyboards.cast<Keyboard>()) {
    print('--------------------+[ ${keyboard.name} ]+--------------------');
    print('Current Configuration: ${keyboard.configuration}\n');
    // print('Configuration Options: ${keyboard.configurationOptions}\n');

    final randomRGB = keyboard.randomConfiguration.rgb;
    print('========================================');
    print('Random RGB: $randomRGB\n');
    print('========================================');

    final configuration = KeyboardConfiguration(rgb: randomRGB);
    final success = await manager.update(keyboard, configuration);
    print('Success: $success');
    final latestKeyboardState = manager
        .getPeripherals(type: PeripheralType.keyboard)
        .firstWhere((k) => k.name == keyboard.name);
    print(
        '>>------------------+[ LAST BOSS MODE ${keyboard.name} ]+------------------<<');
    print('Current Configuration: ${latestKeyboardState.configuration}');
  }
}
