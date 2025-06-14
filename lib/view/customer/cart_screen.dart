import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import '../../controller/cart_provider.dart';
import '../../model/cart_item.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Provider.of<CartProvider>(context, listen: false).initializeDummyData();
        setState(() {
          _isInitialized = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
        backgroundColor: Colors.red,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.itemCount == 0) {
                    return Center(child: Text('Keranjang kosong'));
                  }
                  return ListView.builder(
                    itemCount: cartProvider.itemCount,
                    itemBuilder: (context, index) {
                      final item = cartProvider.items.values.toList()[index];
                      return CartItemWidget(item: item);
                    },
                  );
                },
              ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rp ${Provider.of<CartProvider>(context).totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Konfirmasi Checkout'),
                          content: Text('Apakah Anda yakin ingin checkout?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                setState(() {
                                  _isLoading = true;
                                });
                                await Future.delayed(
                                  Duration(seconds: 2),
                                ); // Simulasi proses
                                setState(() {
                                  _isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Checkout berhasil!')),
                                );
                              },
                              child: Text('Ya'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                  );
                },
                child: Text('Checkout'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
