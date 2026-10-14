import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_client/shop_client.dart';

import '../app_state.dart';
import '../cart_controller.dart';
import '../client.dart';
import '../format.dart';
import '../widgets.dart';
import 'product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  static const _pageSize = 20;

  final _search = TextEditingController();
  final _scroll = ScrollController();
  final List<Product> _products = [];

  Timer? _debounce;
  int _requestId = 0;
  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    shopRefreshTick.addListener(_onRefreshRequested);
    _load();
  }

  @override
  void dispose() {
    shopRefreshTick.removeListener(_onRefreshRequested);
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onRefreshRequested() {
    _load();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    if (position.pixels > position.maxScrollExtent - 400) _loadMore();
  }

  void _onSearchChanged(String _) {
    setState(() {}); // shows/hides the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _load);
  }

  Future<void> _load() async {
    final id = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await client.product.listProducts(
        search: _search.text,
        limit: _pageSize,
        offset: 0,
      );
      if (!mounted || id != _requestId) return;
      setState(() {
        _products
          ..clear()
          ..addAll(result);
        _hasMore = result.length == _pageSize;
      });
    } catch (_) {
      if (!mounted || id != _requestId) return;
      setState(() {
        _error = 'Check your internet connection and try again.';
      });
    } finally {
      if (mounted && id == _requestId) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || !_hasMore) return;
    final id = _requestId;
    setState(() => _loadingMore = true);
    try {
      final result = await client.product.listProducts(
        search: _search.text,
        limit: _pageSize,
        offset: _products.length,
      );
      if (!mounted || id != _requestId) return;
      setState(() {
        _products.addAll(result);
        _hasMore = result.length == _pageSize;
      });
    } catch (_) {
      // Keep what we have; scrolling again retries.
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  List<Widget> _bodySlivers() {
    if (_loading && _products.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (_error != null && _products.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.wifi_off_rounded,
            title: 'Could not load products',
            message: _error!,
            actionLabel: 'Try again',
            onAction: _load,
          ),
        ),
      ];
    }
    if (_products.isEmpty) {
      final searching = _search.text.trim().isNotEmpty;
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            icon: Icons.search_off_rounded,
            title: searching ? 'No matches' : 'No products yet',
            message: searching
                ? 'Nothing matches "${_search.text.trim()}". Try a different word.'
                : 'New products will show up here.',
            actionLabel: searching ? 'Clear search' : null,
            onAction: searching
                ? () {
                    _search.clear();
                    _load();
                  }
                : null,
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        sliver: SliverGrid.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 240,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.74,
          ),
          itemCount: _products.length,
          itemBuilder: (context, i) => ProductCard(product: _products[i]),
        ),
      ),
      if (_loadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: const Text('Shop'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(72),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SearchBar(
                    controller: _search,
                    hintText: 'Search products',
                    leading: const Icon(Icons.search),
                    trailing: [
                      if (_search.text.isNotEmpty)
                        IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _search.clear();
                            setState(() {});
                            _load();
                          },
                        ),
                    ],
                    elevation: const WidgetStatePropertyAll<double?>(0),
                    onChanged: _onSearchChanged,
                    onSubmitted: (_) => _load(),
                  ),
                ),
              ),
            ),
            ..._bodySlivers(),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  void _quickAdd(BuildContext context, CartController cart) {
    final added = cart.add(product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: Text(
            added
                ? 'Added to cart'
                : 'No more ${product.name} in stock',
          ),
          action: added
              ? SnackBarAction(
                  label: 'View cart',
                  onPressed: () => tabIndex.value = Tabs.cart,
                )
              : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = CartScope.of(context);
    final inCart = cart.quantityOf(product);
    final soldOut = product.stock <= 0;
    final lowStock = !soldOut && product.stock <= 5;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-${product.id}',
                    child: ProductImage(product: product),
                  ),
                  if (soldOut)
                    Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      alignment: Alignment.center,
                      child: const Text(
                        'Out of stock',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  if (lowStock)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Only ${product.stock} left',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  if (!soldOut)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: IconButton.filled(
                        tooltip: 'Add to cart',
                        onPressed: () => _quickAdd(context, cart),
                        icon: const Icon(Icons.add),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(formatKes(product.price), style: amountStyle),
              ),
              if (inCart > 0)
                Text(
                  '$inCart in cart',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
