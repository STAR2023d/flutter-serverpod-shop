import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class OrderEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The signed-in user's id (auth user UUID).
  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  Future<ShopOrder> createOrder(
    Session session,
    List<OrderItemRequest> items,
  ) async {
    final userId = _userId(session);

    if (items.isEmpty) {
      throw ShopException(message: 'Order must contain at least one item.');
    }

    // Merge duplicate product lines and validate quantities.
    final quantities = <int, int>{};
    for (final item in items) {
      if (item.quantity <= 0) {
        throw ShopException(message: 'Quantity must be greater than zero.');
      }
      quantities.update(
        item.productId,
        (q) => q + item.quantity,
        ifAbsent: () => item.quantity,
      );
    }

    // Any exception thrown inside the callback rolls back the transaction.
    return session.db.transaction<ShopOrder>((transaction) async {
      // Lock rows (ordered by id to avoid deadlocks) so concurrent orders
      // cannot oversell the same stock.
      final products = await Product.db.find(
        session,
        where: (t) => t.id.inSet(quantities.keys.toSet()),
        orderBy: (t) => t.id,
        lockMode: LockMode.forUpdate,
        transaction: transaction,
      );

      if (products.length != quantities.length) {
        throw ShopException(message: 'One or more products no longer exist.');
      }

      var total = 0.0;
      for (final product in products) {
        if (!product.isActive) {
          throw ShopException(
            message: '"${product.name}" is no longer available. '
                'Remove it from your cart and try again.',
          );
        }
        final qty = quantities[product.id!]!;
        if (product.stock < qty) {
          throw ShopException(
            message: 'Insufficient stock for "${product.name}" '
                '(available: ${product.stock}).',
          );
        }
        product.stock -= qty;
        total += product.price * qty;
      }
      total = (total * 100).round() / 100;

      await Product.db.update(
        session,
        products,
        columns: (t) => [t.stock],
        transaction: transaction,
      );

      final order = await ShopOrder.db.insertRow(
        session,
        ShopOrder(
          userId: userId,
          totalAmount: total,
          status: OrderStatus.pending,
        ),
        transaction: transaction,
      );

      await OrderItem.db.insert(
        session,
        [
          for (final product in products)
            OrderItem(
              orderId: order.id!,
              productId: product.id!,
              quantity: quantities[product.id!]!,
              price: product.price, // price snapshot at purchase time
            ),
        ],
        transaction: transaction,
      );

      return order;
    });
  }

  Future<List<ShopOrder>> myOrders(Session session) {
    return ShopOrder.db.find(
      session,
      where: (t) => t.userId.equals(_userId(session)),
      orderBy: (t) => t.createdAt.desc(),
    );
  }
}