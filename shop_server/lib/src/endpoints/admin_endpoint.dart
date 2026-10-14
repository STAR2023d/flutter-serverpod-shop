import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Product management for shop owners. Admins are the user IDs listed in
/// `adminUserIds` in passwords.yaml (comma-separated).
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  String _userId(Session session) => session.authenticated!.userIdentifier;

  bool _isAdmin(Session session) {
    final raw = session.serverpod.getPassword('adminUserIds') ?? '';
    final admins = raw
        .split(',')
        .map((id) => id.trim().toLowerCase())
        .where((id) => id.isNotEmpty)
        .toSet();
    return admins.contains(_userId(session).toLowerCase());
  }

  void _requireAdmin(Session session) {
    if (!_isAdmin(session)) {
      throw ShopException(
        message: 'You do not have permission to manage products.',
      );
    }
  }

  Future<bool> isAdmin(Session session) async => _isAdmin(session);

  /// The signed-in user's own ID (needed once to set up the first admin).
  Future<String> myUserId(Session session) async => _userId(session);

  /// Every product, including hidden ones.
  Future<List<Product>> listAllProducts(
    Session session, {
    int limit = 100,
    int offset = 0,
  }) async {
    _requireAdmin(session);
    return Product.db.find(
      session,
      orderBy: (t) => t.id,
      limit: limit.clamp(1, 200),
      offset: offset < 0 ? 0 : offset,
    );
  }

  /// Creates a product (id == null) or updates an existing one.
  Future<Product> saveProduct(Session session, Product product) async {
    _requireAdmin(session);

    product.name = product.name.trim();
    product.description = product.description.trim();
    final image = product.imageUrl?.trim();
    product.imageUrl = (image == null || image.isEmpty) ? null : image;

    if (product.name.isEmpty) {
      throw ShopException(message: 'Give the product a name.');
    }
    if (product.price.isNaN || product.price <= 0) {
      throw ShopException(message: 'Price must be greater than zero.');
    }
    if (product.stock < 0) {
      throw ShopException(message: 'Stock cannot be negative.');
    }
    final url = product.imageUrl;
    if (url != null &&
        !url.startsWith('http://') &&
        !url.startsWith('https://')) {
      throw ShopException(
        message: 'The image link must start with http:// or https://',
      );
    }

    if (product.id == null) {
      return Product.db.insertRow(session, product);
    }
    return Product.db.updateRow(session, product);
  }

  Future<void> deleteProduct(Session session, int productId) async {
    _requireAdmin(session);
    try {
      await Product.db.deleteWhere(
        session,
        where: (t) => t.id.equals(productId),
      );
    } catch (e) {
      session.log('Delete product $productId failed: $e',
          level: LogLevel.warning);
      throw ShopException(
        message: 'This product is part of past orders, so it cannot be '
            'deleted. Hide it from the shop instead.',
      );
    }
  }
}