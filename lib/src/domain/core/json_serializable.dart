import 'dart:convert';

mixin JsonSerializable<T> {
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();

  @override
  String toString() => json.encode(toJson());
}
