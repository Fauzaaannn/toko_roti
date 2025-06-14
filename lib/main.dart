import 'package:flutter/material.dart';
import 'package:toko_roti/view/admin/add_product.dart';
import 'package:toko_roti/view/get-started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const GetStarted(),
        '/addproduct': (context) => const AddProductPage(),
        // '/login': (context) => const Login(),
        // '/register': (context) => const GetStarted(),
      },
    );
  }
}
    
