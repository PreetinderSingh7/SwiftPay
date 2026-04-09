import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get itemTotal => product.price * quantity;
  double get itemTax => itemTotal * product.taxRate;
  double get itemTotalWithTax => itemTotal + itemTax;
}