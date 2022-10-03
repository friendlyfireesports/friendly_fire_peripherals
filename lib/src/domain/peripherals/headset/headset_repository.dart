import '../peripherals_repository.dart';
import 'headset.dart';
import 'headset_configuration.dart';

abstract class HeadsetRepository extends PeripheralsRepository<Headset,
    HeadsetConfiguration, HeadsetConfigurationOptions> {}
