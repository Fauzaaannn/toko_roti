// lib/admin_transaction_history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Package untuk format tanggal dan angka
import 'package:toko_roti/model/order_model.dart'; // Impor model Order

class AdminTransactionHistoryScreen extends StatefulWidget {
  const AdminTransactionHistoryScreen({super.key});

  @override
  State<AdminTransactionHistoryScreen> createState() =>
      _AdminTransactionHistoryScreenState();
}

class _AdminTransactionHistoryScreenState
    extends State<AdminTransactionHistoryScreen> {
      
  // --- DATA DUMMY ---
  final List<Order> _dummyOrders = [
    Order(
      id: 'TRX-20250615-001',
      customerName: 'Citra Lestari',
      orderDate: DateTime(2025, 6, 15, 10, 30),
      status: 'Selesai',
      totalPrice: 55000,
      itemSummary: '2x Roti Cokelat, 1x Kue Keju',
    ),
    Order(
      id: 'TRX-20250615-002',
      customerName: 'Ahmad Dahlan',
      orderDate: DateTime(2025, 6, 15, 9, 5),
      status: 'Diproses',
      totalPrice: 32000,
      itemSummary: '1x Roti Tawar, 1x Donat Gula',
    ),
    Order(
      id: 'TRX-20250614-001',
      customerName: 'Dewi Anggraini',
      orderDate: DateTime(2025, 6, 14, 18, 20),
      status: 'Selesai',
      totalPrice: 78000,
      itemSummary: '3x Croissant, 2x Kopi Susu',
    ),
    Order(
      id: 'TRX-20250614-002',
      customerName: 'Budi Santoso',
      orderDate: DateTime(2025, 6, 14, 15, 45),
      status: 'Menunggu Konfirmasi',
      totalPrice: 25000,
      itemSummary: '1x Roti Sosis',
    ),
  ];
  // --- AKHIR DATA DUMMY ---

  // Helper widget untuk membuat "chip" status yang berwarna
  Widget _buildStatusChip(String status) {
    Color chipColor;
    IconData chipIcon;

    switch (status) {
      case 'Selesai':
        chipColor = Colors.green;
        chipIcon = Icons.check_circle;
        break;
      case 'Diproses':
        chipColor = Colors.blue;
        chipIcon = Icons.sync;
        break;
      case 'Menunggu Konfirmasi':
        chipColor = Colors.orange;
        chipIcon = Icons.hourglass_top;
        break;
      default:
        chipColor = Colors.grey;
        chipIcon = Icons.help;
    }

    return Chip(
      avatar: Icon(chipIcon, color: Colors.white, size: 16),
      label: Text(status),
      backgroundColor: chipColor,
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Formatter untuk mata uang Rupiah
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Riwayat Transaksi'),
        backgroundColor: const Color(0xFFD35400),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _dummyOrders.length,
        itemBuilder: (context, index) {
          final order = _dummyOrders[index];
          
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell( // Membuat card bisa di-tap
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Aksi saat card di-tap (misal: lihat detail transaksi)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Melihat detail untuk ${order.id}')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris atas: ID Pesanan dan Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.id,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        _buildStatusChip(order.status),
                      ],
                    ),
                    const Divider(height: 20),
                    // Detail Pelanggan dan Tanggal
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(order.orderDate),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    // Ringkasan Item
                    Text(
                      order.itemSummary,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    // Total Harga
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        currencyFormatter.format(order.totalPrice),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD35400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}