import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/model/cart_item.dart'; // Sesuaikan path jika perlu
import 'package:toko_roti/model/order_model.dart';

class OrderService {
  final String? _apiBaseUrl = dotenv.env['API_BASE_URL'];

  /// Mengirim data pesanan ke backend untuk dibuat.
  ///
  /// Menerima daftar item keranjang, alamat, latitude, dan longitude.
  /// Mengembalikan `orderId` dari pesanan yang baru dibuat.
  Future<int> createOrder(
    List<CartItem> items,
    String address,
    double lat,
    double long,
  ) async {
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan di file .env');
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw Exception('Akses ditolak. Silakan login kembali.');
    }

    // Mengubah daftar CartItem menjadi format JSON yang diminta oleh backend
    final orderItems =
        items
            .map(
              (item) => {
                'productId': int.parse(item.id),
                'quantity': item.quantity,
              },
            )
            .toList();

    // Mengirim request ke API untuk membuat pesanan
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/orders'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'items': orderItems,
        'deliveryAddress': address,
        'deliveryLatitude': lat, // Mengirim data latitude
        'deliveryLongitude': long, // Mengirim data longitude
      }),
    );

    // --- BAGIAN YANG DIPERBAIKI ---
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData['orderId'];
    } else {
      // Tampilkan pesan error spesifik dari backend
      final errorData = json.decode(response.body);
      throw Exception(
        errorData['message'] ??
            'Gagal membuat pesanan. Status: ${response.statusCode}',
      );
    }
    // --- AKHIR BAGIAN YANG DIPERBAIKI ---
  }

  /// Menandai pesanan sebagai 'Lunas' atau 'Dibayar' di backend.
  ///
  /// Menerima `orderId` dari pesanan yang akan diupdate statusnya.
  Future<void> completeOrder(int orderId) async {
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan');
    }
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw Exception('Akses ditolak.');
    }

    // Mengirim request ke endpoint baru untuk menyelesaikan pesanan
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/orders/$orderId/complete'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      // Perubahan di sini untuk menampilkan pesan dari backend
      try {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal menyelesaikan pesanan.');
      } catch (_) {
        throw Exception(
          'Gagal menyelesaikan pesanan. Status: ${response.statusCode}',
        );
      }
    }
  }

  // --- FUNGSI BARU UNTUK MENGAMBIL RIWAYAT ---
  Future<List<Order>> getMyOrderHistory() async {
    if (_apiBaseUrl == null) throw Exception('API_BASE_URL tidak ditemukan');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) throw Exception('Akses ditolak. Anda belum login.');

    final response = await http.get(
      Uri.parse('$_apiBaseUrl/orders/my-history'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // Kita gunakan lagi orderFromJson dari order_model.dart
      return orderFromJson(response.body);
    } else {
      throw Exception('Gagal memuat riwayat pesanan.');
    }
  }
}
