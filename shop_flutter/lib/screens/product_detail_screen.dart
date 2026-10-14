import 'package:flutter/material.dart';
import 'package:shop_client/shop_client.dart';

import '../app_state.dart';
import '../cart_controller.dart';
import '../format.dart';
import '../widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  String _capitalize(String text) =>
      text.isEmpty ? text : '${text[0].toUpperCase()}${text.substring(1)}';

  void _addToCart(CartController cart) {
    final product = widget.product;
    final before = cart.quantityOf(product);
    cart.setQuantity(product, before + _quantity);
    final added = cart.quantityOf(product) - before;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: Text(
            added == _quantity
                ? 'Added to cart'
                : 'Only ${product.stock} in stock. Your cart is updated.',
          ),
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () {
              tabIndex.value = Tabs.cart;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final cart = CartScope.of(context);
    final soldOut = product.stock <= 0;
    final lowStock = !soldOut && product.stock <= 5;
    final metadata = product.metadata;

    final stockLabel = soldOut
        ? 'Out of stock'
        : lowStock
            ? 'Only ${product.stock} left'
            : 'In stock';
    final stockColor = soldOut
        ? theme.colorScheme.error
        : lowStock
            ? Colors.orange.shade800
            : theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Open cart',
            icon: Badge(
              isLabelVisible: cart.itemCount > 0,
              label: Text('${cart.itemCount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            onPressed: () {
              tabIndex.value = Tabs.cart;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: MaxWidth(
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Hero(
                tag: 'product-${product.id}',
                child: ProductImage(product: product, iconSize: 72),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    formatKes(product.price),
                    style: amountStyle.copyWith(
                      fontSize: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    stockLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: stockColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('About this item', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(product.description, style: theme.textTheme.bodyLarge),
                  if (metadata != null && metadata.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in metadata.entries)
                          Chip(
                            label: Text(
                              '${_capitalize(entry.key)}: ${entry.value}',
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: soldOut
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    QuantityStepper(
                      value: _quantity,
                      min: 1,
                      max: product.stock,
                      onChanged: (v) => setState(() => _quantity = v),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _addToCart(cart),
                        child: Row(
                          children: [
                            const Expanded(child: Text('Add to cart')),
                            Text(
                              formatKes(product.price * _quantity),
                              style: amountStyle.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
