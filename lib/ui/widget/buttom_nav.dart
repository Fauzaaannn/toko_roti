import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:toko_roti/services/auth_service.dart';
import 'package:toko_roti/ui/theme.dart'; // Sesuaikan path jika perlu

// Import semua halaman yang akan digunakan
import 'package:toko_roti/view/admin/add_product.dart';
import 'package:toko_roti/view/admin/transaksi_manage.dart';
import 'package:toko_roti/view/admin/user_manage.dart';
import 'package:toko_roti/view/customer/keranjang.dart';
import 'package:toko_roti/view/customer/list_product.dart';
import 'package:toko_roti/view/customer/pembayaran.dart';
import 'package:toko_roti/view/auth/login.dart'; // Untuk logout

class ButtomNav extends StatefulWidget {
  final String userRole;
  const ButtomNav({super.key, required this.userRole});

  @override
  _ButtomNavState createState() => _ButtomNavState();
}

class _ButtomNavState extends State<ButtomNav> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final AuthService _authService = AuthService();

  late List<Widget> _pages;
  late List<CurvedNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    // Tentukan halaman dan item navigasi berdasarkan role
    if (widget.userRole == 'admin') {
      _pages = const [
        TransaksiManage(), // Halaman yang kita buat sebelumnya
        UserManage(),
        AddProductPage(),
      ];
      _navItems = const [
        CurvedNavigationBarItem(
          child: Icon(Icons.receipt_long, color: Colors.white),
          label: 'Transaksi',
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.people, color: Colors.white),
          label: 'Pengguna',
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.add_box, color: Colors.white),
          label: 'Produk',
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ];
    } else {
      // Default untuk 'customer'
      _pages = const [ListProductPage(), KeranjangPage(), PembayaranPage()];
      _navItems = const [
        CurvedNavigationBarItem(
          child: Icon(Icons.store, color: Colors.white),
          label: 'Menu',
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.shopping_cart, color: Colors.white),
          label: 'Keranjang',
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.payment, color: Colors.white),
          label: 'Pembayaran',
          labelStyle: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ];
    }
  }

  void _handleLogout() async {
    await _authService.logout();
    // Navigasi kembali ke halaman login dan hapus semua riwayat navigasi sebelumnya
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Roti'),
        backgroundColor: wPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: _navItems, // Gunakan item navigasi yang sudah ditentukan
        color: wPrimaryColor,
        buttonBackgroundColor: wPrimaryColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pages[_page], // Tampilkan halaman berdasarkan index
    );
  }
}
