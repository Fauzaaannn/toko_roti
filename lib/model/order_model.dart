import 'dart:convert';

// Helper function untuk mengubah List<dynamic> menjadi List<Order>
List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

class Order {
  final int id;
  final String totalAmount;
  final String status;
  final DateTime createdAt;
  final User? user; // User bisa null jika terjadi anomali data
  final List<OrderItem> orderItems;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.user,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      totalAmount: json["totalAmount"],
      status: json["status"],
      // Waktu di database (UTC) dikonversi ke waktu lokal
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      user: json["User"] == null ? null : User.fromJson(json["User"]),
      orderItems: List<OrderItem>.from(json["OrderItems"].map((x) => OrderItem.fromJson(x))),
    );
  }

  // Helper untuk membuat ringkasan item
  String get itemSummary {
    if (orderItems.isEmpty) {
      return 'Tidak ada item.';
    }
    // Menggabungkan nama produk dan jumlahnya, misal: "2x Roti Coklat, 1x Donat Gula"
    return orderItems.map((item) => '${item.quantity}x ${item.product?.name ?? 'Produk Dihapus'}').join(', ');
  }

  // Helper untuk mendapatkan nama customer
  String get customerName {
      return user?.name ?? 'Pelanggan Anonim';
  }
}

class OrderItem {
  final int quantity;
  final Product? product;

  OrderItem({
    required this.quantity,
    this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        quantity: json["quantity"],
        product: json["Product"] == null ? null : Product.fromJson(json["Product"]),
      );
}

class Product {
  final String name;

  Product({required this.name});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
      );
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
      );
}