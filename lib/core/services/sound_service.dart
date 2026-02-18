// Sound service - platform channel client for audio mode control
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class SoundService {
  static const MethodChannel _channel = MethodChannel(AppConstants.soundChannel);

  /// Set phone to silent mode.
  static Future<bool> setSilentMode() async {
    try {
      final result = await _channel.invokeMethod<bool>('setSilentMode');
      return result ?? false;
    } on PlatformException catch (e) {
      // May fail if DND permission not granted
      print('SoundService.setSilentMode error: ${e.message}');
      return false;
    }
  }

  /// Set phone to vibrate mode.
  static Future<bool> setVibrateMode() async {
    try {
      final result = await _channel.invokeMethod<bool>('setVibrateMode');
      return result ?? false;
    } on PlatformException catch (e) {
      print('SoundService.setVibrateMode error: ${e.message}');
      return false;
    }
  }

  /// Set phone to normal (ring) mode.
  static Future<bool> setNormalMode() async {
    try {
      final result = await _channel.invokeMethod<bool>('setNormalMode');
      return result ?? false;
    } on PlatformException catch (e) {
      print('SoundService.setNormalMode error: ${e.message}');
      return false;
    }
  }

  /// Get current ringer mode: 'silent', 'vibrate', or 'normal'.
  static Future<String> getCurrentMode() async {
    try {
      final result = await _channel.invokeMethod<String>('getCurrentMode');
      return result ?? AppConstants.modeNormal;
    } on PlatformException catch (e) {
      print('SoundService.getCurrentMode error: ${e.message}');
      return AppConstants.modeNormal;
    }
  }

  /// Check if DND (Do Not Disturb) permission is granted.
  static Future<bool> checkDndPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkDndPermission');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Open DND settings screen.
  static Future<void> openDndSettings() async {
    try {
      await _channel.invokeMethod('openDndSettings');
    } on PlatformException catch (e) {
      print('SoundService.openDndSettings error: ${e.message}');
    }
  }

  /// Apply the given mode string.
  static Future<bool> applyMode(String mode) async {
    switch (mode) {
      case AppConstants.modeSilent:
        return setSilentMode();
      case AppConstants.modeVibrate:
        return setVibrateMode();
      case AppConstants.modeNormal:
        return setNormalMode();
      default:
        return setNormalMode();
    }
  }
}
