// Settings provider
import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../core/services/background_service.dart';

class SettingsProvider extends ChangeNotifier {
  bool _notificationsEnabled;
  bool _autoStartOnBoot;

  SettingsProvider()
      : _notificationsEnabled = StorageService.getNotificationsEnabled(),
        _autoStartOnBoot = StorageService.getAutoStart();

  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoStartOnBoot => _autoStartOnBoot;

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await StorageService.setNotificationsEnabled(value);
    notifyListeners();
  }

  Future<void> setAutoStartOnBoot(bool value) async {
    _autoStartOnBoot = value;
    await StorageService.setAutoStart(value);
    if (value) {
      await BackgroundService.registerPeriodicTask();
    } else {
      await BackgroundService.cancelAll();
    }
    notifyListeners();
  }
}
