// lib/view/customer/keranjang.dart

import 'package:flutter/material.dart';

// --- Data Model for a Cart Item ---
class CartItem {
  final String id;
  final String name;
  final String imageUrl; // For displaying product image
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1, // Default quantity is 1
  });

  // Helper to calculate item total (price * quantity)
  double get total => price * quantity;
}

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  // Dummy data for cart items.
  // In a real application, this data would typically come from:
  // - A local database (e.g., SQLite, Hive)
  // - A remote API (e.g., Firebase, your own backend)
  // - A state management solution (e.g., Provider, BLoC, GetX, Riverpod)
  List<CartItem> _cartItems = [
    CartItem(
      id: '1',
      name: 'Roti Gandum Utuh',
      imageUrl:
          'https://via.placeholder.com/100x100/FF0000/FFFFFF?text=Roti1', // Placeholder image
      price: 15000.00,
      quantity: 2,
    ),
    CartItem(
      id: '2',
      name: 'Donat Coklat Klasik',
      imageUrl:
          'https://via.placeholder.com/100x100/FF0000/FFFFFF?text=Donat', // Placeholder image
      price: 8000.00,
      quantity: 3,
    ),
    CartItem(
      id: '3',
      name: 'Croissant Mentega',
      imageUrl:
          'https://via.placeholder.com/100x100/FF0000/FFFFFF?text=Croissant', // Placeholder image
      price: 12000.00,
      quantity: 1,
    ),
    CartItem(
      id: '4',
      name: 'Kue Tart Mini',
      imageUrl:
          'https://via.placeholder.com/100x100/FF0000/FFFFFF?text=Kue', // Placeholder image
      price: 35000.00,
      quantity: 1,
    ),
  ];

  // Function to calculate the total price of all items in the cart
  double _calculateTotalPrice() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.total);
  }

  // Function to increase item quantity
  void _increaseQuantity(String itemId) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _cartItems[index].quantity++;
      }
    });
  }

  // Function to decrease item quantity
  void _decreaseQuantity(String itemId) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1 && _cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      }
    });
  }

  // Function to remove an item from the cart
  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: Colors.red, // Shopee-like red
        foregroundColor: Colors.white, // White text on red AppBar
        centerTitle: true,
      ),
      body:
          _cartItems.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Keranjangmu kosong!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to product list or home page
                        // Example: Navigator.of(context).pop();
                        // Or if you have a product list route:
                        // Navigator.pushNamed(context, '/list_product');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Kembali berbelanja... (Implementasi navigasi)',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button background color
                        foregroundColor: Colors.white, // Button text color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Mulai Belanja'),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(item.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product Name
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      // Product Price
                                      Text(
                                        'Rp ${item.price.toStringAsFixed(0)}', // Format price
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Quantity Controls
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      () => _decreaseQuantity(
                                                        item.id,
                                                      ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    item.quantity.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap:
                                                      () => _increaseQuantity(
                                                        item.id,
                                                      ),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Delete Button
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed:
                                                () => _removeItem(item.id),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Bottom Checkout Section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(
                            0,
                            -3,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SafeArea(
                      // Use SafeArea to avoid conflicts with device's bottom notch
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp ${_calculateTotalPrice().toStringAsFixed(0)}', // Total price
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_cartItems.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Keranjang Anda kosong! Tambahkan item terlebih dahulu.',
                                      ),
                                    ),
                                  );
                                } else {
                                  // TODO: Implement checkout logic
                                  // Example: Navigate to pembayaran.dart
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => PembayaranPage(totalPrice: _calculateTotalPrice())));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Melanjutkan ke pembayaran dengan total Rp ${_calculateTotalPrice().toStringAsFixed(0)}',
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red, // Shopee-like red button
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
