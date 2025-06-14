// lib/order_model.dart

class Order {
  final String id;
  final String customerName;
  final DateTime orderDate;
  final String status; // "Selesai", "Diproses", "Menunggu Konfirmasi"
  final double totalPrice;
  final String itemSummary; // Ringkasan item, misal: "3x Roti Cokelat, 1x Kue Keju"

  Order({
    required this.id,
    required this.customerName,
    required this.orderDate,
    required this.status,
    required this.totalPrice,
    required this.itemSummary,
  });
}