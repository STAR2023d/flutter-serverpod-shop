import 'package:serverpod/serverpod.dart';

import 'generated/protocol.dart';

/// Inserts sample products when the product table is empty (development only).
Future<void> seedProducts(Serverpod pod) async {
  final session = await pod.createSession(enableLogging: false);
  try {
    if (await Product.db.count(session) > 0) return;

    await Product.db.insert(session, [
      Product(
        name: 'Classic T-Shirt',
        description: '100% cotton, regular fit.',
        price: 19.99,
        stock: 50,
        metadata: {'color': 'white', 'size': 'M'},
      ),
      Product(
        name: 'Running Shoes',
        description: 'Lightweight everyday trainers.',
        price: 79.50,
        stock: 20,
        metadata: {'color': 'black', 'size': '42'},
      ),
      Product(
        name: 'Stainless Water Bottle',
        description: '750ml insulated bottle.',
        price: 24.00,
        stock: 35,
      ),
      Product(
        name: 'Laptop Backpack',
        description: 'Water-resistant, 15-inch laptop sleeve.',
        price: 45.00,
        stock: 15,
      ),
      Product(
        name: 'Wireless Mouse',
        description: '2.4GHz ergonomic mouse.',
        price: 18.75,
        stock: 40,
      ),
      Product(
        name: 'Desk Lamp',
        description: 'LED lamp with adjustable brightness.',
        price: 32.00,
        stock: 3,
      ),
    ]);
    session.log('Seeded sample products.');
  } finally {
    await session.close();
  }
}
