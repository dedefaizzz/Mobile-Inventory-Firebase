import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Supplier'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('suppliers').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada supplier.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final supplier = snapshot.data!.docs[index];
              return ListTile(
                title: Text(supplier['name']),
                subtitle: Text(supplier['address']),
                onTap: () =>
                    Get.toNamed('/supplier-detail', arguments: supplier),
              );
            },
          );
        },
      ),
    );
  }
}
