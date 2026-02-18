// Profile data model for SilentGuard+
import 'package:flutter/material.dart';

class ProfileModel {
  final String id;
  String name;
  TimeOfDay startTime;
  TimeOfDay endTime;
  List<int> repeatDays; // 0=Mon, 1=Tue, ..., 6=Sun
  String mode; // 'silent' | 'vibrate'
  bool isEnabled;
  bool isPriority;
  DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.repeatDays,
    this.mode = 'silent',
    this.isEnabled = true,
    this.isPriority = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Convert to JSON map for storage.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startHour': startTime.hour,
        'startMinute': startTime.minute,
        'endHour': endTime.hour,
        'endMinute': endTime.minute,
        'repeatDays': repeatDays,
        'mode': mode,
        'isEnabled': isEnabled,
        'isPriority': isPriority,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Create from JSON map.
  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        name: json['name'] as String,
        startTime: TimeOfDay(
          hour: json['startHour'] as int,
          minute: json['startMinute'] as int,
        ),
        endTime: TimeOfDay(
          hour: json['endHour'] as int,
          minute: json['endMinute'] as int,
        ),
        repeatDays: List<int>.from(json['repeatDays'] as List),
        mode: json['mode'] as String? ?? 'silent',
        isEnabled: json['isEnabled'] as bool? ?? true,
        isPriority: json['isPriority'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );

  /// Create a copy with modified fields.
  ProfileModel copyWith({
    String? id,
    String? name,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    List<int>? repeatDays,
    String? mode,
    bool? isEnabled,
    bool? isPriority,
  }) =>
      ProfileModel(
        id: id ?? this.id,
        name: name ?? this.name,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        repeatDays: repeatDays ?? this.repeatDays,
        mode: mode ?? this.mode,
        isEnabled: isEnabled ?? this.isEnabled,
        isPriority: isPriority ?? this.isPriority,
        createdAt: createdAt,
      );
}
