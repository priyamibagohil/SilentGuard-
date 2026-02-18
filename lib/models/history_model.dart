// History event model for SilentGuard+
class HistoryModel {
  final String id;
  final String profileName;
  final String action; // 'activated' | 'deactivated'
  final String mode; // 'silent' | 'vibrate' | 'normal'
  final DateTime timestamp;

  const HistoryModel({
    required this.id,
    required this.profileName,
    required this.action,
    required this.mode,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'profileName': profileName,
        'action': action,
        'mode': mode,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        id: json['id'] as String,
        profileName: json['profileName'] as String,
        action: json['action'] as String,
        mode: json['mode'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
