import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_roti/view/customer/cart_screen.dart';
import 'package:toko_roti/controller/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        title: 'Toko Roti',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: CartScreen(),
      ),
    );
  }
}
