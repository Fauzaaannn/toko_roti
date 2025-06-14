import 'package:flutter/material.dart';

class TransaksiManagePage extends StatelessWidget {
  const TransaksiManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Transaksi'),
          ],
        ),
      ),
    );
  }
} 