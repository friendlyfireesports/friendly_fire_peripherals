import 'package:friendly_fire_peripherals/src/domain/core/json_serializable.dart';

class Deadzone with JsonSerializable {
  const Deadzone({this.top, this.bottom});
  final double? top;
  final double? bottom;

  factory Deadzone.fromJson(Map<String, dynamic> json) {
    final dzData = json.containsKey('dz') ? json['dz'] : json;
    return Deadzone(
      top: dzData['topValue'] != null
          ? (dzData['topValue'] as num).toDouble()
          : 0.1,
      bottom: dzData['bottomValue'] != null
          ? (dzData['bottomValue'] as num).toDouble()
          : 0.3,
    );
  }

  Deadzone copyWith({double? top, double? bottom}) =>
      Deadzone(top: top ?? this.top, bottom: bottom ?? this.bottom);

  @override
  Deadzone fromJson(Map<String, dynamic> json) => Deadzone.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'topValue': top ?? 0.1,
      'bottomValue': bottom ?? 0.3,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Deadzone &&
          runtimeType == other.runtimeType &&
          top == other.top &&
          bottom == other.bottom;

  @override
  int get hashCode => top.hashCode ^ bottom.hashCode;

  Deadzone rectified() => copyWith(
        top: top?.clamp(0.1, 1),
        bottom: bottom?.clamp(0.3, 1),
      );
}
