import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class AddSupplierPage extends StatefulWidget {
  const AddSupplierPage({super.key});

  @override
  _AddSupplierPageState createState() => _AddSupplierPageState();
}

class _AddSupplierPageState extends State<AddSupplierPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  Position? _currentPosition;

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  Future<void> _saveSupplier() async {
    final name = _nameController.text;
    final address = _addressController.text;
    final contact = _contactController.text;

    if (name.isEmpty ||
        address.isEmpty ||
        contact.isEmpty ||
        _currentPosition == null) {
      Get.snackbar('Error', 'Semua data harus diisi!');
      return;
    }

    await FirebaseFirestore.instance.collection('suppliers').add({
      'name': name,
      'address': address,
      'contact': contact,
      'location': {
        'latitude': _currentPosition!.latitude,
        'longitude': _currentPosition!.longitude,
      },
    });

    Get.back();
    Get.snackbar('Sukses', 'Supplier berhasil ditambahkan');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Supplier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Supplier'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Alamat Supplier'),
            ),
            TextField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Kontak Supplier'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text('Ambil Lokasi'),
            ),
            if (_currentPosition != null)
              Text(
                  'Koordinat: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSupplier,
              child: Text('Simpan Supplier'),
            ),
          ],
        ),
      ),
    );
  }
}
