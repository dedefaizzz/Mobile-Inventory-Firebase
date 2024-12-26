import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_inventory_firebase/screens/AddSupplierPage.dart';
import 'package:mobile_inventory_firebase/screens/HomePage.dart';
import 'package:mobile_inventory_firebase/screens/ItemListPage.dart';
import 'package:mobile_inventory_firebase/screens/LoginPage.dart';
import 'package:mobile_inventory_firebase/screens/SupplierDetailPage.dart';
import 'package:mobile_inventory_firebase/screens/SupplierListPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Advanced Inventory Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/items', page: () => ItemListPage()),
        GetPage(name: '/suppliers', page: () => SupplierListPage()),
        GetPage(name: '/add-supplier', page: () => AddSupplierPage()),
        GetPage(name: '/supplier-detail', page: () => SupplierDetailPage()),
      ],
    );
  }
}
