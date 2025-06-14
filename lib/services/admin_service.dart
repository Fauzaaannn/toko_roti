import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/model/order_model.dart';
import 'package:toko_roti/model/customer_model.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class AdminService {
  final String? _apiBaseUrl = dotenv.env['API_BASE_URL'];

  // --- FUNGSI BARU UNTUK MENAMBAH PRODUK ---
  Future<void> addProduct({
    required String name,
    required String description,
    required String price,
    required File imageFile,
  }) async {
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan di file .env');
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      throw Exception('Akses ditolak: Token tidak ditemukan.');
    }

    final uri = Uri.parse('$_apiBaseUrl/products');
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['price'] = price;

    // --- BAGIAN YANG DIPERBARUI ---
    // Deteksi mime type dari file
    final mimeTypeData = lookupMimeType(
      imageFile.path,
      headerBytes: [0xFF, 0xD8],
    )?.split('/');

    // Buat MultipartFile dengan ContentType yang eksplisit
    final image = await http.MultipartFile.fromPath(
      'productImage',
      imageFile.path,
      // Tentukan Content-Type, contoh: 'image/jpeg'
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
    );

    request.files.add(image);
    // --- AKHIR BAGIAN YANG DIPERBARUI ---

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 201) {
      print(response.body); // Cetak body untuk debug jika masih gagal
      throw Exception(
        'Gagal menambahkan produk. Status: ${response.statusCode}',
      );
    }
  }
  // --- END OF FUNGSI BARU ---

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
