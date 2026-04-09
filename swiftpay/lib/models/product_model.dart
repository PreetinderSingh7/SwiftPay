class Product {
  final String id;
  final String barcode;
  final String name;
  final double price;
  final String category;
  final int stockCount;
  final double taxRate;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.category,
    required this.stockCount,
    required this.taxRate,
    this.imageUrl = '',
    this.description = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      stockCount: json['stockCount'] ?? 0,
      taxRate: (json['taxRate'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }
}