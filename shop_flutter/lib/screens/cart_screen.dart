import 'package:flutter/material.dart';

import '../app_state.dart';
import '../cart_controller.dart';
import '../format.dart';
import '../widgets.dart';
import 'checkout_screen.dart';
import 'sign_in_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    if (!await ensureSignedIn(context)) return;
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = CartScope.of(context);
    final lines = cart.lines;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
        actions: [
          if (!cart.isEmpty)
            TextButton(onPressed: cart.clear, child: const Text('Clear cart')),
        ],
      ),
      body: cart.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Add something you like and it will show up here.',
              actionLabel: 'Browse products',
              onAction: () => tabIndex.value = Tabs.shop,
            )
          : MaxWidth(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: lines.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) =>
                    _CartLineTile(line: lines[i], cart: cart),
              ),
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: SafeArea(
                child: MaxWidth(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                cart.itemCount == 1
                                    ? 'Total for 1 item'
                                    : 'Total for ${cart.itemCount} items',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              formatKes(cart.total),
                              style: amountStyle.copyWith(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => _checkout(context),
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line, required this.cart});

  final CartLine line;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = line.product;

    return Dismissible(
      key: ValueKey('cart-${product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: theme.colorScheme.errorContainer,
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) => cart.setQuantity(product, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 76,
              height: 76,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ProductImage(product: product, iconSize: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${formatKes(product.price)} each',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  QuantityStepper(
                    value: line.quantity,
                    min: 0,
                    max: product.stock,
                    onChanged: (v) => cart.setQuantity(product, v),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(formatKes(line.subtotal), style: amountStyle),
          ],
        ),
      ),
    );
  }
}
