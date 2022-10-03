import '../peripherals_repository.dart';
import 'keyboard.dart';
import 'keyboard_configuration.dart';

abstract class KeyboardsRepository extends PeripheralsRepository<Keyboard,
    KeyboardConfiguration, KeyboardConfigurationOptions> {}
