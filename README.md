
# Friendly Fire Peripherals

[![codecov](https://codecov.io/gh/friendlyfireesports/friendly_fire_peripherals/branch/master/graph/badge.svg?token=6D0IZH4M9H)](https://codecov.io/gh/friendlyfireesports/friendly_fire_peripherals)

A package for managing Friendly Fire peripherals (gear).

- Fully used by Gear Tuner app
- Partially used by Friendly Fire app
- Can be used publicly to create custom applications that interact with Friendly Fire peripherals

## Usage

In your `pubspec.yaml`:

```yaml
dependencies:
  friendly_fire_peripherals:
    git:
      url: https://github.com/friendlyfireesports/friendly_fire_peripherals.git
```

Then in your Dart code:

```dart
import 'package:friendly_fire_peripherals/friendly_fire_peripherals.dart';

final libPath = 'path/to/periph-cli-dylib';
final manager = PeripheralsManager(dynamicLibraryPath: libPath);

final peripherals = manager.getPeripherals();
print(peripherals);
```
