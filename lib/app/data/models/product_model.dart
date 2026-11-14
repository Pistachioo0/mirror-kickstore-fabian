class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final String imageUrl;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.description = '',
  });

  String get formattedPrice {
    final formatted = price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      name: map['title'] ?? map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image'] ?? map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': name,
        'category': category,
        'price': price,
        'rating': rating,
        'image': imageUrl,
        'description': description,
      };
}