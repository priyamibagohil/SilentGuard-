// Settings Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../core/services/sound_service.dart';
import '../../providers/theme_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Settings'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionHeader('Appearance', isDark),
          _buildCard(
            isDark,
            children: [
              Consumer<ThemeProvider>(
                builder: (_, themeProvider, __) => _buildSwitchTile(
                  icon: Icons.dark_mode_rounded,
                  iconColor: const Color(0xFF6B46C1),
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme',
                  value: themeProvider.isDarkMode,
                  onChanged: (v) => themeProvider.setDarkMode(v),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notifications Section
          _buildSectionHeader('Notifications', isDark),
          _buildCard(
            isDark,
            children: [
              Consumer<SettingsProvider>(
                builder: (_, settings, __) => _buildSwitchTile(
                  icon: Icons.notifications_rounded,
                  iconColor: AppColors.primaryBlue,
                  title: 'Silent Alerts',
                  subtitle: 'Notify when silent mode starts/ends',
                  value: settings.notificationsEnabled,
                  onChanged: (v) => settings.setNotificationsEnabled(v),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Automation Section
          _buildSectionHeader('Automation', isDark),
          _buildCard(
            isDark,
            children: [
              Consumer<SettingsProvider>(
                builder: (_, settings, __) => _buildSwitchTile(
                  icon: Icons.restart_alt_rounded,
                  iconColor: AppColors.activeGreen,
                  title: 'Auto-start on Boot',
                  subtitle: 'Resume monitoring after device restart',
                  value: settings.autoStartOnBoot,
                  onChanged: (v) => settings.setAutoStartOnBoot(v),
                  isDark: isDark,
                ),
              ),
              _buildDivider(isDark),
              _buildActionTile(
                icon: Icons.battery_saver_rounded,
                iconColor: Colors.orange,
                title: 'Battery Optimization',
                subtitle: 'Disable for reliable background tasks',
                onTap: () => _showBatteryGuide(context),
                isDark: isDark,
              ),
              _buildDivider(isDark),
              _buildActionTile(
                icon: Icons.do_not_disturb_on_rounded,
                iconColor: AppColors.silentRed,
                title: 'DND Permission',
                subtitle: 'Required for silent mode control',
                onTap: () => SoundService.openDndSettings(),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // About Section
          _buildSectionHeader('About', isDark),
          _buildCard(
            isDark,
            children: [
              _buildInfoTile(
                icon: Icons.shield_rounded,
                iconColor: AppColors.primaryBlue,
                title: AppConstants.appName,
                subtitle: 'Version ${AppConstants.appVersion}',
                isDark: isDark,
              ),
              _buildDivider(isDark),
              _buildInfoTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.primaryPurple,
                title: 'About',
                subtitle: AppConstants.appTagline,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // App logo footer
          Center(
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Made with ❤️ for productivity',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white38 : Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white38 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white24 : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 70,
      color: isDark ? Colors.white10 : Colors.grey.shade100,
    );
  }

  void _showBatteryGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.battery_saver_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Battery Optimization'),
          ],
        ),
        content: const Text(
          'To ensure SilentGuard+ works reliably in the background:\n\n'
          '1. Go to Settings → Apps → SilentGuard+\n'
          '2. Tap "Battery"\n'
          '3. Select "Unrestricted"\n\n'
          'This prevents Android from killing the background service.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
