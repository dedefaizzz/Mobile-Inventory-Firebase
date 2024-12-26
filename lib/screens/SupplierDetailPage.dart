import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SupplierDetailPage extends StatelessWidget {
  const SupplierDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supplier = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${supplier['name']}'),
            Text('Alamat: ${supplier['address']}'),
            Text('Kontak: ${supplier['contact']}'),
            Text(
                'Koordinat: ${supplier['location']['latitude']}, ${supplier['location']['longitude']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final url =
                    'https://www.google.com/maps?q=${supplier['location']['latitude']},${supplier['location']['longitude']}';
                launch(url);
              },
              child: Text('Lihat di Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}
