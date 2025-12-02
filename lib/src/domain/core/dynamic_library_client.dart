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
    bool? shining,
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

  /// Keyboard polling rate
  Response keyboardPR(
    String id,
    String action, [
    String? pr,
  ]);

  /// Keyboard travel distance
  Response keyboardTD(
    String id,
    String action, [
    String? dpi,
  ]);

  /// Keyboard deadzones
  Response keyboardDZ(
    String id,
    String action, [
    String? top,
    String? bottom,
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
