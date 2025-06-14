// import 'package:flutter/foundation.dart';
// import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';
import 'package:toko_roti/view/customer/list_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env"); // Inisialisasi dotenv

  runApp(const MyApp());
  // DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Roti',
      debugShowCheckedModeBanner: false,
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const ListProduct(),
      },
    );
  }
}