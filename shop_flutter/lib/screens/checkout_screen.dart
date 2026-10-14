import 'package:flutter/material.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:shop_client/shop_client.dart';

import '../app_state.dart';
import '../cart_controller.dart';
import '../client.dart';
import '../format.dart';
import '../widgets.dart';

enum _Stage { form, processing, success, failed, timedOut }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController(text: '07');

  _Stage _stage = _Stage.form;
  String _statusText = '';
  String? _formError;
  String? _failureMessage;
  String? _receipt;
  int? _orderId; // kept so a retry reuses the same pending order
  double _paidTotal = 0;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    final ok =
        (digits.startsWith('0') && digits.length == 10) ||
        (digits.startsWith('254') && digits.length == 12) ||
        ((digits.startsWith('7') || digits.startsWith('1')) &&
            digits.length == 9);
    return ok ? null : 'Enter a Safaricom number like 0712 345 678';
  }

  Future<MpesaPayment?> _waitForResult(int orderId) async {
    for (var i = 0; i < 20; i++) {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return null;
      try {
        final payment = await client.payment.getPaymentStatus(orderId);
        if (payment != null && payment.status != PaymentStatus.pending) {
          return payment;
        }
      } catch (_) {
        // A network blip should not end the wait; try again.
      }
    }
    return null;
  }

  void _backToForm(String message) {
    if (!mounted) return;
    setState(() {
      _stage = _Stage.form;
      _formError = message;
    });
  }

  Future<void> _pay() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cart = CartScope.of(context);
    final items = [
      for (final line in cart.lines)
        OrderItemRequest(productId: line.product.id!, quantity: line.quantity),
    ];

    setState(() {
      _stage = _Stage.processing;
      _formError = null;
      _statusText = 'Creating your order';
    });

    try {
      var orderId = _orderId;
      if (orderId == null) {
        final order = await client.order.createOrder(items);
        orderId = order.id!;
        _orderId = orderId;
      }
      if (!mounted) return;
      setState(() => _statusText = 'Sending the M-Pesa request');

      final started = await client.payment.startMpesaPayment(
        orderId,
        _phone.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _statusText = started.merchantRequestId == 'SIM'
            ? 'Test mode: simulating the M-Pesa prompt. '
                  'No real prompt is sent and no money moves.'
            : 'Check your phone and enter your M-Pesa PIN';
      });

      final result = await _waitForResult(orderId);
      if (!mounted) return;
      shopRefreshTick.value++;

      if (result == null) {
        cart.clear(); // the order exists; avoid creating a duplicate
        setState(() => _stage = _Stage.timedOut);
      } else if (result.status == PaymentStatus.success) {
        cart.clear();
        setState(() {
          _receipt = result.mpesaReceiptNumber;
          _paidTotal = result.amount.toDouble(); // what M-Pesa really charged
          _stage = _Stage.success;
        });
      } else {
        _orderId = null; // the server cancelled it and returned the stock
        setState(() {
          _failureMessage =
              result.resultDesc ?? 'The payment was not completed.';
          _stage = _Stage.failed;
        });
      }
    } on ShopException catch (e) {
      _backToForm(e.message);
    } on ServerpodClientException catch (e) {
      _backToForm(
        'Could not reach the server (${e.message}). '
        'Check your connection and try again.',
      );
    } catch (_) {
      _backToForm('Something went wrong. Please try again.');
    }
  }

  void _finish(int tab) {
    tabIndex.value = tab;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final canGoBack = _stage == _Stage.form || _stage == _Stage.failed;
    return PopScope(
      canPop: _stage != _Stage.processing,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          automaticallyImplyLeading: canGoBack,
        ),
        body: SafeArea(
          child: MaxWidth(
            width: 560,
            child: switch (_stage) {
              _Stage.form => _buildForm(context),
              _Stage.processing => _buildProcessing(context),
              _Stage.success => _buildSuccess(context),
              _Stage.failed => _buildFailed(context),
              _Stage.timedOut => _buildTimedOut(context),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    final cart = CartScope.of(context);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Order summary', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                for (final line in cart.lines)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${line.quantity} × ${line.product.name}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(formatKes(line.subtotal), style: amountStyle),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        formatKes(cart.total),
                        style: amountStyle.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Pay with M-Pesa', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'We will send a payment request to this number.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            decoration: InputDecoration(
              labelText: 'M-Pesa phone number',
              prefixIcon: const Icon(Icons.phone_android),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: _validatePhone,
          ),
          if (_formError != null)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _formError!,
                        style: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: cart.isEmpty ? null : _pay,
              child: Text('Pay ${formatKes(cart.total)} with M-Pesa'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing(BuildContext context) {
    final theme = Theme.of(context);
    final cart = CartScope.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
            const SizedBox(height: 28),
            Text(
              formatKes(cart.total),
              style: theme.textTheme.headlineMedium?.merge(amountStyle),
            ),
            const SizedBox(height: 12),
            Text(
              _statusText,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Keep this screen open until the payment is confirmed.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    final receipt = _receipt;
    final isTest = receipt != null && receipt.startsWith('SIM');
    final amount = formatKes(_paidTotal);

    return _ResultView(
      icon: Icons.check_circle_rounded,
      color: Colors.green.shade600,
      title: isTest ? 'Test payment received' : 'Payment received',
      message: isTest
          ? 'This was a simulated payment, so no M-Pesa prompt was sent and '
                'no money moved. Order #$_orderId is marked as paid so you can '
                'test the rest of the app.'
          : receipt == null
          ? 'Thank you. We received $amount for order #$_orderId.'
          : 'Thank you. We received $amount for order #$_orderId. '
                'M-Pesa receipt: $receipt.',
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => _finish(Tabs.orders),
            child: const Text('View my orders'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _finish(Tabs.shop),
          child: const Text('Continue shopping'),
        ),
      ],
    );
  }

  Widget _buildFailed(BuildContext context) {
    return _ResultView(
      icon: Icons.error_rounded,
      color: Theme.of(context).colorScheme.error,
      title: 'Payment not completed',
      message:
          '${_failureMessage ?? 'The payment did not go through.'} '
          'You were not charged. Your items are still in your cart.',
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => setState(() => _stage = _Stage.form),
            child: const Text('Try again'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back to cart'),
        ),
      ],
    );
  }

  Widget _buildTimedOut(BuildContext context) {
    return _ResultView(
      icon: Icons.hourglass_top_rounded,
      color: Colors.orange.shade700,
      title: 'Still waiting for M-Pesa',
      message:
          'We have not received a confirmation for order #$_orderId yet. '
          'If you paid, the order updates on its own. '
          'Check My orders in a minute to see its status.',
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => _finish(Tabs.orders),
            child: const Text('View my orders'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _finish(Tabs.shop),
          child: const Text('Back to shop'),
        ),
      ],
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.actions,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 88, color: color),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            ...actions,
          ],
        ),
      ),
    );
  }
}
