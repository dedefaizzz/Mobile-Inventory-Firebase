import 'dart:convert';
import 'dart:typed_data';

class Item {
  final String? id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final Uint8List? imagePath;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.stock = 0,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'stock': stock,
        'imagePath': imagePath != null ? base64Encode(imagePath!) : null,
      };

  static Item fromJson(Map<String, dynamic> json) => Item(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        // price: json['price'],
        // stock: json['stock'],
        price: (json['price'] as num).toDouble(),
        stock: (json['stock'] as num).toInt(),
        imagePath: json['imagePath'] is String
            ? base64Decode(json['imagePath'])
            : null,

        // imagePath: json['imagePath'] is String
        //     ? base64Decode(json['imagePath'])
        //     : json['imagePath'] as Uint8List?,
      );
}
