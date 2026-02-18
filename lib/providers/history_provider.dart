// History provider - manages silent event history
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/history_model.dart';
import '../core/services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<HistoryModel> _history = [];
  static const _uuid = Uuid();

  HistoryProvider() {
    _history = StorageService.loadHistory();
  }

  List<HistoryModel> get history => List.unmodifiable(_history);

  /// Add a new history event.
  Future<void> addEvent({
    required String profileName,
    required String action,
    required String mode,
  }) async {
    final event = HistoryModel(
      id: _uuid.v4(),
      profileName: profileName,
      action: action,
      mode: mode,
      timestamp: DateTime.now(),
    );
    _history.insert(0, event); // newest first
    // Keep only last 100 events
    if (_history.length > 100) {
      _history = _history.sublist(0, 100);
    }
    await StorageService.saveHistory(_history);
    notifyListeners();
  }

  /// Clear all history.
  Future<void> clearHistory() async {
    _history.clear();
    await StorageService.saveHistory(_history);
    notifyListeners();
  }
}
