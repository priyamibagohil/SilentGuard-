// Profile provider - CRUD operations for silent profiles
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/profile_model.dart';
import '../core/services/storage_service.dart';
import '../core/utils/time_utils.dart';

class ProfileProvider extends ChangeNotifier {
  List<ProfileModel> _profiles = [];
  static const _uuid = Uuid();

  ProfileProvider() {
    _profiles = StorageService.loadProfiles();
  }

  List<ProfileModel> get profiles => List.unmodifiable(_profiles);

  /// Profiles active right now.
  List<ProfileModel> get activeProfiles => _profiles.where((p) {
        if (!p.isEnabled) return false;
        if (!TimeUtils.isTodayInDays(p.repeatDays)) return false;
        return TimeUtils.isTimeInRange(p.startTime, p.endTime);
      }).toList();

  /// Next profile to become active (today, sorted by start time).
  ProfileModel? get nextScheduledProfile {
    final now = TimeOfDay.now();
    final nowMins = now.hour * 60 + now.minute;

    final upcoming = _profiles.where((p) {
      if (!p.isEnabled) return false;
      if (!TimeUtils.isTodayInDays(p.repeatDays)) return false;
      final startMins = p.startTime.hour * 60 + p.startTime.minute;
      return startMins > nowMins;
    }).toList();

    if (upcoming.isEmpty) return null;
    upcoming.sort((a, b) {
      final aMin = a.startTime.hour * 60 + a.startTime.minute;
      final bMin = b.startTime.hour * 60 + b.startTime.minute;
      return aMin.compareTo(bMin);
    });
    return upcoming.first;
  }

  /// Add a new profile.
  Future<void> addProfile({
    required String name,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required List<int> repeatDays,
    required String mode,
    bool isPriority = false,
  }) async {
    final profile = ProfileModel(
      id: _uuid.v4(),
      name: name,
      startTime: startTime,
      endTime: endTime,
      repeatDays: repeatDays,
      mode: mode,
      isPriority: isPriority,
    );
    _profiles.add(profile);
    await _save();
    notifyListeners();
  }

  /// Update an existing profile.
  Future<void> updateProfile(ProfileModel updated) async {
    final index = _profiles.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _profiles[index] = updated;
    await _save();
    notifyListeners();
  }

  /// Toggle enable/disable for a profile.
  Future<void> toggleProfile(String id) async {
    final index = _profiles.indexWhere((p) => p.id == id);
    if (index == -1) return;
    _profiles[index] = _profiles[index].copyWith(
      isEnabled: !_profiles[index].isEnabled,
    );
    await _save();
    notifyListeners();
  }

  /// Delete a profile by ID.
  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await StorageService.saveProfiles(_profiles);
  }
}
