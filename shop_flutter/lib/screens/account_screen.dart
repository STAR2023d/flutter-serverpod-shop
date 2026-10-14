import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shop_flutter/screens/admin_products_screen.dart';

import '../app_state.dart';
import '../client.dart';
import '../widgets.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListenableBuilder(
        listenable: client.auth.authInfoListenable,
        builder: (context, _) => MaxWidth(
          width: 480,
          child: client.auth.isAuthenticated
              ? const _SignedIn()
              : const _SignedOut(),
        ),
      ),
    );
  }
}

class _SignedOut extends StatelessWidget {
  const _SignedOut();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Sign in to check out', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Create an account or sign in to place orders and follow them in the app.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        SignInWidget(client: client, onAuthenticated: () {}),
      ],
    );
  }
}

class _SignedIn extends StatefulWidget {
  const _SignedIn();

  @override
  State<_SignedIn> createState() => _SignedInState();
}

class _SignedInState extends State<_SignedIn> {
  bool _isAdmin = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final admin = await client.admin.isAdmin();
      final id = await client.admin.myUserId();
      if (!mounted) return;
      setState(() {
        _isAdmin = admin;
        _userId = id;
      });
    } catch (_) {
      // The extra rows simply stay hidden if this fails.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = _userId;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 36,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text("You're signed in", style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(Icons.receipt_long_outlined),
          title: const Text('My orders'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => tabIndex.value = Tabs.orders,
        ),
        const Divider(height: 1),
        if (_isAdmin) ...[
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Manage products'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
            ),
          ),
          const Divider(height: 1),
        ],
        // Setup helper, only in debug builds: copy this ID into
        // `adminUserIds` in passwords.yaml to become an admin.
        if (kDebugMode && !_isAdmin && userId != null) ...[
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Copy my user ID'),
            subtitle: const Text('Used once to set up the first admin'),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: userId));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('User ID copied')));
            },
          ),
          const Divider(height: 1),
        ],
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sign out'),
          onTap: () async {
            await client.auth.signOutDevice();
          },
        ),
      ],
    );
  }
}
