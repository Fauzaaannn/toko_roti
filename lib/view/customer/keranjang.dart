import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toko_roti/controller/cart_provider.dart';
import 'package:toko_roti/ui/widget/cart_item_widget.dart'; // Impor widget baru

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  bool _isLoading = false;

  void _checkout(CartProvider cart) {
    if (cart.items.values.where((item) => item.isSelected).isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih item terlebih dahulu untuk checkout!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // TODO: Implementasi logika checkout ke backend
    // 1. Kumpulkan item yang dipilih dari cart.items
    // 2. Buat request ke /api/orders
    // 3. Jika berhasil, kosongkan keranjang dengan cart.clear() dan navigasi
    setState(() => _isLoading = true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Memproses checkout...')));
    
    // Simulasi
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cart.itemCount == 0
              ? const Center(child: Text('Keranjangmu masih kosong!'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return CartItemWidget(item: items[index]);
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5)
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Total Bayar:', style: TextStyle(color: Colors.grey)),
                                Text(
                                  'Rp ${NumberFormat.decimalPattern('id_ID').format(cart.totalAmount)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () => _checkout(cart),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text('Checkout', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}