import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed('/items'),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Total Barang'),
                  subtitle: const Text('Klik untuk melihat daftar barang'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Get.toNamed('/suppliers'),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Jumlah Supplier'),
                  subtitle: const Text('Klik untuk melihat daftar supplier'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
