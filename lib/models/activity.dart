import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String text;
  final String time;
  final String type;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.text,
    required this.time,
    required this.type,
    required this.timestamp,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['ID'] ?? '',
      text: json['Text'] ?? '',
      time: json['Time'] ?? '',
      type: json['Type'] ?? '',
      timestamp: DateTime.tryParse(json['Timestamp']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Text': text,
      'Time': time,
      'Type': type,
      'Timestamp': timestamp.toIso8601String(),
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  IconData get typeIcon {
    switch (type.toLowerCase()) {
      case 'move':
        return Icons.move_to_inbox_rounded;
      case 'dispatch':
        return Icons.local_shipping_rounded;
      case 'arrival':
        return Icons.inventory_rounded;
      case 'system':
        return Icons.settings_rounded;
      case 'inventory':
        return Icons.inventory_2_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color get typeColor {
    switch (type.toLowerCase()) {
      case 'move':
        return Colors.blue;
      case 'dispatch':
        return Colors.orange;
      case 'arrival':
        return Colors.green;
      case 'system':
        return Colors.purple;
      case 'inventory':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}
