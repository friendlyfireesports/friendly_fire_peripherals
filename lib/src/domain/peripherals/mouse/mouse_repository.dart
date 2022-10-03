import '../peripherals_repository.dart';
import 'mouse.dart';
import 'mouse_configuration.dart';

abstract class MouseRepository extends PeripheralsRepository<Mouse,
    MouseConfiguration, MouseConfigurationOptions> {}
