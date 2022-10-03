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
      return [];
    }
    var profileJsonList = json.decode(profileResponse.dMessage);
    if (profileJsonList is! List) {
      return [];
    }
    return profileJsonList
        .map((profileJson) => Profile.fromJson(profileJson))
        .toList();
  }

  @override
  Future<bool> save(Profile profile) async {
    final profileResponse = client.profile(
      'save',
      profile.id,
      profile.toString(),
    );
    print(profileResponse.dMessage);
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
    final index = _profiles!.indexWhere((p) => p.name == profile.name);
    if (index != -1) {
      _profiles![index] = profile;
    } else {
      _profiles?.add(profile);
    }
    return true;
  }

  @override
  Future<bool> delete(Profile profile) async {
    _profiles!.removeWhere((p) => p.name == profile.name);
    return true;
  }

  @override
  Future<bool> deleteAll() async {
    _profiles = null;
    return true;
  }
}