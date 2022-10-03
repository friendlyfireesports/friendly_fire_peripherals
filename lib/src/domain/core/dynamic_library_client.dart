import 'package:friendly_fire_peripherals/src/domain/core/types.dart';

abstract class DynamicLibraryClient {
  DynamicLibraryClient() {
    load();
  }

  void load();

  Response list(String filter, String supported);

  Response keyboardRGB(
    String id,
    String action, [
    String? mode,
    String? color,
    int? speed,
    int? brightness,
  ]);

  Response mouseRGB(
    String id,
    String action, [
    String? mode,
    String? color,
    int? speed,
    int? brightness,
  ]);

  Response mousePR(
    String id,
    String action, [
    String? pr,
  ]);

  Response mouseDPI(
    String id,
    String action, [
    String? dpi,
  ]);

  Response profile(
    String action, [
    int? id,
    String? json,
  ]);

  Response headset(
    String action, [
    String? key,
    int? value,
  ]);
}
