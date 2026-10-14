import 'package:flutter/widgets.dart';
import 'package:shop_client/shop_client.dart';

class CartLine {
  CartLine(this.product, this.quantity);

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;
}

class CartController extends ChangeNotifier {
  final Map<int, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList(growable: false);
  bool get isEmpty => _lines.isEmpty;

  int get itemCount =>
      _lines.values.fold<int>(0, (sum, line) => sum + line.quantity);

  double get total =>
      _lines.values.fold<double>(0, (sum, line) => sum + line.subtotal);

  int quantityOf(Product product) => _lines[product.id!]?.quantity ?? 0;

  /// Sets the quantity, limited to the stock on hand (0 removes the item).
  /// Returns the quantity that was actually set.
  int setQuantity(Product product, int quantity) {
    final id = product.id!;
    final next = quantity.clamp(0, product.stock).toInt();
    if (next == 0) {
      _lines.remove(id);
    } else {
      _lines[id] = CartLine(product, next);
    }
    notifyListeners();
    return next;
  }

  /// Adds one more. Returns false when the stock limit stops it.
  bool add(Product product) {
    final before = quantityOf(product);
    final after = setQuantity(product, before + 1);
    return after > before;
  }

  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }
}

/// Gives every screen access to the cart; widgets that call [CartScope.of]
/// rebuild automatically when the cart changes.
class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope not found above this widget');
    return scope!.notifier!;
  }
}
