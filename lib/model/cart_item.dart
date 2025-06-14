class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imagePath;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
    this.isSelected = true, // Default: item dipilih
  });
}
