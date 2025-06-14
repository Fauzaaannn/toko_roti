import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/admin_service.dart'; // Impor service admin

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  // Instance service
  final AdminService _adminService = AdminService();

  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Animasi (tidak diubah)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Catatan: Field di bawah ini ada di UI tapi tidak digunakan oleh backend Anda saat ini.
  // final _stockController = TextEditingController();
  // String _selectedCategory = 'Roti Manis';
  // bool _isAvailable = true;

  final List<String> _categories = [
    'Roti Manis',
    'Roti Tawar',
    'Pastry',
    'Kue Kering',
    'Cake',
    'Donat',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFFD35400),
                  ),
                  title: const Text('Kamera'),
                  onTap: () => _getImage(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color(0xFFD35400),
                  ),
                  title: const Text('Galeri'),
                  onTap: () => _getImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    Navigator.pop(context);
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto produk tidak boleh kosong.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        await _adminService.addProduct(
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          imageFile: _selectedImage!,
        );
        _showSuccessDialog();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Produk Berhasil Ditambahkan!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('Tambah Lagi'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD35400),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  if (Navigator.canPop(context)) {
                    // Kembali dari halaman AddProduct
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Selesai',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar bisa di-remark jika sudah ada di main_screen
      // appBar: AppBar(
      //   title: const Text('Tambah Produk'),
      //   backgroundColor: const Color(0xFFD35400),
      //   foregroundColor: Colors.white,
      // ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Foto Produk'),
                  const SizedBox(height: 12),
                  _buildImageUpload(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Informasi Produk'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nama Produk',
                    hint: 'cth: Roti Cokelat Lumer',
                    icon: Icons.bakery_dining,
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Nama tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Deskripsi',
                    hint: 'cth: Roti empuk dengan isian coklat',
                    icon: Icons.description,
                    maxLines: 3,
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Deskripsi tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Harga'),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Harga (Rp)',
                    hint: '5000',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator:
                        (v) =>
                            v == null || v.isEmpty
                                ? 'Harga tidak boleh kosong'
                                : null,
                  ),
                  const SizedBox(height: 32),

                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2D3748),
    ),
  );

  Widget _buildImageUpload() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                _selectedImage != null
                    ? const Color(0xFFD35400)
                    : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child:
            _selectedImage != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 40,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tambah Foto Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFFD35400)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD35400), width: 2),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD35400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: _isLoading ? null : _submitProduct,
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Simpan Produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }
}
