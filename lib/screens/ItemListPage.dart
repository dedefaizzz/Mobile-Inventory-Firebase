import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mobile_inventory_firebase/models/item_model.dart';
import 'package:mobile_inventory_firebase/screens/AddItemPage.dart';
import 'package:mobile_inventory_firebase/screens/ItemDetailPage.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Item>> fetchItems() async {
    try {
      final snapshot = await _firestore.collection('items').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Item(
          id: doc.id, // Gunakan ID Firestore sebagai String
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          category: data['category'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          stock: data['stock'] ?? 0,
          imagePath: data['imagePath'], // Gunakan link URL gambar jika ada
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching items: $e');
      return [];
    }
  }

  Future<Uint8List> compressImage(Uint8List imageData) async {
    return await FlutterImageCompress.compressWithList(
      imageData,
      quality: 85, // Kompres kualitas gambar ke 85%
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang'),
      ),
      body: FutureBuilder<List<Item>>(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada barang'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: item.imagePath != null
                    ? Image.network(
                        item.imagePath! as String,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      )
                    : const Icon(Icons.image_not_supported),
                title: Text(item.name),
                subtitle:
                    Text('Kategori: ${item.category}, Stok: ${item.stock}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailPage(item: item),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
          if (result == true) {
            setState(() {}); // Refresh UI setelah kembali dari AddItemPage.
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
