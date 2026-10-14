import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shop_client/shop_client.dart';

import '../app_state.dart';
import '../client.dart';
import '../format.dart';
import '../widgets.dart';
import 'sign_in_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<ShopOrder>? _orders;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    tabIndex.addListener(_onTabChanged);
    if (client.auth.isAuthenticated) _load();
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    tabIndex.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    if (client.auth.isAuthenticated) {
      _load();
    } else {
      setState(() {
        _orders = null;
        _error = null;
      });
    }
  }

  // Refresh whenever the user opens this tab, so new payments show up.
  void _onTabChanged() {
    if (tabIndex.value == Tabs.orders && client.auth.isAuthenticated) _load();
  }

  Future<void> _load() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final orders = await client.order.myOrders();
      if (!mounted) return;
      setState(() => _orders = orders);
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Check your internet connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: ListenableBuilder(
        listenable: client.auth.authInfoListenable,
        builder: (context, _) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Sign in to see your orders',
        message: 'Your orders and their payment status appear here.',
        actionLabel: 'Sign in',
        onAction: () {
          ensureSignedIn(context);
        },
      );
    }

    final orders = _orders;
    if (orders == null && _error == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (orders == null) {
      return EmptyState(
        icon: Icons.wifi_off_rounded,
        title: 'Could not load your orders',
        message: _error!,
        actionLabel: 'Try again',
        onAction: _load,
      );
    }
    if (orders.isEmpty) {
      return EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No orders yet',
        message: 'When you place an order, you can follow it here.',
        actionLabel: 'Start shopping',
        onAction: () => tabIndex.value = Tabs.shop,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: MaxWidth(
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) => _OrderRow(order: orders[i]),
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final ShopOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order #${order.id}', style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  formatDate(order.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatKes(order.totalAmount), style: amountStyle),
              const SizedBox(height: 6),
              StatusChip(order.status),
            ],
          ),
        ],
      ),
    );
  }
}
