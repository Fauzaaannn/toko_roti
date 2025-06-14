import 'package:flutter/material.dart';
import 'package:toko_roti/view/auth/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Kunci untuk validasi form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil nilai dari text field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State untuk mengatur visibilitas password
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    // Selalu dispose controller setelah tidak digunakan untuk menghindari memory leak
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Cek apakah form valid
    if (_formKey.currentState!.validate()) {
      // Jika valid, ambil data
      String email = _emailController.text;
      String password = _passwordController.text;

      // ---- LOGIKA LOGIN ----
      // Di sinilah Anda akan memanggil API untuk login.
      // Untuk sekarang, kita hanya akan print datanya.
      print('Login berhasil!');
      print('Email: $email');
      print('Password: $password');

      // Tampilkan snackbar atau navigasi ke halaman utama
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Memproses Login...')));

      // Contoh navigasi ke halaman home (buat halaman HomeScreen terlebih dahulu)
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan SafeArea agar konten tidak tumpang tindih dengan status bar
      body: SafeArea(
        // Menggunakan SingleChildScrollView agar bisa di-scroll saat keyboard muncul
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80.0),

                // --- Logo atau Ikon Aplikasi ---
                const Icon(
                  Icons.bakery_dining_outlined,
                  size: 100,
                  color: Color(0xFFD35400), // Warna oranye hangat
                ),
                const SizedBox(height: 16.0),

                // --- Judul dan Subjudul ---
                const Text(
                  'Selamat Datang Kembali!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A4A4A),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Masuk untuk melanjutkan pesanan roti Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 48.0),

                // --- Text Field untuk Email ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'contoh@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Masukkan format email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // --- Text Field untuk Password ---
                TextFormField(
                  controller: _passwordController,
                  obscureText:
                      !_isPasswordVisible, // Sembunyikan/tampilkan password
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    // Ikon untuk toggle visibilitas password
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        // Update state untuk redraw UI
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),

                // --- Tombol Lupa Password ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigasi ke halaman lupa password
                    },
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(color: Color(0xFFD35400)),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // --- Tombol Login ---
                ElevatedButton(
                  onPressed: _login, // Panggil fungsi login saat ditekan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD35400), // Warna utama
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // --- Tautan untuk Daftar ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar di sini',
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
