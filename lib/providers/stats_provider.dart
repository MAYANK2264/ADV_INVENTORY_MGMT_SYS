import 'package:flutter/foundation.dart';
import '../models/system_stats.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class StatsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  SystemStats? _stats;
  Map<String, dynamic> _rackOccupancy = {};
  bool _isLoading = false;
  String _error = '';

  // Getters
  SystemStats? get stats => _stats;
  Map<String, dynamic> get rackOccupancy => _rackOccupancy;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Load system statistics
  Future<void> loadStats({bool forceRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    // Load demo data immediately for demo purposes
    print('Loading demo stats...');
    _loadDemoStats();
    print('Demo stats loaded: ${_stats?.totalItems} items, ${_rackOccupancy.length} blocks');
    _isLoading = false;
    notifyListeners();
    return;

    // Original API logic (commented out for demo)
    /*
    try {
      // Check if we should use cached data
      if (!forceRefresh && !await _storageService.isDataStale()) {
        final cachedStats = await _storageService.getCachedSystemStats();
        final cachedOccupancy = await _storageService.getCachedRackOccupancy();
        
        if (cachedStats != null) {
          _stats = cachedStats;
        }
        if (cachedOccupancy != null) {
          _rackOccupancy = cachedOccupancy;
        }
        
        if (_stats != null) {
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Fetch from API
      final stats = await _apiService.getSystemStats();
      final occupancy = await _apiService.getRackOccupancy();
      
      _stats = stats;
      _rackOccupancy = occupancy;
      
      // Cache the data
      await _storageService.saveSystemStats(stats);
      await _storageService.saveRackOccupancy(occupancy);
      
    } catch (e) {
      _error = e.toString();
      
      // Try to load from cache as fallback
      try {
        final cachedStats = await _storageService.getCachedSystemStats();
        final cachedOccupancy = await _storageService.getCachedRackOccupancy();
        
        if (cachedStats != null) {
          _stats = cachedStats;
        }
        if (cachedOccupancy != null) {
          _rackOccupancy = cachedOccupancy;
        }
      } catch (cacheError) {
        // Cache also failed, load demo data
        _loadDemoStats();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    */
  }

  // Get occupancy for specific block
  Map<String, dynamic> getBlockOccupancy(String block) {
    return _rackOccupancy[block] ?? {};
  }

  // Get occupancy for specific rack
  Map<String, dynamic> getRackOccupancy(String block, String rack) {
    final blockData = getBlockOccupancy(block);
    return blockData[rack] ?? {};
  }

  // Get slot status
  bool isSlotOccupied(String block, String rack, int slot) {
    final rackData = getRackOccupancy(block, rack);
    return rackData['slots']?[slot.toString()] == true;
  }

  // Get occupancy percentage for block
  double getBlockOccupancyPercentage(String block) {
    final blockData = getBlockOccupancy(block);
    int occupiedSlots = 0;
    int totalSlots = 0;
    
    for (final rack in blockData.keys) {
      final rackData = blockData[rack];
      if (rackData != null && rackData['slots'] != null) {
        final slots = rackData['slots'] as Map<String, dynamic>;
        totalSlots += slots.length;
        occupiedSlots += slots.values.where((occupied) => occupied == true).length;
      }
    }
    
    if (totalSlots == 0) return 0.0;
    return (occupiedSlots / totalSlots) * 100;
  }

  // Get occupancy percentage for rack
  double getRackOccupancyPercentage(String block, String rack) {
    final rackData = getRackOccupancy(block, rack);
    final slots = rackData['slots'] as Map<String, dynamic>?;
    
    if (slots == null || slots.isEmpty) return 0.0;
    
    final occupiedSlots = slots.values.where((occupied) => occupied == true).length;
    return (occupiedSlots / slots.length) * 100;
  }

  // Load demo stats when API is not available
  void _loadDemoStats() {
    _stats = SystemStats(
      capacity: 120,
      itemsProcessed: 25,
      uptime: '99.9%',
      totalItems: 25,
      availableSlots: 95,
      occupiedSlots: 25,
      lastUpdated: DateTime.now(),
    );

    // Generate demo rack occupancy data
    _rackOccupancy = {
      'A': {
        'R1': {
          'slots': {
            '1': true,  // iPhone 15 Pro Max
            '2': true,  // Samsung Galaxy S24
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R2': {
          'slots': {
            '1': true,  // MacBook Pro 16"
            '2': true,  // Dell XPS 15
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R3': {
          'slots': {
            '1': true,  // AirPods Pro
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        }
      },
      'B': {
        'R1': {
          'slots': {
            '1': true,  // Hydraulic Pump Unit
            '2': true,  // Steel Bearing Set
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R2': {
          'slots': {
            '1': true,  // Industrial Sensor
            '2': true,  // Control Valve
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R3': {
          'slots': {
            '1': true,  // Motor Assembly
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        }
      },
      'C': {
        'R1': {
          'slots': {
            '1': true,  // Brake Pad Set
            '2': true,  // Oil Filter
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R2': {
          'slots': {
            '1': true,  // Spark Plug Set
            '2': true,  // Timing Belt
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R3': {
          'slots': {
            '1': true,  // Air Filter
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        }
      },
      'D': {
        'R1': {
          'slots': {
            '1': true,  // Surgical Gloves
            '2': true,  // Bandage Roll
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R2': {
          'slots': {
            '1': true,  // Thermometer Digital
            '2': true,  // Syringe 10ml
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R3': {
          'slots': {
            '1': true,  // Face Mask
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        }
      },
      'E': {
        'R1': {
          'slots': {
            '1': true,  // Energy Drink
            '2': true,  // Protein Bar
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R2': {
          'slots': {
            '1': true,  // Coffee Beans
            '2': true,  // Water Bottle
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        },
        'R3': {
          'slots': {
            '1': true,  // Snack Mix
            '2': false,
            '3': false,
            '4': false,
            '5': false,
            '6': false,
            '7': false,
            '8': false,
          }
        }
      }
    };
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
