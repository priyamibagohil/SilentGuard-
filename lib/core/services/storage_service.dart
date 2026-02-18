// Storage service using SharedPreferences for SilentGuard+
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/profile_model.dart';
import '../../models/history_model.dart';
import '../utils/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) throw Exception('StorageService not initialized');
    return _prefs!;
  }

  // ─── Profiles ─────────────────────────────────────────────────────────────

  static Future<void> saveProfiles(List<ProfileModel> profiles) async {
    final jsonList = profiles.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(AppConstants.keyProfiles, jsonList);
  }

  static List<ProfileModel> loadProfiles() {
    final jsonList = prefs.getStringList(AppConstants.keyProfiles) ?? [];
    return jsonList.map((s) => ProfileModel.fromJson(jsonDecode(s))).toList();
  }

  // ─── History ──────────────────────────────────────────────────────────────

  static Future<void> saveHistory(List<HistoryModel> history) async {
    final jsonList = history.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList(AppConstants.keyHistory, jsonList);
  }

  static List<HistoryModel> loadHistory() {
    final jsonList = prefs.getStringList(AppConstants.keyHistory) ?? [];
    return jsonList.map((s) => HistoryModel.fromJson(jsonDecode(s))).toList();
  }

  // ─── Settings ─────────────────────────────────────────────────────────────

  static bool getIsDarkMode() => prefs.getBool(AppConstants.keyIsDarkMode) ?? false;
  static Future<void> setIsDarkMode(bool val) => prefs.setBool(AppConstants.keyIsDarkMode, val);

  static bool getIsEnabled() => prefs.getBool(AppConstants.keyIsEnabled) ?? true;
  static Future<void> setIsEnabled(bool val) => prefs.setBool(AppConstants.keyIsEnabled, val);

  static bool getNotificationsEnabled() => prefs.getBool(AppConstants.keyNotifications) ?? true;
  static Future<void> setNotificationsEnabled(bool val) => prefs.setBool(AppConstants.keyNotifications, val);

  static bool getAutoStart() => prefs.getBool(AppConstants.keyAutoStart) ?? true;
  static Future<void> setAutoStart(bool val) => prefs.setBool(AppConstants.keyAutoStart, val);

  static bool getOnboardingDone() => prefs.getBool(AppConstants.keyOnboardingDone) ?? false;
  static Future<void> setOnboardingDone(bool val) => prefs.setBool(AppConstants.keyOnboardingDone, val);

  static String getPreviousMode() => prefs.getString(AppConstants.keyPreviousMode) ?? AppConstants.modeNormal;
  static Future<void> setPreviousMode(String mode) => prefs.setString(AppConstants.keyPreviousMode, mode);
}
