import 'package:flutter/material.dart';

class ListProductPage extends StatelessWidget {
  const ListProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Daftar Produk'),
          ],
        ),
      ),
    );
  }
}