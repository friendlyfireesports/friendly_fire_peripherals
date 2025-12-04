import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'package:friendly_fire_peripherals/src/domain/core/dynamic_library_client.dart';
import 'package:friendly_fire_peripherals/src/domain/core/types.dart';

class LocalDynamicLibraryClient extends DynamicLibraryClient {
  LocalDynamicLibraryClient(this._dynamicLibraryPath) : super();

  final String _dynamicLibraryPath;
  late final ffi.DynamicLibrary _dynamicLibrary;

  @override
  void load() {
    _dynamicLibrary = ffi.DynamicLibrary.open(_dynamicLibraryPath);
  }

  @override
  Response list(String filter, String supported) {
    final deviceList =
        _dynamicLibrary.lookupFunction<DeviceListNative, DeviceList>('List');

    final nFilter = filter.toNativeUtf8();
    final nSupported = supported.toNativeUtf8();

    return deviceList(nFilter, nSupported);
  }

  @override
  Response keyboardRGB(
    String id,
    String action, [
    String? mode,
    String? color,
    int? speed,
    int? brightness,
    bool? shining,
  ]) {
    final keyboardRGB =
        _dynamicLibrary.lookupFunction<RGBNative, RGB>('KeyboardRGB');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    final nMode = (mode ?? '').toNativeUtf8();
    final nColor = (color ?? '').toNativeUtf8();
    final nSpeed = speed ?? 0;
    final nBrightness = brightness ?? 0;
    final nShining = shining ?? false;

    return keyboardRGB(
      nId,
      nAction,
      nMode,
      nColor,
      nSpeed,
      nBrightness,
      nShining,
    );
  }

  @override
  Response mouseRGB(
    String id,
    String action, [
    String? mode,
    String? color,
    int? speed,
    int? brightness,
  ]) {
    final mouseRGB = _dynamicLibrary.lookupFunction<RGBNative, RGB>('MouseRGB');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    final nMode = (mode ?? '').toNativeUtf8();
    final nColor = (color ?? '').toNativeUtf8();
    final nSpeed = speed ?? 0;
    final nBrightness = brightness ?? 0;

    return mouseRGB(nId, nAction, nMode, nColor, nSpeed, nBrightness, false);
  }

  @override
  Response mousePR(String id, String action, [String? pr]) {
    final mousePR =
        _dynamicLibrary.lookupFunction<PRDPINative, PRDPI>('MousePollingRate');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    final nPR = (pr ?? '').toNativeUtf8();

    return mousePR(nId, nAction, nPR);
  }

  @override
  Response mouseDPI(String id, String action, [String? dpi]) {
    final mouseDPI =
        _dynamicLibrary.lookupFunction<PRDPINative, PRDPI>('MouseDPI');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    final nDPI = (dpi ?? '').toNativeUtf8();

    return mouseDPI(nId, nAction, nDPI);
  }

  @override
  Response profile(String action, [int? id, String? json]) {
    final profile =
        _dynamicLibrary.lookupFunction<ProfileNative, ProfileDart>('Profile');

    final nAction = action.toNativeUtf8();
    final nId = id ?? 0;
    final nJson = (json ?? '').toNativeUtf8();

    return profile(nAction, nId, nJson);
  }

  @override
  Response headset(String action, [String? key, int? value]) {
    final headset =
        _dynamicLibrary.lookupFunction<HeadsetNative, HeadsetDart>('Headset');

    final nAction = action.toNativeUtf8();
    final nKey = (key ?? '').toNativeUtf8();
    final nValue = value ?? 0;

    return headset(nAction, nKey, nValue);
  }

  @override
  Response keyboardPR(
    String id,
    String action, [
    String? pr,
  ]) {
    final keyboardPR =
        _dynamicLibrary.lookupFunction<PRNative, PRDart>('KeyboardPollingRate');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    final nPR = int.tryParse((pr ?? '').split('=').last) ?? 8000;

    return keyboardPR(nId, nAction, nPR);
  }

  @override
  Response keyboardTD(
    String id,
    String action, [
    String? td,
  ]) {
    final keyboardTD = _dynamicLibrary
        .lookupFunction<TDNative, TDDart>('KeyboardTravelDistance');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    final nTD = double.tryParse((td ?? '').split('=').last) ?? 2.0;

    return keyboardTD(nId, nAction, nTD);
  }

  @override
  Response keyboardDZ(
    String id,
    String action, [
    String? topValue,
    String? bottomValue,
  ]) {
    final keyboardDZ =
        _dynamicLibrary.lookupFunction<DZNative, DZDart>('KeyboardDeadzone');

    final nId = id.toNativeUtf8();
    final nAction = action.toNativeUtf8();
    topValue = topValue?.split("=").skip(1).join("");
    bottomValue = bottomValue?.split("=").skip(1).join("");
    final nTop = double.tryParse(topValue ?? '0.1') ?? 0.1;
    final nBottom = double.tryParse(bottomValue ?? '0.3') ?? 0.3;

    return keyboardDZ(nId, nAction, nTop, nBottom);
  }
}
