// History tile widget - timeline style
import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/time_utils.dart';
import '../core/utils/constants.dart';

class HistoryTile extends StatelessWidget {
  final HistoryModel event;
  final bool isLast;

  const HistoryTile({
    super.key,
    required this.event,
    this.isLast = false,
  });

  IconData get _icon {
    if (event.action == 'activated') {
      return event.mode == AppConstants.modeSilent
          ? Icons.volume_off_rounded
          : Icons.vibration_rounded;
    }
    return Icons.volume_up_rounded;
  }

  Color get _color {
    if (event.action == 'activated') {
      return event.mode == AppConstants.modeSilent
          ? AppColors.silentRed
          : AppColors.vibrateOrange;
    }
    return AppColors.normalBlue;
  }

  String get _actionLabel {
    if (event.action == 'activated') {
      return event.mode == AppConstants.modeSilent
          ? 'Silent activated'
          : 'Vibrate activated';
    }
    return 'Sound restored';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_icon, color: _color, size: 18),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _actionLabel,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Profile: ${event.profileName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    TimeUtils.formatDateTime(event.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
