// Home provider - manages current sound mode and SilentGuard toggle
import 'package:flutter/material.dart';
import '../core/services/sound_service.dart';
import '../core/services/storage_service.dart';
import '../core/services/background_service.dart';
import '../core/utils/constants.dart';

class HomeProvider extends ChangeNotifier {
  bool _isEnabled;
  String _currentMode = AppConstants.modeNormal;
  bool _isLoading = false;

  HomeProvider() : _isEnabled = StorageService.getIsEnabled();

  bool get isEnabled => _isEnabled;
  String get currentMode => _currentMode;
  bool get isLoading => _isLoading;

  bool get isSilentOrVibrate =>
      _currentMode == AppConstants.modeSilent ||
      _currentMode == AppConstants.modeVibrate;

  /// Refresh current sound mode from device.
  Future<void> refreshCurrentMode() async {
    _currentMode = await SoundService.getCurrentMode();
    notifyListeners();
  }

  /// Toggle SilentGuard on/off.
  Future<void> toggleEnabled() async {
    _isEnabled = !_isEnabled;
    await StorageService.setIsEnabled(_isEnabled);
    if (_isEnabled) {
      // When enabling, immediately run a schedule check and sync mode
      try {
        await BackgroundService.runImmediateCheck();
      } catch (_) {}
      await refreshCurrentMode();
    } else {
      // When disabling, restore normal mode
      await SoundService.setNormalMode();
      _currentMode = AppConstants.modeNormal;
    }
    notifyListeners();
  }

  /// Manually set sound mode.
  Future<void> setMode(String mode) async {
    _isLoading = true;
    notifyListeners();

    final success = await SoundService.applyMode(mode);
    if (success) {
      _currentMode = mode;
    }

    _isLoading = false;
    notifyListeners();
  }
}
