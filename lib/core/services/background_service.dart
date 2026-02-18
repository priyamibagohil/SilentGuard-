// Background service using Workmanager for schedule checking
import 'package:workmanager/workmanager.dart';
import '../utils/constants.dart';
import '../utils/time_utils.dart';
import 'sound_service.dart';
import 'notification_service.dart';
import 'storage_service.dart';

/// Top-level callback required by Workmanager (must be a top-level function).
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize services
      await StorageService.init();
      await NotificationService.init();

      // Check if SilentGuard is enabled
      final isEnabled = StorageService.getIsEnabled();
      if (!isEnabled) return Future.value(true);

      // Load profiles
      final profiles = StorageService.loadProfiles();
      final previousMode = StorageService.getPreviousMode();

      bool foundActiveProfile = false;
      String? activeProfileName;
      String? activeMode;

      // Check each enabled profile
      for (final profile in profiles) {
        if (!profile.isEnabled) continue;
        if (!TimeUtils.isTodayInDays(profile.repeatDays)) continue;
        if (!TimeUtils.isTimeInRange(profile.startTime, profile.endTime)) continue;

        foundActiveProfile = true;
        activeProfileName = profile.name;
        activeMode = profile.mode;
        break; // Use first matching profile
      }

      if (foundActiveProfile && activeMode != null) {
        // Apply the profile's sound mode
        await SoundService.applyMode(activeMode);

        // Show notification if mode changed
        if (previousMode == AppConstants.modeNormal) {
          final notifEnabled = StorageService.getNotificationsEnabled();
          if (notifEnabled) {
            await NotificationService.showSilentStartNotification(activeProfileName!);
          }
          await StorageService.setPreviousMode(activeMode);
        }
      } else {
        // No active profile - restore normal mode if we were in silent/vibrate
        if (previousMode != AppConstants.modeNormal) {
          await SoundService.setNormalMode();
          final notifEnabled = StorageService.getNotificationsEnabled();
          if (notifEnabled) {
            await NotificationService.showSilentEndNotification(previousMode);
          }
          await StorageService.setPreviousMode(AppConstants.modeNormal);
        }
      }

      return Future.value(true);
    } catch (e) {
      // ignore: avoid_print
      print('BackgroundService error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundService {
  /// Register the periodic background task.
  static Future<void> registerPeriodicTask() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );

    await Workmanager().registerPeriodicTask(
      AppConstants.bgTaskName,
      AppConstants.bgTaskName,
      tag: AppConstants.bgTaskTag,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.not_required,
      ),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 5),
    );
  }

  /// Cancel all background tasks.
  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  /// Run a one-time immediate check (for testing or on app open).
  static Future<void> runImmediateCheck() async {
    await Workmanager().registerOneOffTask(
      '${AppConstants.bgTaskName}_immediate',
      AppConstants.bgTaskName,
      tag: AppConstants.bgTaskTag,
      constraints: Constraints(networkType: NetworkType.not_required),
    );
  }
}
