import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ProductEndpoint extends Endpoint {
  /// Paginated list of products that are shown in the shop,
  /// with optional name search.
  Future<List<Product>> listProducts(
    Session session, {
    String? search,
    int limit = 20,
    int offset = 0,
  }) async {
    final safeLimit = limit.clamp(1, 100);
    final safeOffset = offset < 0 ? 0 : offset;
    final query = search?.trim();

    return Product.db.find(
      session,
      where: (t) =>
          t.isActive.equals(true) &
          ((query == null || query.isEmpty)
              ? Constant.bool(true)
              : t.name.ilike('%$query%')),
      orderBy: (t) => t.id,
      limit: safeLimit,
      offset: safeOffset,
    );
  }

  Future<Product?> getProduct(Session session, int id) async {
    final product = await Product.db.findById(session, id);
    if (product == null || !product.isActive) return null;
    return product;
  }
}