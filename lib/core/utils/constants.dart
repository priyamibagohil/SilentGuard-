// App-wide constants for SilentGuard+
class AppConstants {
  // Platform channel
  static const String soundChannel = 'silentguard/sound';

  // SharedPreferences keys
  static const String keyProfiles = 'sg_profiles';
  static const String keyHistory = 'sg_history';
  static const String keyIsDarkMode = 'sg_dark_mode';
  static const String keyIsEnabled = 'sg_enabled';
  static const String keyNotifications = 'sg_notifications';
  static const String keyAutoStart = 'sg_auto_start';
  static const String keyOnboardingDone = 'sg_onboarding_done';
  static const String keyPreviousMode = 'sg_previous_mode';

  // Workmanager task names
  static const String bgTaskName = 'silentguard_schedule_check';
  static const String bgTaskTag = 'silentguard_bg';

  // Sound modes
  static const String modeSilent = 'silent';
  static const String modeVibrate = 'vibrate';
  static const String modeNormal = 'normal';

  // Day names
  static const List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List<String> dayNamesShort = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> dayNamesFull = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  // Notification IDs
  static const int notifIdSilentStart = 1001;
  static const int notifIdSilentEnd = 1002;
  static const String notifChannelId = 'silentguard_channel';
  static const String notifChannelName = 'SilentGuard Alerts';

  // App info
  static const String appName = 'SilentGuard+';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Smart Auto Silent Manager';
}
