import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../models/activity.dart';
import '../models/system_stats.dart';
import '../utils/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Items Storage
  Future<void> saveItems(List<Item> items) async {
    await init();
    final itemsJson = items.map((item) => item.toJson()).toList();
    await _prefs!.setString('cached_items', json.encode(itemsJson));
    await _prefs!.setString(AppConstants.lastSyncKey, DateTime.now().toIso8601String());
  }

  Future<List<Item>> getCachedItems() async {
    await init();
    final itemsJson = _prefs!.getString('cached_items');
    if (itemsJson != null) {
      final List<dynamic> data = json.decode(itemsJson);
      return data.map((json) => Item.fromJson(json)).toList();
    }
    return [];
  }

  // Activities Storage
  Future<void> saveActivities(List<Activity> activities) async {
    await init();
    final activitiesJson = activities.map((activity) => activity.toJson()).toList();
    await _prefs!.setString('cached_activities', json.encode(activitiesJson));
  }

  Future<List<Activity>> getCachedActivities() async {
    await init();
    final activitiesJson = _prefs!.getString('cached_activities');
    if (activitiesJson != null) {
      final List<dynamic> data = json.decode(activitiesJson);
      return data.map((json) => Activity.fromJson(json)).toList();
    }
    return [];
  }

  // System Stats Storage
  Future<void> saveSystemStats(SystemStats stats) async {
    await init();
    await _prefs!.setString('cached_stats', json.encode(stats.toJson()));
  }

  Future<SystemStats?> getCachedSystemStats() async {
    await init();
    final statsJson = _prefs!.getString('cached_stats');
    if (statsJson != null) {
      final Map<String, dynamic> data = json.decode(statsJson);
      return SystemStats.fromJson(data);
    }
    return null;
  }

  // Rack Occupancy Storage
  Future<void> saveRackOccupancy(Map<String, dynamic> occupancy) async {
    await init();
    await _prefs!.setString('cached_rack_occupancy', json.encode(occupancy));
  }

  Future<Map<String, dynamic>?> getCachedRackOccupancy() async {
    await init();
    final occupancyJson = _prefs!.getString('cached_rack_occupancy');
    if (occupancyJson != null) {
      return json.decode(occupancyJson);
    }
    return null;
  }

  // Last Sync Time
  Future<DateTime?> getLastSyncTime() async {
    await init();
    final lastSyncString = _prefs!.getString(AppConstants.lastSyncKey);
    if (lastSyncString != null) {
      return DateTime.tryParse(lastSyncString);
    }
    return null;
  }

  // User Preferences
  Future<void> saveUserPreference(String key, dynamic value) async {
    await init();
    if (value is String) {
      await _prefs!.setString(key, value);
    } else if (value is int) {
      await _prefs!.setInt(key, value);
    } else if (value is double) {
      await _prefs!.setDouble(key, value);
    } else if (value is bool) {
      await _prefs!.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs!.setStringList(key, value);
    }
  }

  Future<T?> getUserPreference<T>(String key) async {
    await init();
    return _prefs!.get(key) as T?;
  }

  // Clear all cached data
  Future<void> clearCache() async {
    await init();
    await _prefs!.remove('cached_items');
    await _prefs!.remove('cached_activities');
    await _prefs!.remove('cached_stats');
    await _prefs!.remove('cached_rack_occupancy');
    await _prefs!.remove(AppConstants.lastSyncKey);
  }

  // Clear specific cache
  Future<void> clearItemsCache() async {
    await init();
    await _prefs!.remove('cached_items');
  }

  Future<void> clearActivitiesCache() async {
    await init();
    await _prefs!.remove('cached_activities');
  }

  Future<void> clearStatsCache() async {
    await init();
    await _prefs!.remove('cached_stats');
  }

  Future<void> clearRackOccupancyCache() async {
    await init();
    await _prefs!.remove('cached_rack_occupancy');
  }

  // Check if data is stale
  Future<bool> isDataStale({Duration maxAge = const Duration(minutes: 5)}) async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    return now.difference(lastSync) > maxAge;
  }

  // Get cache size info
  Future<Map<String, int>> getCacheInfo() async {
    await init();
    final keys = _prefs!.getKeys();
    final info = <String, int>{};
    
    for (final key in keys) {
      if (key.startsWith('cached_')) {
        final value = _prefs!.getString(key);
        if (value != null) {
          info[key] = value.length;
        }
      }
    }
    
    return info;
  }
}
