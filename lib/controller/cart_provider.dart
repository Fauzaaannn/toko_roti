import 'package:flutter/material.dart';
import '../model/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    });
    return total;
  }

  void addItem(String productId, String name, double price, String imagePath) {
    if (_items.containsKey(productId)) {
      _items[productId] = CartItem(
        id: _items[productId]!.id,
        name: _items[productId]!.name,
        price: _items[productId]!.price,
        quantity: _items[productId]!.quantity + 1,
        imagePath: _items[productId]!.imagePath,
        isSelected: _items[productId]!.isSelected,
      );
    } else {
      _items[productId] = CartItem(
        id: productId,
        name: name,
        price: price,
        quantity: 1,
        imagePath: imagePath,
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity > 0) {
        _items[productId] = CartItem(
          id: _items[productId]!.id,
          name: _items[productId]!.name,
          price: _items[productId]!.price,
          quantity: quantity,
          imagePath: _items[productId]!.imagePath,
          isSelected: _items[productId]!.isSelected,
        );
      } else {
        removeItem(productId);
      }
      notifyListeners();
    }
  }

  void toggleSelection(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.isSelected = !_items[productId]!.isSelected;
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void initializeDummyData() {
    addItem('1', 'Roti Tawar', 10000.0, 'assets/roti1.jpg');
    addItem('2', 'Roti Coklat', 12000.0, 'assets/roti2.jpg');
    addItem('3', 'Roti Keju', 15000.0, 'assets/roti1.jpg');
  }
}
