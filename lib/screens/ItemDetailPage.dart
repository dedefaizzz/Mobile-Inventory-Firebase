import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory_firebase/colors.dart';
import 'package:mobile_inventory_firebase/controllers/DatabaseController.dart';
import 'package:mobile_inventory_firebase/models/item_model.dart';
import 'package:mobile_inventory_firebase/screens/AddHistoryPage.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;
  const ItemDetailPage({super.key, required this.item});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final DatabaseController dbController = DatabaseController.instance;
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final firestore = FirebaseFirestore.instance;
    try {
      final result = await firestore
          .collection('history')
          .where('itemId', isEqualTo: widget.item.id)
          .orderBy('dateTime', descending: true)
          .get();

      setState(() {
        history = result.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      debugPrint('Error fetching history: $e');
    }
  }

  Future<void> deleteItem() async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Hapus item
      await firestore.collection('items').doc(widget.item.id).delete();

      // Hapus riwayat yang terkait
      final historyDocs = await firestore
          .collection('history')
          .where('itemId', isEqualTo: widget.item.id)
          .get();
      for (var doc in historyDocs.docs) {
        await doc.reference.delete();
      }

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.item.name)),
      body: Column(
        children: [
          ListTile(
            leading: widget.item.imagePath != null
                ? Image.memory(widget.item.imagePath!)
                : const Icon(Icons.image),
            title: Text(widget.item.name),
            subtitle: Text(widget.item.description),
            trailing: Text('Stok: ${widget.item.stock}'),
          ),
          const Divider(),
          const Text('Riwayat Stok', style: TextStyle(fontSize: 18)),
          Expanded(
            child: history.isEmpty
                ? const Center(child: Text('Belum ada riwayat stok'))
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final record = history[index];
                      return ListTile(
                        title: Text(
                          '${record['type']} (${record['quantity']})',
                        ),
                        subtitle: Text(record['date']),
                      );
                    },
                  ),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHistoryPage(item: widget.item),
                ),
              );
              if (result == true) fetchHistory();
            },
            child: const Text('Tambah Riwayat'),
          ),
          ElevatedButton(
            onPressed: deleteItem,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deleteColor),
            child: const Text('Hapus Barang'),
          ),
        ],
      ),
    );
  }
}
