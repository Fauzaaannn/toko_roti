import 'package:flutter/material.dart';
import '../../model/cart_item.dart';
import '../../controller/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  CartItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: (bool? value) {
                Provider.of<CartProvider>(
                  context,
                  listen: false,
                ).toggleSelection(item.id);
              },
            ),
            Image.asset(
              item.imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${item.price}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).updateQuantity(item.id, item.quantity - 1);
                  },
                ),
                Text('${item.quantity}', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.red),
                  onPressed: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).updateQuantity(item.id, item.quantity + 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).removeItem(item.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
