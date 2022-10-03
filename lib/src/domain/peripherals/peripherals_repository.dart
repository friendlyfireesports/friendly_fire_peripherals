import 'peripheral.dart';
import 'configuration.dart';

abstract class PeripheralsRepository<P extends Peripheral,
    C extends Configuration, O extends ConfigurationOptions> {
  O readConfigurationOptions(P peripheral);

  C readConfiguration(P peripheral);
  bool writeConfiguration(P peripheral, C configuration);
}
