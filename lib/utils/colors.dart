import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF22D3EE); // Cyan
  static const Color secondary = Color(0xFF10B981); // Emerald
  
  // Background Colors
  static const Color background = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0x1AFFFFFF); // White with 10% opacity
  
  // Category Colors
  static const Color electronics = Color(0xFF3B82F6); // Blue
  static const Color industrial = Color(0xFFF97316); // Orange
  static const Color automotive = Color(0xFFEF4444); // Red
  static const Color medical = Color(0xFF10B981); // Green
  static const Color foodBeverage = Color(0xFFEAB308); // Yellow
  
  // Status Colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue
  
  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFF9CA3AF);
  static const Color darkGrey = Color(0xFF374151);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF22D3EE),
    Color(0xFF06B6D4),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFF0F172A), // Slate 900
    Color(0xFF1E1B4B), // Indigo 900
  ];
  
  static const List<Color> surfaceGradient = [
    Color(0x1AFFFFFF), // White 10%
    Color(0x0DFFFFFF), // White 5%
  ];
  
  // Get category color by name
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return electronics;
      case 'industrial':
        return industrial;
      case 'automotive':
        return automotive;
      case 'medical':
        return medical;
      case 'food & beverage':
        return foodBeverage;
      default:
        return grey;
    }
  }
  
  // Get category icon by name
  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.devices_rounded;
      case 'industrial':
        return Icons.precision_manufacturing_rounded;
      case 'automotive':
        return Icons.directions_car_rounded;
      case 'medical':
        return Icons.medical_services_rounded;
      case 'food & beverage':
        return Icons.restaurant_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
