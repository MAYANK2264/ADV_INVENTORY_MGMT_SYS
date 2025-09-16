import 'package:flutter/foundation.dart';
import '../models/activity.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ActivitiesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Activity> _activities = [];
  bool _isLoading = false;
  String _error = '';

  // Getters
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Get recent activities (last 10)
  List<Activity> get recentActivities {
    final sortedActivities = List<Activity>.from(_activities);
    sortedActivities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sortedActivities.take(10).toList();
  }

  // Get activities by type
  List<Activity> getActivitiesByType(String type) {
    return _activities.where((activity) => 
      activity.type.toLowerCase() == type.toLowerCase()).toList();
  }

  // Load activities
  Future<void> loadActivities({bool forceRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Check if we should use cached data
      if (!forceRefresh && !await _storageService.isDataStale()) {
        final cachedActivities = await _storageService.getCachedActivities();
        if (cachedActivities.isNotEmpty) {
          _activities = cachedActivities;
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Fetch from API
      final activities = await _apiService.getActivities();
      _activities = activities;
      
      // Cache the data
      await _storageService.saveActivities(activities);
      
    } catch (e) {
      _error = e.toString();
      
      // Try to load from cache as fallback
      try {
        final cachedActivities = await _storageService.getCachedActivities();
        if (cachedActivities.isNotEmpty) {
          _activities = cachedActivities;
        }
      } catch (cacheError) {
        // Cache also failed, keep the error
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new activity (for local tracking)
  void addActivity(Activity activity) {
    _activities.insert(0, activity);
    notifyListeners();
    
    // Save to cache
    _storageService.saveActivities(_activities);
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
