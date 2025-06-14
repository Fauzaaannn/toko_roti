import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import package
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toko_roti/model/user_model.dart';

class AuthService {
  // Ambil base URL dari environment variable
  final String? _apiBaseUrl = dotenv.env['API_BASE_URL'];

  // --- FUNGSI BARU UNTUK REGISTER ---
  Future<void> register(String name, String email, String password) async {
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan di file .env');
    }

    final response = await http.post(
      Uri.parse('$_apiBaseUrl/auth/register'), // Endpoint register
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Pendaftaran berhasil, backend mengembalikan status 201.
      // Tidak perlu melakukan apa-apa, fungsi selesai.
      return;
    } else {
      // Jika gagal (misal: email sudah terdaftar), lemparkan error.
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal untuk mendaftar.');
    }
  }
  // --- END OF FUNGSI BARU ---

  Future<User> login(String email, String password) async {
    // Pastikan API_BASE_URL tidak kosong
    if (_apiBaseUrl == null) {
      throw Exception('API_BASE_URL tidak ditemukan di file .env');
    }

    final response = await http.post(
      Uri.parse('$_apiBaseUrl/auth/login'), // Gunakan URL dari .env
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final userData = User.fromJson(jsonDecode(response.body));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', userData.accessToken);
      return userData;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal untuk login.');
    }
  }

  // ... (fungsi logout dan getToken tetap sama)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
