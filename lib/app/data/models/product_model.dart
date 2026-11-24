import 'package:hive_ce/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final int reviewCount;

  @HiveField(6)
  final String imageUrl;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    this.reviewCount = 0,
    required this.imageUrl,
    this.description = '',
    this.isFavorite = false,
  });

  String get formattedPrice {
    final formatted = price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
    return 'Rp $formatted';
  }

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

    final rawPrice = (json['price'] as num?)?.toInt() ?? 150000;
    final price = rawPrice < 1000 ? rawPrice * 15000 : rawPrice;

    final rating = (json['rating'] as num?)?.toDouble() ?? 4.8;
    final imageUrl = (json['thumbnail'] ??
            json['imageUrl'] ??
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff')
        .toString();
    final description =
        (json['description'] ?? 'Sepatu sneakers berkualitas tinggi.')
            .toString();

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

  ProductModel copyWith({bool? isFavorite}) {
    return ProductModel(
      id: id,
      name: name,
      category: category,
      price: price,
      rating: rating,
      reviewCount: reviewCount,
      imageUrl: imageUrl,
      description: description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
