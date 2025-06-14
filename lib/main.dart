import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toko_roti/view/auth/login.dart'; // Sesuaikan dengan path Anda

Future<void> main() async {
  // Load file .env sebelum aplikasi berjalan
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Roti',
      debugShowCheckedModeBanner: false,
      home: const Login(), // Halaman awal
    );
  }
}
