class Item {
  final String id;
  final String name;
  final String manufacturer;
  final String barcode;
  final String size;
  final double weight;
  final DateTime arrivalDate;
  final DateTime expiryDate;
  final String locationBlock;
  final String locationRack;
  final int locationSlot;
  final String status;
  final String category;

  Item({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.barcode,
    required this.size,
    required this.weight,
    required this.arrivalDate,
    required this.expiryDate,
    required this.locationBlock,
    required this.locationRack,
    required this.locationSlot,
    required this.status,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['ID'] ?? '',
      name: json['Name'] ?? '',
      manufacturer: json['Manufacturer'] ?? '',
      barcode: json['Barcode'] ?? '',
      size: json['Size'] ?? '',
      weight: double.tryParse(json['Weight'].toString()) ?? 0.0,
      arrivalDate: DateTime.tryParse(json['Arrival_Date']) ?? DateTime.now(),
      expiryDate: DateTime.tryParse(json['Expiry_Date']) ?? DateTime.now(),
      locationBlock: json['Location_Block'] ?? '',
      locationRack: json['Location_Rack'] ?? '',
      locationSlot: int.tryParse(json['Location_Slot'].toString()) ?? 0,
      status: json['Status'] ?? '',
      category: json['Category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Name': name,
      'Manufacturer': manufacturer,
      'Barcode': barcode,
      'Size': size,
      'Weight': weight,
      'Arrival_Date': arrivalDate.toIso8601String().split('T')[0],
      'Expiry_Date': expiryDate.toIso8601String().split('T')[0],
      'Location_Block': locationBlock,
      'Location_Rack': locationRack,
      'Location_Slot': locationSlot,
      'Status': status,
      'Category': category,
    };
  }

  Item copyWith({
    String? id,
    String? name,
    String? manufacturer,
    String? barcode,
    String? size,
    double? weight,
    DateTime? arrivalDate,
    DateTime? expiryDate,
    String? locationBlock,
    String? locationRack,
    int? locationSlot,
    String? status,
    String? category,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      barcode: barcode ?? this.barcode,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      expiryDate: expiryDate ?? this.expiryDate,
      locationBlock: locationBlock ?? this.locationBlock,
      locationRack: locationRack ?? this.locationRack,
      locationSlot: locationSlot ?? this.locationSlot,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }

  String get fullLocation => '$locationBlock-$locationRack-$locationSlot';
  
  bool get isExpired => DateTime.now().isAfter(expiryDate);
  
  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }
}
