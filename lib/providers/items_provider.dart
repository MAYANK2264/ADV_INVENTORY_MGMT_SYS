import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ItemsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Item> _items = [];
  List<Item> _filteredItems = [];
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedBlock = '';
  String _sortBy = 'name';
  bool _sortAscending = true;

  // Getters
  List<Item> get items => _items;
  List<Item> get filteredItems => _filteredItems;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedBlock => _selectedBlock;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;

  // Statistics
  int get totalItems => _items.length;
  int get electronicsCount => _items.where((item) => item.category.toLowerCase() == 'electronics').length;
  int get industrialCount => _items.where((item) => item.category.toLowerCase() == 'industrial').length;
  int get automotiveCount => _items.where((item) => item.category.toLowerCase() == 'automotive').length;
  int get medicalCount => _items.where((item) => item.category.toLowerCase() == 'medical').length;
  int get foodBeverageCount => _items.where((item) => item.category.toLowerCase() == 'food & beverage').length;

  // Initialize and load items
  Future<void> loadItems({bool forceRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Check if we should use cached data
      if (!forceRefresh && !await _storageService.isDataStale()) {
        final cachedItems = await _storageService.getCachedItems();
        if (cachedItems.isNotEmpty) {
          _items = cachedItems;
          _applyFilters();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // Fetch from API
      final items = await _apiService.getItems();
      _items = items;
      
      // Cache the data
      await _storageService.saveItems(items);
      
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      
      // Try to load from cache as fallback
      try {
        final cachedItems = await _storageService.getCachedItems();
        if (cachedItems.isNotEmpty) {
          _items = cachedItems;
          _applyFilters();
        }
      } catch (cacheError) {
        // Cache also failed, keep the error
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new item
  Future<bool> addItem(Item item) async {
    try {
      _isLoading = true;
      notifyListeners();

      final newItem = await _apiService.createItem(item);
      _items.add(newItem);
      await _storageService.saveItems(_items);
      _applyFilters();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update item
  Future<bool> updateItem(String id, Item item) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedItem = await _apiService.updateItem(id, item);
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = updatedItem;
        await _storageService.saveItems(_items);
        _applyFilters();
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete item
  Future<bool> deleteItem(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      await _storageService.saveItems(_items);
      _applyFilters();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search items
  Future<void> searchItems(String query) async {
    _searchQuery = query;
    _applyFilters();
    
    if (query.length >= AppConstants.minSearchLength) {
      try {
        final searchResults = await _apiService.searchItems(query);
        _filteredItems = searchResults;
        notifyListeners();
      } catch (e) {
        // Fallback to local search
        _applyFilters();
      }
    } else {
      _applyFilters();
    }
  }

  // Set category filter
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Set block filter
  void setBlockFilter(String block) {
    _selectedBlock = block;
    _applyFilters();
  }

  // Set sort options
  void setSortOptions(String sortBy, bool ascending) {
    _sortBy = sortBy;
    _sortAscending = ascending;
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = '';
    _selectedBlock = '';
    _sortBy = 'name';
    _sortAscending = true;
    _applyFilters();
  }

  // Apply filters and sorting
  void _applyFilters() {
    List<Item> filtered = List.from(_items);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               item.manufacturer.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               item.barcode.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory.isNotEmpty) {
      filtered = filtered.where((item) => 
        item.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Apply block filter
    if (_selectedBlock.isNotEmpty) {
      filtered = filtered.where((item) => 
        item.locationBlock == _selectedBlock).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'manufacturer':
          comparison = a.manufacturer.compareTo(b.manufacturer);
          break;
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        case 'arrival_date':
          comparison = a.arrivalDate.compareTo(b.arrivalDate);
          break;
        case 'expiry_date':
          comparison = a.expiryDate.compareTo(b.expiryDate);
          break;
        case 'weight':
          comparison = a.weight.compareTo(b.weight);
          break;
        case 'location':
          comparison = a.fullLocation.compareTo(b.fullLocation);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      
      return _sortAscending ? comparison : -comparison;
    });

    _filteredItems = filtered;
    notifyListeners();
  }

  // Get item by ID
  Item? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get items by location
  List<Item> getItemsByLocation(String block, String rack, int slot) {
    return _items.where((item) => 
      item.locationBlock == block && 
      item.locationRack == rack && 
      item.locationSlot == slot).toList();
  }

  // Get items by category
  List<Item> getItemsByCategory(String category) {
    return _items.where((item) => 
      item.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Get expired items
  List<Item> getExpiredItems() {
    return _items.where((item) => item.isExpired).toList();
  }

  // Get items expiring soon
  List<Item> getItemsExpiringSoon() {
    return _items.where((item) => item.isExpiringSoon).toList();
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
