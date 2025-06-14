import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    // Cek validasi form
    if (_formKey.currentState!.validate()) {
      // Jika semua data valid, proses pendaftaran
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      // ---- LOGIKA REGISTER ----
      // Di sini Anda akan memanggil API untuk mendaftarkan user baru.
      // Untuk saat ini, kita hanya akan print datanya.
      print('Proses Pendaftaran Berhasil!');
      print('Nama: $name');
      print('Email: $email');
      print('Password: $password');

      // Tampilkan notifikasi sukses dan kembali ke halaman login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Silakan masuk.'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman login setelah beberapa saat
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50.0),

                // --- Logo dan Judul ---
                const Icon(
                  Icons.bakery_dining_outlined,
                  size: 80,
                  color: Color(0xFFD35400),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Buat Akun Baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Isi data di bawah untuk memulai petualangan rasa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32.0),

                // --- Text Field untuk Nama Lengkap ---
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Nama tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Text Field untuk Email ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email tidak boleh kosong';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                      return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Text Field untuk Password ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed:
                          () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password tidak boleh kosong';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Tombol Daftar ---
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD35400),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // --- Tautan untuk Kembali ke Login ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed:
                          () => Navigator.pop(
                            context,
                          ), // Kembali ke halaman sebelumnya (login)
                      child: const Text(
                        'Masuk di sini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD35400),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
