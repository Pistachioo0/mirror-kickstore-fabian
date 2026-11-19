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


      factory ProductModel.fromJson(Map<String, dynamic> json) {
  final rawId = json['id'];
  final id = rawId != null
      ? rawId.toString()
      : 'prod-${DateTime.now().millisecondsSinceEpoch}';

  final name = (json['title'] ?? json['name'] ?? 'Sepatu Sneakers').toString();
  final rawCategory = (json['category'] ?? 'Lifestyle').toString();
  final category = rawCategory.isNotEmpty
      ? '${rawCategory[0].toUpperCase()}${rawCategory.substring(1)}'
      : 'General';

  // Konversi USD ke IDR: jika < 1000, kalikan 15.000
  final rawPrice = (json['price'] as num?)?.toInt() ?? 150000;
  final price = rawPrice < 1000 ? rawPrice * 15000 : rawPrice;

  final rating = (json['rating'] as num?)?.toDouble() ?? 4.8;
  final imageUrl = (json['thumbnail'] ??
          json['imageUrl'] ??
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff')
      .toString();
  final description = (json['description'] ?? 'Sepatu sneakers berkualitas tinggi.').toString();

  return ProductModel(
    id: id,
    name: name,
    category: category,
    price: price,
    rating: rating,
    imageUrl: imageUrl,
    description: description,
  );
}
}