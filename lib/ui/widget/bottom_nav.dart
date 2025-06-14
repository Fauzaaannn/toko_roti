import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:toko_roti/ui/theme.dart';
import 'package:toko_roti/view/admin/add_product.dart';
import 'package:toko_roti/view/admin/transaksi_manage.dart';
import 'package:toko_roti/view/admin/user_manage.dart';
import 'package:toko_roti/view/customer/keranjang.dart';
import 'package:toko_roti/view/customer/list_product.dart';
import 'package:toko_roti/view/customer/pembayaran.dart';

void main() => runApp(const MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  // Halaman-halaman
  final List<Widget> _pages = const [
    // ListProductPage(),
    // KeranjangPage(),
    // PembayaranPage(),
    AdminTransactionHistoryScreen(),
    AdminViewUsersScreen(),
    AddProductPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const [
          //buttom nav bar user
          CurvedNavigationBarItem(
            child: Icon(Icons.menu_outlined, color: Colors.white),
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

          //buttom login admin
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.menu, color: Colors.white,),
          //   label: 'menu',
          //    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
          // ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.person, color: Colors.white,),
          //   label: 'User',
          //    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
          // ),
          // CurvedNavigationBarItem(
          //   child: Icon(Icons.receipt, color: Colors.white,),
          //   label: 'Transaksi',
          //    labelStyle: TextStyle(color: Colors.white, fontSize: 12),
          // ),
        ],
        color: wPrimaryColor,
        buttonBackgroundColor: wPrimaryColor,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _pages[_page],
    );
  }
}
