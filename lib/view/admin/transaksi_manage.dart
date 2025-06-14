import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/order_model.dart'; // Impor model yang baru
import '../../services/admin_service.dart'; // Impor service admin

class AdminTransactionHistoryScreen extends StatefulWidget {
  const AdminTransactionHistoryScreen({super.key});

  @override
  State<AdminTransactionHistoryScreen> createState() =>
      _AdminTransactionHistoryScreenState();
}

class _AdminTransactionHistoryScreenState
    extends State<AdminTransactionHistoryScreen> {
  final AdminService _adminService = AdminService();
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman pertama kali dibuka
    _futureOrders = _adminService.getAllTransactions();
  }

  // Helper widget untuk membuat "chip" status yang berwarna
  // Disesuaikan dengan status dari backend
  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;
    IconData chipIcon;

    switch (status.toLowerCase()) {
      case 'paid':
        chipColor = Colors.green;
        statusText = 'Dibayar';
        chipIcon = Icons.check_circle;
        break;
      case 'unpaid':
        chipColor = Colors.orange;
        statusText = 'Belum Dibayar';
        chipIcon = Icons.hourglass_top;
        break;
      case 'delivered':
        chipColor = Colors.blue;
        statusText = 'Terkirim';
        chipIcon = Icons.local_shipping;
        break;
      case 'failed':
      case 'expired':
        chipColor = Colors.red;
        statusText = 'Gagal';
        chipIcon = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Tidak Diketahui';
        chipIcon = Icons.help;
    }

    return Chip(
      avatar: Icon(chipIcon, color: Colors.white, size: 16),
      label: Text(statusText),
      backgroundColor: chipColor,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Riwayat Transaksi'),
        backgroundColor: const Color(0xFFD35400),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Fungsi refresh untuk memuat ulang data
              setState(() {
                _futureOrders = _adminService.getAllTransactions();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Order>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          // Saat data masih loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Jika terjadi error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error.toString().replaceAll('Exception: ', '')}',
              ),
            );
          }
          // Jika data berhasil didapat tapi kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data transaksi.'));
          }

          // Jika data berhasil didapat
          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Melihat detail untuk Order ID: ${order.id}',
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ORDER ID: #${order.id}',
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
                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'd MMMM yyyy, HH:mm',
                            'id_ID',
                          ).format(order.createdAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          order.itemSummary,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            currencyFormatter.format(
                              double.parse(order.totalAmount),
                            ),
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
          );
        },
      ),
    );
  }
}
