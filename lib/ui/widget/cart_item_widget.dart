import 'package:flutter/material.dart';
import 'package:toko_roti/controller/cart_provider.dart';
import 'package:toko_roti/model/cart_item.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: (bool? value) {
                cartProvider.toggleSelection(item.id);
              },
            ),
            // --- PERUBAHAN DI SINI ---
            SizedBox(
              width: 60,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // Gunakan Image.network untuk URL dari internet
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            // --- AKHIR PERUBAHAN ---
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16)),
                  Text('Rp ${item.price}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => cartProvider.updateQuantity(item.id, item.quantity - 1),
                ),
                Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.red),
                  onPressed: () => cartProvider.updateQuantity(item.id, item.quantity + 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}