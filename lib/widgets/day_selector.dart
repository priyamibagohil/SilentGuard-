// Day selector widget - row of selectable day chips
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DaySelector extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final selected = selectedDays.contains(i);
        return GestureDetector(
          onTap: () {
            final updated = List<int>.from(selectedDays);
            if (selected) {
              updated.remove(i);
            } else {
              updated.add(i);
            }
            onChanged(updated);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: selected
                  ? AppColors.primaryGradient
                  : null,
              color: selected
                  ? null
                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
              borderRadius: BorderRadius.circular(10),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? Colors.white
                      : (isDark ? Colors.white60 : Colors.grey.shade600),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
