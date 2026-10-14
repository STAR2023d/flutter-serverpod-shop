import 'package:flutter/material.dart';
import 'package:shop_client/shop_client.dart';

import '../app_state.dart';
import '../client.dart';
import '../format.dart';
import '../widgets.dart';
import 'product_form_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  List<Product>? _products;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final result = await client.product.listProducts(limit: 100, offset: 0);
      if (!mounted) return;
      setState(() => _products = result);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Could not load products. Check your connection and try again.',
        );
      }
    }
  }

  Future<void> _open([Product? product]) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ProductFormScreen(product: product)),
    );
    if (changed == true) {
      shopRefreshTick.value++; // refresh the Shop tab too
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(),
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final products = _products;
    if (products == null && _error == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products == null) {
      return EmptyState(
        icon: Icons.wifi_off_rounded,
        title: 'Could not load products',
        message: _error!,
        actionLabel: 'Try again',
        onAction: _load,
      );
    }
    if (products.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'No products yet',
        message: 'Add your first product and it appears in the shop at once.',
        actionLabel: 'Add your first product',
        onAction: () => _open(),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: MaxWidth(
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 96),
          itemCount: products.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final p = products[i];
            return ListTile(
              leading: SizedBox(
                width: 48,
                height: 48,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProductImage(product: p, iconSize: 22),
                ),
              ),
              title: Text(p.name),
              subtitle: Text('${formatKes(p.price)}, ${p.stock} in stock'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _open(p),
            );
          },
        ),
      ),
    );
  }
}
