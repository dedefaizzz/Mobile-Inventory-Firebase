import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory_firebase/controllers/DatabaseController.dart';
import 'package:mobile_inventory_firebase/models/item_model.dart';

class AddHistoryPage extends StatefulWidget {
  final Item item;
  const AddHistoryPage({super.key, required this.item});

  @override
  State<AddHistoryPage> createState() => _AddHistoryPageState();
}

class _AddHistoryPageState extends State<AddHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _transactionType = 'Masuk';
  final _quantityController = TextEditingController();
  final dbController = DatabaseController.instance;

  Future<void> saveHistory() async {
    if (_formKey.currentState!.validate()) {
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      final isIncoming = _transactionType == 'Masuk';

      // update stok barang
      final newStock = widget.item.stock + (isIncoming ? quantity : -quantity);
      if (newStock < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stok tidak mencukupi!')),
        );
        return;
      }

      try {
        final firestore = FirebaseFirestore.instance;

        // Update stok barang
        await firestore.collection('items').doc(widget.item.id).update({
          'stock': newStock,
        });

        // Simpan riwayat transaksi
        await firestore.collection('history').add({
          'itemId': widget.item.id,
          'type': _transactionType,
          'quantity': quantity,
          'dateTime': DateTime.now().toIso8601String(),
        });
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Riwayat Barang')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _transactionType,
                items: const [
                  DropdownMenuItem(value: 'Masuk', child: Text('Masuk')),
                  DropdownMenuItem(value: 'Keluar', child: Text('Keluar')),
                ],
                onChanged: (value) => setState(() {
                  _transactionType = value!;
                }),
                decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah wajib diisi';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Jumlah harus lebih dari 0';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: saveHistory,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
