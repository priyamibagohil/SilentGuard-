// Profile card widget
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/time_utils.dart';
import '../core/utils/constants.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  IconData get _modeIcon => profile.mode == AppConstants.modeSilent
      ? Icons.volume_off_rounded
      : Icons.vibration_rounded;

  Color get _modeColor => profile.mode == AppConstants.modeSilent
      ? AppColors.silentRed
      : AppColors.vibrateOrange;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.cardDark : Colors.white;

    return Dismissible(
      key: Key(profile.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: profile.isEnabled
              ? Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  width: 1.5,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Mode icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _modeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_modeIcon, color: _modeColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  // Profile info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.isPriority)
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Priority',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${TimeUtils.formatTimeOfDayAmPm(profile.startTime)} – ${TimeUtils.formatTimeOfDayAmPm(profile.endTime)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          TimeUtils.getDaysLabel(profile.repeatDays),
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Toggle
                  Switch(
                    value: profile.isEnabled,
                    onChanged: (_) => onToggle(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
