// Add/Edit Profile Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/time_utils.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/day_selector.dart';

class AddEditProfileScreen extends StatefulWidget {
  final ProfileModel? profile;

  const AddEditProfileScreen({super.key, this.profile});

  @override
  State<AddEditProfileScreen> createState() => _AddEditProfileScreenState();
}

class _AddEditProfileScreenState extends State<AddEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late List<int> _selectedDays;
  late String _mode;
  late bool _isPriority;

  bool get _isEditing => widget.profile != null;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p?.name ?? '');
    _startTime = p?.startTime ?? const TimeOfDay(hour: 22, minute: 0);
    _endTime = p?.endTime ?? const TimeOfDay(hour: 7, minute: 0);
    _selectedDays = p?.repeatDays ?? [0, 1, 2, 3, 4]; // Mon-Fri default
    _mode = p?.mode ?? AppConstants.modeSilent;
    _isPriority = p?.isPriority ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primaryBlue,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return;
    }

    final provider = context.read<ProfileProvider>();

    if (_isEditing) {
      await provider.updateProfile(
        widget.profile!.copyWith(
          name: _nameController.text.trim(),
          startTime: _startTime,
          endTime: _endTime,
          repeatDays: _selectedDays,
          mode: _mode,
          isPriority: _isPriority,
        ),
      );
    } else {
      await provider.addProfile(
        name: _nameController.text.trim(),
        startTime: _startTime,
        endTime: _endTime,
        repeatDays: _selectedDays,
        mode: _mode,
        isPriority: _isPriority,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'New Profile'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Name
            _buildSection(
              context,
              title: 'Profile Name',
              isDark: isDark,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Night Sleep, Office Hours',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(height: 16),

            // Time Range
            _buildSection(
              context,
              title: 'Time Range',
              isDark: isDark,
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      label: 'Start',
                      time: _startTime,
                      onTap: () => _pickTime(true),
                      isDark: isDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: isDark ? Colors.white38 : Colors.grey.shade400,
                    ),
                  ),
                  Expanded(
                    child: _buildTimePicker(
                      context,
                      label: 'End',
                      time: _endTime,
                      onTap: () => _pickTime(false),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Repeat Days
            _buildSection(
              context,
              title: 'Repeat Days',
              isDark: isDark,
              child: DaySelector(
                selectedDays: _selectedDays,
                onChanged: (days) => setState(() => _selectedDays = days),
              ),
            ),
            const SizedBox(height: 16),

            // Sound Mode
            _buildSection(
              context,
              title: 'Sound Mode',
              isDark: isDark,
              child: Row(
                children: [
                  Expanded(
                    child: _buildModeOption(
                      context,
                      label: 'Silent',
                      icon: Icons.volume_off_rounded,
                      value: AppConstants.modeSilent,
                      color: AppColors.silentRed,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModeOption(
                      context,
                      label: 'Vibrate',
                      icon: Icons.vibration_rounded,
                      value: AppConstants.modeVibrate,
                      color: AppColors.vibrateOrange,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Priority Toggle
            _buildSection(
              context,
              title: 'Options',
              isDark: isDark,
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Priority Profile',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Takes precedence over other profiles',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isPriority,
                onChanged: (v) => setState(() => _isPriority = v),
              ),
            ),
            const SizedBox(height: 28),

            // Save Button
            GradientButton(
              label: _isEditing ? 'Save Changes' : 'Create Profile',
              icon: Icons.check_rounded,
              onPressed: _save,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context, {
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              TimeUtils.formatTimeOfDayAmPm(time),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    final selected = _mode == value;
    return GestureDetector(
      onTap: () => setState(() => _mode = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : (isDark ? Colors.white12 : Colors.grey.shade200),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? color : Colors.grey, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? color : (isDark ? Colors.white54 : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
