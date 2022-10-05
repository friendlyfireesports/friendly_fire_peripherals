import 'dart:convert';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client_consumer.dart';
import 'package:friendly_fire_peripherals/src/domain/profile/profile.dart';
import 'package:friendly_fire_peripherals/src/domain/profile/profiles_repository.dart';

class LocalProfilesRepository extends DynamicLibraryClientConsumer
    implements ProfilesRepository {
  LocalProfilesRepository(super.client);

  @override
  Future<List<Profile>> get() async {
    final profileResponse = client.profile('get');
    if (!profileResponse.success) {
      return [Profile.fromDefault()];
    }
    var profileJsonList = json.decode(profileResponse.dMessage);
    if (profileJsonList is! List) {
      return [Profile.fromDefault()];
    }
    try {
      final profiles = profileJsonList
          .map((profileJson) => Profile.fromJson(profileJson))
          .toList();
      if (profiles.isEmpty) {
        return [Profile.fromDefault()];
      } else {
        final hasLocked = profiles.any((profile) => profile.isLocked);
        if (hasLocked) {
          return profiles;
        }
        return [Profile.fromDefault(), ...profiles];
      }
    } catch (e) {
      return [Profile.fromDefault()];
    }
  }

  @override
  Future<bool> save(Profile profile) async {
    final profileResponse = client.profile(
      'save',
      profile.id,
      profile.toString(),
    );
    return profileResponse.success;
  }

  @override
  Future<bool> delete(Profile profile) async {
    final profileResponse = client.profile('delete', profile.id);
    return profileResponse.success;
  }

  @override
  Future<bool> deleteAll() async {
    final profileResponse = client.profile('deleteall');
    return profileResponse.success;
  }
}

class RemoteProfilesRepository implements ProfilesRepository {
  @override
  Future<List<Profile>> get() {
    // TODO: implement fetchProfiles
    throw UnimplementedError();
  }

  @override
  Future<bool> save(Profile profile) {
    // TODO: implement saveProfile
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(Profile profile) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteAll() {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }
}

class FakeProfilesRepository implements ProfilesRepository {
  List<Profile>? _profiles;

  @override
  Future<List<Profile>> get() async {
    _profiles ??= List.generate(
      DateTime.now().millisecond % 8 + 2,
      (_) => Profile.fake,
    );
    return _profiles!;
  }

  @override
  Future<bool> save(Profile profile) async {
    if (_profiles == null) {
      return false;
    }
    final index = _profiles!.indexWhere((p) => p == profile);
    if (index != -1) {
      _profiles![index] = profile;
    } else {
      _profiles?.add(profile);
    }
    return true;
  }

  @override
  Future<bool> delete(Profile profile) async {
    _profiles!.removeWhere((p) => p == profile);
    return true;
  }

  @override
  Future<bool> deleteAll() async {
    _profiles = null;
    return true;
  }
}
