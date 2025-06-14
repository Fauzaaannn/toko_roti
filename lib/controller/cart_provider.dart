import 'package:flutter/material.dart';
import 'package:toko_roti/model/cart_item.dart';
import 'package:toko_roti/model/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      // Hanya hitung item yang dicentang
      if (cartItem.isSelected) {
        total += cartItem.price * cartItem.quantity;
      }
    });
    return total;
  }

  // Mengubah addItem agar menerima objek Product
  void addItem(Product product) {
    final productId = product.id.toString();
    if (_items.containsKey(productId)) {
      // Jika sudah ada, tambah jumlahnya
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          imageUrl: existingCartItem.imageUrl,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          isSelected: existingCartItem.isSelected,
        ),
      );
    } else {
      // Jika belum ada, buat CartItem baru dari Product
      _items.putIfAbsent(
        productId,
        () => CartItem.fromProduct(product),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (!_items.containsKey(productId)) return;
    if (newQuantity > 0) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          imageUrl: existingItem.imageUrl,
          price: existingItem.price,
          quantity: newQuantity,
          isSelected: existingItem.isSelected,
        ),
      );
    } else {
      // Jika kuantitas 0 atau kurang, hapus item
      removeItem(productId);
    }
    notifyListeners();
  }

  void toggleSelection(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.isSelected = !_items[productId]!.isSelected;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}