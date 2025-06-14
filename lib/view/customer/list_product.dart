import 'package:flutter/material.dart';

// Model untuk Product
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
  });
}

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  // Static data - mudah diganti dengan API call nanti
  List<Product> products = [
    Product(
      id: '1',
      name: 'Roti Tawar Gandum',
      description: 'Roti tawar gandum segar dengan kandungan serat tinggi',
      price: 15000,
      imageUrl: 'https://via.placeholder.com/150x150/8B4513/FFFFFF?text=Roti+Tawar',
      category: 'Roti Tawar',
    ),
    Product(
      id: '2',
      name: 'Croissant Butter',
      description: 'Croissant renyah dengan butter premium',
      price: 12000,
      imageUrl: 'https://via.placeholder.com/150x150/DAA520/FFFFFF?text=Croissant',
      category: 'Pastry',
    ),
    Product(
      id: '3',
      name: 'Donat Coklat',
      description: 'Donat lembut dengan topping coklat manis',
      price: 8000,
      imageUrl: 'https://via.placeholder.com/150x150/8B4513/FFFFFF?text=Donat',
      category: 'Donat',
    ),
    Product(
      id: '4',
      name: 'Roti Sobek Keju',
      description: 'Roti sobek lembut dengan keju mozarella',
      price: 25000,
      imageUrl: 'https://via.placeholder.com/150x150/FF6347/FFFFFF?text=Roti+Sobek',
      category: 'Roti Manis',
    ),
    Product(
      id: '5',
      name: 'Danish Blueberry',
      description: 'Danish pastry dengan filling blueberry segar',
      price: 18000,
      imageUrl: 'https://via.placeholder.com/150x150/6A5ACD/FFFFFF?text=Danish',
      category: 'Pastry',
    ),
    Product(
      id: '6',
      name: 'Baguette',
      description: 'Roti panjang khas Prancis dengan kulit renyah',
      price: 20000,
      imageUrl: 'https://via.placeholder.com/150x150/D2691E/FFFFFF?text=Baguette',
      category: 'Roti Tawar',
    ),
  ];

  List<String> categories = ['Semua', 'Roti Tawar', 'Pastry', 'Donat', 'Roti Manis'];
  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.brown[600],
        title: Text(
          'Toko Roti Bahagia',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to cart
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Temukan roti segar terbaik hari ini',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                
                return Container(
                  margin: EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: Colors.brown[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.brown[800] : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16),

          // Product List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredProducts().length,
              itemBuilder: (context, index) {
                final product = _getFilteredProducts()[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk filter produk berdasarkan kategori
  List<Product> _getFilteredProducts() {
    if (selectedCategory == 'Semua') {
      return products;
    }
    return products.where((product) => product.category == selectedCategory).toList();
  }

  // Widget untuk card produk
  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to product detail
          _showProductDetail(product);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.bakery_dining, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              
              SizedBox(width: 12),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${_formatPrice(product.price)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[600],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.brown[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Add to Cart Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.brown[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                  onPressed: () {
                    // TODO: Add to cart functionality
                    _addToCart(product);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method untuk format harga
  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Method untuk menampilkan detail produk (sementara dialog)
  void _showProductDetail(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                product.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.bakery_dining, size: 50),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(product.description),
              SizedBox(height: 8),
              Text(
                'Harga: Rp ${_formatPrice(product.price)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addToCart(product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
              ),
              child: Text('Tambah ke Keranjang', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Method untuk menambah ke keranjang (sementara snackbar)
  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang'),
        backgroundColor: Colors.brown[600],
        duration: Duration(seconds: 2),
      ),
    );
  }
}