class SystemStats {
  final int capacity;
  final int itemsProcessed;
  final String uptime;
  final int totalItems;
  final int availableSlots;
  final int occupiedSlots;
  final DateTime lastUpdated;

  SystemStats({
    required this.capacity,
    required this.itemsProcessed,
    required this.uptime,
    required this.totalItems,
    required this.availableSlots,
    required this.occupiedSlots,
    required this.lastUpdated,
  });

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      capacity: int.tryParse(json['Capacity'].toString()) ?? 120,
      itemsProcessed: int.tryParse(json['Items_Processed'].toString()) ?? 0,
      uptime: json['Uptime'] ?? '99.9%',
      totalItems: int.tryParse(json['Total_Items'].toString()) ?? 0,
      availableSlots: int.tryParse(json['Available_Slots'].toString()) ?? 0,
      occupiedSlots: int.tryParse(json['Occupied_Slots'].toString()) ?? 0,
      lastUpdated: DateTime.tryParse(json['Last_Updated']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Capacity': capacity,
      'Items_Processed': itemsProcessed,
      'Uptime': uptime,
      'Total_Items': totalItems,
      'Available_Slots': availableSlots,
      'Occupied_Slots': occupiedSlots,
      'Last_Updated': lastUpdated.toIso8601String(),
    };
  }

  double get occupancyPercentage {
    if (capacity == 0) return 0.0;
    return (occupiedSlots / capacity) * 100;
  }

  double get availabilityPercentage {
    if (capacity == 0) return 0.0;
    return (availableSlots / capacity) * 100;
  }

  String get lastUpdatedFormatted {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
