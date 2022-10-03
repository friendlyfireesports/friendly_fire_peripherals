import 'peripheral.dart';

abstract class UniversalRepository {
  List<Peripheral> getPeripherals(PeripheralType type, bool connected);

  void getProfile();

  bool setProfile();
}
