// lib/admin_view_users_screen.dart
import 'package:flutter/material.dart';
import 'package:toko_roti/model/user_model.dart'; // Impor model User

class AdminViewUsersScreen extends StatefulWidget {
  const AdminViewUsersScreen({super.key});

  @override
  State<AdminViewUsersScreen> createState() => _AdminViewUsersScreenState();
}

class _AdminViewUsersScreenState extends State<AdminViewUsersScreen> {
  // --- DATA DUMMY ---
  // Kita buat daftar pengguna palsu di sini sebagai pengganti data dari API.
  final List<User> _dummyUsers = [
    User(
      id: 1,
      name: 'Budi Santoso',
      email: 'budi.santoso@example.com',
      role: '081234567890',
      accessToken: 'blabla',
    ),
    User(
      id: 2,
      name: 'Citra Lestari',
      email: 'citra.lestari@example.com',
      role: '085678901234',
      accessToken: 'blabla',
    ),
    User(
      id: 3,
      name: 'Ahmad Dahlan',
      email: 'ahmad.d@example.com',
      role: '087812345678',
      accessToken: 'blabla',
    ),
    User(
      id: 4,
      name: 'Dewi Anggraini',
      email: 'dewi.anggraini@example.com',
      role: '089955554321',
      accessToken: 'blabla',
    ),
  ];
  // --- AKHIR DATA DUMMY ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Daftar Pengguna (UI)'),
        backgroundColor: const Color(0xFFD35400),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView.builder(
        // Jumlah item dalam list sesuai dengan panjang data dummy
        itemCount: _dummyUsers.length,
        itemBuilder: (context, index) {
          // Ambil satu user dari data dummy berdasarkan index-nya
          final user = _dummyUsers[index];

          // Tampilkan dalam widget Card dan ListTile yang sama seperti sebelumnya
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 1.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFD35400).withOpacity(0.1),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Color(0xFFD35400),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(user.email),
                  const SizedBox(height: 2),
                  Text(user.role),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
