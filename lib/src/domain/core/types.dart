import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

typedef Void = ffi.Void;
typedef Bool = ffi.Bool;
typedef Int = ffi.Int32;
typedef Double = ffi.Double;
typedef Chars = ffi.Pointer<Utf8>;

class Response extends ffi.Struct {
  @Bool()
  external bool success;

  external Chars message;

  String get dMessage => message.toDartString();

  @override
  String toString() => '$success: $dMessage';
}

typedef DeviceListNative = Response Function(Chars filter, Chars supported);
typedef DeviceList = Response Function(Chars filter, Chars supported);

typedef RGBNative = Response Function(
  Chars id,
  Chars action,
  Chars mode,
  Chars color,
  Int speed,
  Int brightness,
  Bool shining,
);

typedef RGB = Response Function(
  Chars id,
  Chars action,
  Chars mode,
  Chars color,
  int speed,
  int brightness,
  bool shining,
);

typedef PRNative = Response Function(
  Chars id,
  Chars action,
  Int x,
);
typedef PRDart = Response Function(
  Chars id,
  Chars action,
  int x,
);

typedef TDNative = Response Function(
  Chars id,
  Chars action,
  Double x,
);
typedef TDDart = Response Function(
  Chars id,
  Chars action,
  double x,
);

typedef DZNative = Response Function(
  Chars id,
  Chars action,
  Double top,
  Double bottom,
);
typedef DZDart = Response Function(
  Chars id,
  Chars action,
  double top,
  double bottom,
);

typedef PRDPINative = Response Function(
  Chars id,
  Chars action,
  Chars x,
);
typedef PRDPI = Response Function(
  Chars id,
  Chars action,
  Chars x,
);

typedef ProfileNative = Response Function(
  Chars action,
  Int id,
  Chars json,
);
typedef ProfileDart = Response Function(
  Chars action,
  int id,
  Chars json,
);

typedef HeadsetNative = Response Function(
  Chars action,
  Chars key,
  Int value,
);
typedef HeadsetDart = Response Function(
  Chars action,
  Chars key,
  int value,
);
