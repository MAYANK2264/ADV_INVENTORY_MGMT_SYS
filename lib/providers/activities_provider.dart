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

    // Load demo data immediately for demo purposes
    print('Loading demo activities...');
    _loadDemoActivities();
    print('Demo activities loaded: ${_activities.length} activities');
    _isLoading = false;
    notifyListeners();
    return;

    // Original API logic (commented out for demo)
    /*
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
        // Cache also failed, load demo data
        _loadDemoActivities();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    */
  }

  // Add new activity (for local tracking)
  void addActivity(Activity activity) {
    _activities.insert(0, activity);
    notifyListeners();
    
    // Save to cache
    _storageService.saveActivities(_activities);
  }

  // Load demo activities when API is not available
  void _loadDemoActivities() {
    _activities = [
      Activity(
        id: '1',
        text: 'iPhone 15 Pro Max moved to Block A, Rack R1, Slot 1',
        time: '2 minutes ago',
        type: 'move',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Activity(
        id: '2',
        text: 'Hydraulic Pump Unit processed for dispatch',
        time: '5 minutes ago',
        type: 'dispatch',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Activity(
        id: '3',
        text: 'New electronics shipment arrived - 15 items',
        time: '12 minutes ago',
        type: 'arrival',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      Activity(
        id: '4',
        text: 'System maintenance completed - All systems operational',
        time: '1 hour ago',
        type: 'system',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Activity(
        id: '5',
        text: 'Medical supplies inventory updated',
        time: '2 hours ago',
        type: 'inventory',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Activity(
        id: '6',
        text: 'Samsung Galaxy S24 added to inventory',
        time: '3 hours ago',
        type: 'arrival',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      Activity(
        id: '7',
        text: 'MacBook Pro 16" quality check completed',
        time: '4 hours ago',
        type: 'inventory',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Activity(
        id: '8',
        text: 'Industrial equipment batch processed',
        time: '5 hours ago',
        type: 'dispatch',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
