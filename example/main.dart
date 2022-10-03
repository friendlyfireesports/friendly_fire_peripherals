import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';

void main() {
  final libPath = '/home/sandro/Gamebay/gear_tuner/periph_lib/periph.so';
  final manager = PeripheralsManager(dynamicLibraryPath: libPath);

  final devices = manager.getPeripherals();
  print('Devices: $devices\n');

  final keyboards = manager.getPeripherals(type: PeripheralType.keyboard);
  print('Keyboards: $keyboards\n');

  final keyboard = keyboards.first as Keyboard;
  print('Current Configuration: ${keyboard.configuration}\n');
  print('Configuration Options: ${keyboard.configurationOptions}\n');

  final randomRGB = keyboard.randomConfiguration.rgb;
  print('Random RGB: $randomRGB\n');

  final configuration = KeyboardConfiguration(rgb: randomRGB);
  final success = manager.update(keyboard, configuration);
  print('Success: $success');
}
