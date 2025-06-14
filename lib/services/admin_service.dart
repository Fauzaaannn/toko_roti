import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/model/order_model.dart';
import 'package:toko_roti/model/customer_model.dart';

class AdminService {
  final String? _apiBaseUrl = dotenv.env['API_BASE_URL'];

  Future<List<Order>> getAllTransactions() async {
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan di file .env');
    }

    // Ambil token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception(
        'Akses ditolak: Token tidak ditemukan. Silakan login kembali.',
      );
    }

    final response = await http.get(
      Uri.parse('$_apiBaseUrl/admin/transactions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // Sertakan token untuk otorisasi
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Jika berhasil, parse data JSON menjadi List<Order>
      return orderFromJson(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Jika token tidak valid atau bukan admin
      throw Exception('Akses ditolak. Anda tidak memiliki hak akses admin.');
    } else {
      throw Exception('Gagal memuat data transaksi.');
    }
  }

  // --- FUNGSI BARU UNTUK MENDAPATKAN SEMUA CUSTOMER ---
  Future<List<Customer>> getAllCustomers() async {
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan di file .env');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null) {
      throw Exception('Akses ditolak: Token tidak ditemukan.');
    }

    final response = await http.get(
      Uri.parse('$_apiBaseUrl/admin/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return customerFromJson(response.body);
    } else {
      throw Exception('Gagal memuat data pengguna.');
    }
  }
}
