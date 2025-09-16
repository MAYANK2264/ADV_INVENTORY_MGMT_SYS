class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://script.google.com/macros/s/AKfycbyUvCgMa3qL2yEjf7OH6YGN2LvKgfsuh4qaBSGtePjPSYYoIIoYMqmiiPCKZ-dh5J7G/exec';
  static const String apiVersion = 'v1';
  
  // API Endpoints
  static const String itemsEndpoint = '/api/items';
  static const String statsEndpoint = '/api/stats';
  static const String activitiesEndpoint = '/api/activities';
  static const String racksEndpoint = '/api/racks';
  static const String searchEndpoint = '/api/search';
  
  // Warehouse Configuration
  static const int totalBlocks = 5;
  static const int racksPerBlock = 3;
  static const int slotsPerRack = 8;
  static const int totalSlots = totalBlocks * racksPerBlock * slotsPerRack;
  
  // Block Names
  static const List<String> blockNames = ['A', 'B', 'C', 'D', 'E'];
  
  // Rack Names
  static const List<String> rackNames = ['R1', 'R2', 'R3'];
  
  // Categories
  static const List<String> categories = [
    'Electronics',
    'Industrial',
    'Automotive',
    'Medical',
    'Food & Beverage',
  ];
  
  // Item Sizes
  static const List<String> itemSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  
  // Item Status
  static const List<String> itemStatuses = [
    'stored',
    'in_transit',
    'processing',
    'dispatched',
    'maintenance',
  ];
  
  // Refresh Intervals
  static const Duration dashboardRefreshInterval = Duration(seconds: 10);
  static const Duration dataRefreshInterval = Duration(seconds: 30);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double largeRadius = 16.0;
  
  // Grid Configuration
  static const int itemsPerRow = 2;
  static const double itemAspectRatio = 0.8;
  
  // Search Configuration
  static const int minSearchLength = 2;
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  // Storage Keys
  static const String lastSyncKey = 'last_sync';
  static const String offlineDataKey = 'offline_data';
  static const String userPreferencesKey = 'user_preferences';
  
  // Error Messages
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String noDataError = 'No data available';
  
  // Success Messages
  static const String itemAddedSuccess = 'Item added successfully';
  static const String itemUpdatedSuccess = 'Item updated successfully';
  static const String itemDeletedSuccess = 'Item deleted successfully';
  static const String dataSyncedSuccess = 'Data synced successfully';
}
