// import 'package:flutter/foundation.dart';
// import 'package:device_preview/device_preview.dart';

import 'package:flutter/material.dart';
import 'package:toko_roti/view/auth/login.dart';
import 'package:toko_roti/view/auth/register.dart';

  runApp(const MyApp());
  // DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const Login());
  }
}