import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toko_roti/model/order_model.dart';
import 'package:toko_roti/services/order_service.dart';

class RiwayatPesananPage extends StatefulWidget {
  const RiwayatPesananPage({super.key});

  @override
  State<RiwayatPesananPage> createState() => _RiwayatPesananPageState();
}

class _RiwayatPesananPageState extends State<RiwayatPesananPage> {
  final OrderService _orderService = OrderService();
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _futureOrders = _orderService.getMyOrderHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadOrders(),
        child: FutureBuilder<List<Order>>(
          future: _futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Anda belum memiliki riwayat pesanan.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final orders = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ORDER #${order.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            _buildStatusChip(order.status),
                          ],
                        ),
                        const Divider(height: 20),
                        Text(
                          'Tanggal: ${DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(order.createdAt)}',
                        ),
                        const SizedBox(height: 8),
                        Text('Item: ${order.itemSummary}'),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total: Rp ${NumberFormat.decimalPattern('id_ID').format(double.parse(order.totalAmount))}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;
    switch (status.toLowerCase()) {
      case 'paid':
        chipColor = Colors.green;
        statusText = 'Berhasil';
        break;
      case 'unpaid':
        chipColor = Colors.orange;
        statusText = 'Belum Dibayar';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Gagal';
    }
    return Chip(
      label: Text(statusText, style: const TextStyle(color: Colors.white)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
