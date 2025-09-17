import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import '../models/activity.dart';
import '../models/system_stats.dart';
import '../utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.baseUrl;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Items API
  Future<List<Item>> getItems() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.itemsEndpoint}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Item.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Item?> getItem(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.itemsEndpoint}&id=$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Item.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Item> createItem(Item item) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.itemsEndpoint}&action=create'),
        headers: _headers,
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Item.fromJson(data);
      } else {
        throw Exception('Failed to create item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Item> updateItem(String id, Item item) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.itemsEndpoint}&action=update&id=$id'),
        headers: _headers,
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Item.fromJson(data);
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.itemsEndpoint}&action=delete&id=$id'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // System Stats API
  Future<SystemStats> getSystemStats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.statsEndpoint}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SystemStats.fromJson(data);
      } else {
        throw Exception('Failed to load system stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Activities API
  Future<List<Activity>> getActivities() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.activitiesEndpoint}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Rack Occupancy API
  Future<Map<String, dynamic>> getRackOccupancy() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.racksEndpoint}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load rack occupancy: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Search API
  Future<List<Item>> searchItems(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.searchEndpoint}'),
        headers: _headers,
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Item.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Helper method to check network connectivity
  Future<bool> isConnected() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl&endpoint=${AppConstants.statsEndpoint}'),
        headers: _headers,
      ).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
