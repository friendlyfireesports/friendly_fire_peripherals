import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/headset/headset_repository.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/keyboard/keyboards_repository.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/mouse/mouse_repository.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/configuration.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/peripherals_repository.dart';
import 'package:friendly_fire_peripherals/src/domain/peripherals/universal_repository.dart';
import 'package:friendly_fire_peripherals/src/domain/profile/profiles_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/dynamic_library_client.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/headset_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/keyboards_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/mouse_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/profiles_repository.dart';
import 'package:friendly_fire_peripherals/src/infrastructure/universal_repository.dart';

class PeripheralsManager {
  PeripheralsManager({required String dynamicLibraryPath}) {
    final client = LocalDynamicLibraryClient(dynamicLibraryPath);
    _peripheralsRepository = LocalUniversalRepository(client);
    _keyboardsRepository = LocalKeyboardsRepository(client);
    _mouseRepository = LocalMouseRepository(client);
    _headsetRepository = LocalHeadsetRepository(client);
    _profilesRepository = LocalProfilesRepository(client);
  }

  PeripheralsManager.fake()
      : _peripheralsRepository = FakeUniversalRepository(),
        _keyboardsRepository = FakeKeyboardsRepository(),
        _mouseRepository = FakeMouseRepository(),
        _headsetRepository = FakeHeadsetRepository(),
        _profilesRepository = FakeProfilesRepository();

  late final UniversalRepository _peripheralsRepository;
  late final KeyboardsRepository _keyboardsRepository;
  late final MouseRepository _mouseRepository;
  late final HeadsetRepository _headsetRepository;
  late final ProfilesRepository _profilesRepository;

  List<Peripheral>? _peripherals;

  List<Peripheral> getPeripherals({
    PeripheralType type = PeripheralType.all,
    bool connected = true,
    bool withConfiguration = true,
  }) {
    _peripherals = _peripheralsRepository.getPeripherals(type, connected);
    if (withConfiguration) {
      for (final peripheral in _peripherals!) {
        _getConfigurationOptions(peripheral);
        _getConfiguration(peripheral);
      }
    }
    return _peripherals!;
  }

  Future<bool> update(
    Peripheral peripheral, [
    Configuration? configuration,
  ]) {
    final inputConfiguration = configuration ?? peripheral.configuration;
    final rectifiedConfiguration =
        inputConfiguration.rectified(peripheral.configurationOptions);

    peripheral.setConfiguration(rectifiedConfiguration);

    final repository = _chooseRepository(peripheral);
    return Future.delayed(
      const Duration(milliseconds: 100),
      () => repository.writeConfiguration(peripheral, rectifiedConfiguration),
    );
  }

  Future<List<Profile>> getProfiles() async {
    return _profilesRepository.get();
  }

  Future<bool> saveProfile(Profile profile) async {
    return _profilesRepository.save(profile);
  }

  bool applyProfile(Profile profile) {
    for (final peripheral in _peripherals ?? profile.peripherals.keys) {
      final keys = profile.peripherals.keys.toList();
      final index = keys.indexWhere((p) => p == peripheral);
      if (index != -1) {
        final key = keys[index];
        update(peripheral, profile.peripherals[key]);
      }
    }
    return true;
  }

  Future<bool> deleteProfile(Profile profile) async {
    return _profilesRepository.delete(profile);
  }

  Future<bool> deleteAllProfiles() async {
    return _profilesRepository.deleteAll();
  }

  Configuration _getConfiguration(Peripheral peripheral, {bool force = false}) {
    if (peripheral.isSet && !force) {
      return peripheral.configuration;
    }
    final repository = _chooseRepository(peripheral);
    final configuration = repository.readConfiguration(peripheral);
    peripheral.setConfiguration(configuration);
    return peripheral.configuration;
  }

  ConfigurationOptions _getConfigurationOptions(Peripheral peripheral) {
    if (peripheral.isSet) {
      return peripheral.configurationOptions;
    }
    final repository = _chooseRepository(peripheral);
    final options = repository.readConfigurationOptions(peripheral);
    peripheral.setConfiguration(null, options);
    return peripheral.configurationOptions;
  }

  PeripheralsRepository _chooseRepository(Peripheral peripheral) {
    if (peripheral is Keyboard) {
      return _keyboardsRepository;
    } else if (peripheral is Mouse) {
      return _mouseRepository;
    } else if (peripheral is Headset) {
      return _headsetRepository;
    }
    throw Exception('Not supported');
  }
}
