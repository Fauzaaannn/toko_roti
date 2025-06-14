import 'package:flutter/material.dart';
import 'package:toko_roti/ui/widget/buttom_nav.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MidtransWebView extends StatefulWidget {
  final String url;
  const MidtransWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<MidtransWebView> createState() => _MidtransWebViewState();
}

class _MidtransWebViewState extends State<MidtransWebView> {
  late final WebViewController _controller;
  var loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  loadingPercentage = progress;
                });
              },
              onPageStarted: (String url) {
                setState(() {
                  loadingPercentage = 0;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  loadingPercentage = 100;
                });
              },
              onWebResourceError: (WebResourceError error) {},
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  void _onDone() {
    // Navigasi ke halaman utama (ButtomNav) dan hapus semua halaman sebelumnya.
    // Langsung arahkan ke tab Riwayat (indeks 2).
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder:
            (context) => const ButtomNav(
              userRole: 'customer', // Asumsi alur ini hanya untuk customer
              initialPageIndex: 2, // 0:Menu, 1:Keranjang, 2:Riwayat
            ),
      ),
      (route) => false, // Hapus semua rute sebelumnya dari stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color(0xFFD35400), // Sesuaikan warna
        foregroundColor: Colors.white,
        actions: [
          // Tambahkan tombol "Selesai" di sini
          TextButton(
            onPressed: _onDone,
            child: const Text(
              'Selesai',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
              color: Colors.red,
            ),
        ],
      ),
    );
  }
}
