import 'dynamic_library_client.dart';

abstract class DynamicLibraryClientConsumer {
  DynamicLibraryClientConsumer(this._client);

  final DynamicLibraryClient _client;
  DynamicLibraryClient get client => _client;
}
