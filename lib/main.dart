import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toko_roti/view/auth/login.dart'; // Sesuaikan dengan path Anda
import 'package:provider/provider.dart'; // Impor provider
import 'package:toko_roti/controller/cart_provider.dart'; // Impor CartProvider
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting('id_ID', null);

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
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
