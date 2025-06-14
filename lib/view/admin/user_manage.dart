import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Impor untuk format tanggal
import '../../model/customer_model.dart'; // Impor model Customer
import '../../services/admin_service.dart'; // Impor service Admin

class UserManage extends StatefulWidget {
  const UserManage({super.key});

  @override
  State<UserManage> createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  final AdminService _adminService = AdminService();
  late Future<List<Customer>> _futureCustomers;

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman pertama kali dibuka
    _futureCustomers = _adminService.getAllCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar bisa dihilangkan jika sudah ada di main_screen.dart
      // appBar: AppBar(
      //   title: const Text('Admin: Daftar Pengguna'),
      //   backgroundColor: const Color(0xFFD35400),
      //   foregroundColor: Colors.white,
      // ),
      body: FutureBuilder<List<Customer>>(
        future: _futureCustomers,
        builder: (context, snapshot) {
          // Saat loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Jika ada error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Jika data tidak ada atau kosong
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data pengguna.'));
          }

          // Jika data berhasil dimuat
          final customers = snapshot.data!;
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final user = customers[index];

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
                      // Tampilkan tanggal bergabung, bukan role statis
                      Text(
                        'Bergabung: ${DateFormat('d MMMM yyyy').format(user.createdAt)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
