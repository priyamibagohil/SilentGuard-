// Home Screen - Dashboard with status, toggle, profiles
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/time_utils.dart';
import '../../core/utils/constants.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/status_card.dart';
import '../../widgets/quick_action_card.dart';
import '../profiles/add_edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().refreshCurrentMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Gradient App Bar
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.headerGradient),
              ),
            ),
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'SilentGuard+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            actions: [
              Consumer<HomeProvider>(
                builder: (_, home, __) => IconButton(
                  icon: Icon(
                    home.isLoading
                        ? Icons.sync_rounded
                        : Icons.refresh_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => home.refreshCurrentMode(),
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Status Card
                Consumer2<HomeProvider, ProfileProvider>(
                  builder: (_, home, profiles, __) => StatusCard(
                    currentMode: home.currentMode,
                    isEnabled: home.isEnabled,
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Toggle Card
                Consumer<HomeProvider>(
                  builder: (_, home, __) => _buildToggleCard(context, home, isDark),
                ),
                const SizedBox(height: 16),

                // Next Scheduled Profile
                Consumer<ProfileProvider>(
                  builder: (_, profileProvider, __) {
                    final next = profileProvider.nextScheduledProfile;
                    if (next == null) return const SizedBox.shrink();
                    return _buildNextScheduleCard(context, next, isDark);
                  },
                ),

                // Today's Active Profiles
                Consumer<ProfileProvider>(
                  builder: (_, profileProvider, __) {
                    final active = profileProvider.activeProfiles;
                    if (active.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _sectionTitle('Active Now', isDark),
                        const SizedBox(height: 10),
                        ...active.map((p) => _buildActiveProfileChip(context, p, isDark)),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                _sectionTitle('Quick Actions', isDark),
                const SizedBox(height: 10),

                // Quick Actions Grid
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                  children: [
                    QuickActionCard(
                      icon: Icons.add_circle_outline_rounded,
                      label: 'Add Profile',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddEditProfileScreen(),
                        ),
                      ),
                      color: AppColors.primaryBlue,
                    ),
                    QuickActionCard(
                      icon: Icons.volume_off_rounded,
                      label: 'Go Silent',
                      onTap: () => context.read<HomeProvider>().setMode(AppConstants.modeSilent),
                      color: AppColors.silentRed,
                    ),
                    QuickActionCard(
                      icon: Icons.vibration_rounded,
                      label: 'Vibrate',
                      onTap: () => context.read<HomeProvider>().setMode(AppConstants.modeVibrate),
                      color: AppColors.vibrateOrange,
                    ),
                    QuickActionCard(
                      icon: Icons.volume_up_rounded,
                      label: 'Normal',
                      onTap: () => context.read<HomeProvider>().setMode(AppConstants.modeNormal),
                      color: AppColors.normalBlue,
                    ),
                    QuickActionCard(
                      icon: Icons.history_rounded,
                      label: 'History',
                      onTap: () {},
                      color: AppColors.primaryPurple,
                    ),
                    QuickActionCard(
                      icon: Icons.info_outline_rounded,
                      label: 'About',
                      onTap: () => _showAboutDialog(context),
                      color: Colors.teal,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard(BuildContext context, HomeProvider home, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (home.isEnabled ? AppColors.primaryBlue : Colors.grey)
                  .withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.power_settings_new_rounded,
              color: home.isEnabled ? AppColors.primaryBlue : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SilentGuard',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  home.isEnabled
                      ? 'Monitoring schedules'
                      : 'Tap to enable',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: home.isEnabled,
            onChanged: (_) => home.toggleEnabled(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextScheduleCard(BuildContext context, dynamic profile, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryPurple.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule_rounded, color: AppColors.primaryPurple, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next: ${profile.name}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Starts at ${TimeUtils.formatTimeOfDayAmPm(profile.startTime)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveProfileChip(BuildContext context, dynamic profile, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.activeGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.activeGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.activeGreen, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              profile.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${TimeUtils.formatTimeOfDayAmPm(profile.startTime)} – ${TimeUtils.formatTimeOfDayAmPm(profile.endTime)}',
            style: const TextStyle(fontSize: 11, color: AppColors.activeGreen),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: AppColors.primaryBlue),
            SizedBox(width: 8),
            Text('SilentGuard+'),
          ],
        ),
        content: const Text(
          'Smart Auto Silent Manager\nVersion 1.0.0\n\nAutomatically manages your phone\'s sound mode based on your schedules and profiles.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
