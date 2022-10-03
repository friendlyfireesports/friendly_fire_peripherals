import 'package:friendly_fire_peripherals/src/domain/profile/profile.dart';

abstract class ProfilesRepository {
  Future<List<Profile>> get();
  Future<bool> save(Profile profile);
  Future<bool> delete(Profile profile);
  Future<bool> deleteAll();
}
