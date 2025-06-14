import 'package:toko_roti/model/product_model.dart';

class CartItem {
  final String id;
  final String name;
  final String imageUrl; // Menggunakan imageUrl untuk gambar dari network
  final double price;
  int quantity;
  bool isSelected; // Untuk checkbox

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.isSelected = true, // Default terpilih saat ditambahkan
  });

  // Helper untuk membuat CartItem dari sebuah Product object
  factory CartItem.fromProduct(Product product) {
    return CartItem(
      id: product.id.toString(), // Konversi ID ke String
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
    );
  }
}