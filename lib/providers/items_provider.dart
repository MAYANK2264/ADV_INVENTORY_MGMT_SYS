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
        // Cache also failed, load demo data
        _loadDemoData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load demo data when API is not available
  void _loadDemoData() {
    _items = [
      // Electronics
      Item(
        id: '1',
        name: 'iPhone 15 Pro Max',
        manufacturer: 'Apple',
        barcode: 'APPLE001234567',
        size: 'L',
        weight: 0.24,
        arrivalDate: DateTime(2025, 1, 15),
        expiryDate: DateTime(2027, 1, 15),
        locationBlock: 'A',
        locationRack: 'R1',
        locationSlot: 1,
        status: 'stored',
        category: 'Electronics',
      ),
      Item(
        id: '2',
        name: 'Samsung Galaxy S24',
        manufacturer: 'Samsung',
        barcode: 'SAMS001234567',
        size: 'L',
        weight: 0.23,
        arrivalDate: DateTime(2025, 1, 16),
        expiryDate: DateTime(2027, 1, 16),
        locationBlock: 'A',
        locationRack: 'R1',
        locationSlot: 2,
        status: 'stored',
        category: 'Electronics',
      ),
      Item(
        id: '3',
        name: 'MacBook Pro 16"',
        manufacturer: 'Apple',
        barcode: 'APPLE001234568',
        size: 'XL',
        weight: 2.1,
        arrivalDate: DateTime(2025, 1, 17),
        expiryDate: DateTime(2027, 1, 17),
        locationBlock: 'A',
        locationRack: 'R2',
        locationSlot: 1,
        status: 'stored',
        category: 'Electronics',
      ),
      Item(
        id: '4',
        name: 'Dell XPS 15',
        manufacturer: 'Dell',
        barcode: 'DELL001234567',
        size: 'XL',
        weight: 1.8,
        arrivalDate: DateTime(2025, 1, 18),
        expiryDate: DateTime(2027, 1, 18),
        locationBlock: 'A',
        locationRack: 'R2',
        locationSlot: 2,
        status: 'stored',
        category: 'Electronics',
      ),
      Item(
        id: '5',
        name: 'AirPods Pro',
        manufacturer: 'Apple',
        barcode: 'APPLE001234569',
        size: 'S',
        weight: 0.06,
        arrivalDate: DateTime(2025, 1, 19),
        expiryDate: DateTime(2027, 1, 19),
        locationBlock: 'A',
        locationRack: 'R3',
        locationSlot: 1,
        status: 'stored',
        category: 'Electronics',
      ),
      
      // Industrial
      Item(
        id: '6',
        name: 'Hydraulic Pump Unit',
        manufacturer: 'Caterpillar',
        barcode: 'CAT001234567',
        size: 'XL',
        weight: 45.2,
        arrivalDate: DateTime(2025, 1, 20),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'B',
        locationRack: 'R1',
        locationSlot: 1,
        status: 'stored',
        category: 'Industrial',
      ),
      Item(
        id: '7',
        name: 'Steel Bearing Set',
        manufacturer: 'SKF',
        barcode: 'SKF001234567',
        size: 'M',
        weight: 2.3,
        arrivalDate: DateTime(2025, 1, 21),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'B',
        locationRack: 'R1',
        locationSlot: 2,
        status: 'stored',
        category: 'Industrial',
      ),
      Item(
        id: '8',
        name: 'Industrial Sensor',
        manufacturer: 'Honeywell',
        barcode: 'HONE001234567',
        size: 'S',
        weight: 0.8,
        arrivalDate: DateTime(2025, 1, 22),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'B',
        locationRack: 'R2',
        locationSlot: 1,
        status: 'stored',
        category: 'Industrial',
      ),
      Item(
        id: '9',
        name: 'Control Valve',
        manufacturer: 'Emerson',
        barcode: 'EMER001234567',
        size: 'L',
        weight: 5.7,
        arrivalDate: DateTime(2025, 1, 23),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'B',
        locationRack: 'R2',
        locationSlot: 2,
        status: 'stored',
        category: 'Industrial',
      ),
      Item(
        id: '10',
        name: 'Motor Assembly',
        manufacturer: 'Siemens',
        barcode: 'SIEM001234567',
        size: 'XL',
        weight: 28.4,
        arrivalDate: DateTime(2025, 1, 24),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'B',
        locationRack: 'R3',
        locationSlot: 1,
        status: 'stored',
        category: 'Industrial',
      ),
      
      // Automotive
      Item(
        id: '11',
        name: 'Brake Pad Set',
        manufacturer: 'Brembo',
        barcode: 'BREM001234567',
        size: 'M',
        weight: 1.2,
        arrivalDate: DateTime(2025, 1, 25),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'C',
        locationRack: 'R1',
        locationSlot: 1,
        status: 'stored',
        category: 'Automotive',
      ),
      Item(
        id: '12',
        name: 'Oil Filter',
        manufacturer: 'Mann-Filter',
        barcode: 'MANN001234567',
        size: 'S',
        weight: 0.3,
        arrivalDate: DateTime(2025, 1, 26),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'C',
        locationRack: 'R1',
        locationSlot: 2,
        status: 'stored',
        category: 'Automotive',
      ),
      Item(
        id: '13',
        name: 'Spark Plug Set',
        manufacturer: 'NGK',
        barcode: 'NGK001234567',
        size: 'S',
        weight: 0.2,
        arrivalDate: DateTime(2025, 1, 27),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'C',
        locationRack: 'R2',
        locationSlot: 1,
        status: 'stored',
        category: 'Automotive',
      ),
      Item(
        id: '14',
        name: 'Timing Belt',
        manufacturer: 'Gates',
        barcode: 'GATE001234567',
        size: 'M',
        weight: 0.9,
        arrivalDate: DateTime(2025, 1, 28),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'C',
        locationRack: 'R2',
        locationSlot: 2,
        status: 'stored',
        category: 'Automotive',
      ),
      Item(
        id: '15',
        name: 'Air Filter',
        manufacturer: 'K&N',
        barcode: 'KN001234567',
        size: 'M',
        weight: 0.4,
        arrivalDate: DateTime(2025, 1, 29),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'C',
        locationRack: 'R3',
        locationSlot: 1,
        status: 'stored',
        category: 'Automotive',
      ),
      
      // Medical
      Item(
        id: '16',
        name: 'Surgical Gloves (Box)',
        manufacturer: 'Medline',
        barcode: 'MEDL001234567',
        size: 'M',
        weight: 0.5,
        arrivalDate: DateTime(2025, 1, 30),
        expiryDate: DateTime(2026, 6, 30),
        locationBlock: 'D',
        locationRack: 'R1',
        locationSlot: 1,
        status: 'stored',
        category: 'Medical',
      ),
      Item(
        id: '17',
        name: 'Bandage Roll',
        manufacturer: 'Johnson & Johnson',
        barcode: 'JNJ001234567',
        size: 'S',
        weight: 0.1,
        arrivalDate: DateTime(2025, 1, 31),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'D',
        locationRack: 'R1',
        locationSlot: 2,
        status: 'stored',
        category: 'Medical',
      ),
      Item(
        id: '18',
        name: 'Thermometer Digital',
        manufacturer: 'Omron',
        barcode: 'OMRO001234567',
        size: 'S',
        weight: 0.15,
        arrivalDate: DateTime(2025, 2, 1),
        expiryDate: DateTime(2027, 2, 1),
        locationBlock: 'D',
        locationRack: 'R2',
        locationSlot: 1,
        status: 'stored',
        category: 'Medical',
      ),
      Item(
        id: '19',
        name: 'Syringe 10ml',
        manufacturer: 'BD',
        barcode: 'BD001234567',
        size: 'S',
        weight: 0.05,
        arrivalDate: DateTime(2025, 2, 2),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'D',
        locationRack: 'R2',
        locationSlot: 2,
        status: 'stored',
        category: 'Medical',
      ),
      Item(
        id: '20',
        name: 'Face Mask (Box)',
        manufacturer: '3M',
        barcode: '3M001234567',
        size: 'M',
        weight: 0.8,
        arrivalDate: DateTime(2025, 2, 3),
        expiryDate: DateTime(2026, 12, 31),
        locationBlock: 'D',
        locationRack: 'R3',
        locationSlot: 1,
        status: 'stored',
        category: 'Medical',
      ),
      
      // Food & Beverage
      Item(
        id: '21',
        name: 'Energy Drink (Case)',
        manufacturer: 'Red Bull',
        barcode: 'REDB001234567',
        size: 'L',
        weight: 8.5,
        arrivalDate: DateTime(2025, 2, 4),
        expiryDate: DateTime(2025, 8, 4),
        locationBlock: 'E',
        locationRack: 'R1',
        locationSlot: 1,
        status: 'stored',
        category: 'Food & Beverage',
      ),
      Item(
        id: '22',
        name: 'Protein Bar (Box)',
        manufacturer: 'Quest',
        barcode: 'QUES001234567',
        size: 'M',
        weight: 2.1,
        arrivalDate: DateTime(2025, 2, 5),
        expiryDate: DateTime(2025, 11, 5),
        locationBlock: 'E',
        locationRack: 'R1',
        locationSlot: 2,
        status: 'stored',
        category: 'Food & Beverage',
      ),
      Item(
        id: '23',
        name: 'Coffee Beans (Bag)',
        manufacturer: 'Starbucks',
        barcode: 'STAR001234567',
        size: 'L',
        weight: 2.3,
        arrivalDate: DateTime(2025, 2, 6),
        expiryDate: DateTime(2025, 12, 6),
        locationBlock: 'E',
        locationRack: 'R2',
        locationSlot: 1,
        status: 'stored',
        category: 'Food & Beverage',
      ),
      Item(
        id: '24',
        name: 'Water Bottle (Case)',
        manufacturer: 'Fiji',
        barcode: 'FIJI001234567',
        size: 'L',
        weight: 12.0,
        arrivalDate: DateTime(2025, 2, 7),
        expiryDate: DateTime(2026, 2, 7),
        locationBlock: 'E',
        locationRack: 'R2',
        locationSlot: 2,
        status: 'stored',
        category: 'Food & Beverage',
      ),
      Item(
        id: '25',
        name: 'Snack Mix (Box)',
        manufacturer: 'Trail Mix Co',
        barcode: 'TRAI001234567',
        size: 'M',
        weight: 1.8,
        arrivalDate: DateTime(2025, 2, 8),
        expiryDate: DateTime(2025, 10, 8),
        locationBlock: 'E',
        locationRack: 'R3',
        locationSlot: 1,
        status: 'stored',
        category: 'Food & Beverage',
      ),
    ];
    _applyFilters();
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
