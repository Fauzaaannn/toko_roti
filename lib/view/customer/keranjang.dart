import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart'; // Untuk data posisi
import 'package:toko_roti/controller/cart_provider.dart';
import 'package:toko_roti/services/location_service.dart';
import 'package:toko_roti/services/order_service.dart';
import 'package:toko_roti/view/customer/pembayaran.dart';
import 'package:toko_roti/ui/widget/cart_item_widget.dart'; // Sesuaikan path jika perlu

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final OrderService _orderService = OrderService();
  final LocationService _locationService = LocationService();
  bool _isLoading = false;

  /// Fungsi yang dipanggil saat tombol Checkout ditekan
  void _checkout(CartProvider cart) async {
    final selectedItems =
        cart.items.values.where((item) => item.isSelected).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih item terlebih dahulu untuk checkout!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Tampilkan dialog untuk konfirmasi alamat
      final bool? useCurrentLocation = await showDialog<bool>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Konfirmasi Alamat'),
              content: const Text(
                'Gunakan lokasi Anda saat ini sebagai alamat pengiriman?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Gunakan Lokasi'),
                ),
              ],
            ),
      );

      // Jika pengguna tidak setuju atau menutup dialog, hentikan proses
      if (useCurrentLocation != true) {
        setState(() => _isLoading = false);
        return;
      }

      // 2. Dapatkan lokasi GPS & alamat
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mendapatkan lokasi Anda...')),
      );
      Position position = await _locationService.getCurrentPosition();
      String address = await _locationService.getAddressFromCoordinates(
        position,
      );

      // 3. Buat pesanan dengan data GPS
      final orderId = await _orderService.createOrder(
        selectedItems,
        address,
        position.latitude,
        position.longitude,
      );
      final totalAmount = cart.totalAmount;

      if (!mounted) return;

      // 4. Navigasi ke Halaman Pembayaran
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  PembayaranPage(orderId: orderId, totalAmount: totalAmount),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final items = cart.items.values.toList();
        return Scaffold(
          body:
              _isLoading
                  ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memproses checkout...'),
                      ],
                    ),
                  )
                  : cart.itemCount == 0
                  ? const Center(child: Text('Keranjangmu masih kosong!'))
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return CartItemWidget(item: items[index]);
                          },
                        ),
                      ),
                      // Checkout Bar
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Bayar:',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Rp ${NumberFormat.decimalPattern('id_ID').format(cart.totalAmount)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => _checkout(cart),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }
}
