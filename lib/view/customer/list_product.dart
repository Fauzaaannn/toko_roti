import 'package:flutter/material.dart';
import 'package:toko_roti/model/product_model.dart';
import 'package:toko_roti/controller/product_controller.dart';
import 'package:provider/provider.dart';
import 'package:toko_roti/controller/cart_provider.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List<Product> products = [];
  bool isLoading = true;
  final ProductController _controller = ProductController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedProducts = await _controller.fetchProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    }
  }

  Future<void> _addToCart(Product product) async {
    // Panggil provider untuk menambahkan item
    Provider.of<CartProvider>(context, listen: false).addItem(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
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

                  SizedBox(height: 16),

                  // Product List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(product);
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  // Widget untuk card produk
  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
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
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
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
              child: Text(
                'Tambah ke Keranjang',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
