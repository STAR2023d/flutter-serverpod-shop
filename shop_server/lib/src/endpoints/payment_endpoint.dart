import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../mpesa/daraja_client.dart';
import '../mpesa/payment_processor.dart';
import '../mpesa/phone.dart';

class PaymentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  UuidValue _userId(Session session) =>
      UuidValue.fromString(session.authenticated!.userIdentifier);

  /// Development-only: pretend to be M-Pesa (see passwords.yaml).
  bool _simulating(Session session) =>
      session.serverpod.runMode == 'development' &&
      session.serverpod.getPassword('mpesaSimulate') == 'true';

  /// Sends an M-Pesa STK push for one of the signed-in user's pending orders.
  Future<MpesaPayment> startMpesaPayment(
    Session session,
    int orderId,
    String phoneNumber,
  ) async {
    final order = await ShopOrder.db.findById(session, orderId);
    if (order == null || order.userId != _userId(session)) {
      throw ShopException(message: 'Order not found.');
    }
    if (order.status != OrderStatus.pending) {
      throw ShopException(message: 'This order cannot be paid.');
    }

    final phone = normalizeKenyanPhone(phoneNumber);
    if (phone == null) {
      throw ShopException(
        message: 'Enter a valid Safaricom number, e.g. 0712345678.',
      );
    }

    final amount = order.totalAmount.round(); // STK requires whole KES
    if (amount < 1) {
      throw ShopException(message: 'Order amount is too small to pay.');
    }

    // Block double prompts: already paid, or a prompt sent in the last 90s.
    final recent = await MpesaPayment.db.find(
      session,
      where: (t) => t.orderId.equals(orderId),
    );
    for (final p in recent) {
      final fresh =
          DateTime.now().difference(p.createdAt) < const Duration(seconds: 90);
      if (p.status == PaymentStatus.success ||
          (p.status == PaymentStatus.pending && fresh)) {
        throw ShopException(
          message: 'A payment for this order is already in progress or done.',
        );
      }
    }

    if (_simulating(session)) {
      return _simulatePayment(
        session,
        orderId: orderId,
        phone: phone,
        amount: amount,
      );
    }

    final Map<String, dynamic> res;
    try {
      res = await DarajaClient(session).stkPush(
        phone: phone,
        amount: amount,
        accountReference: 'ORDER${order.id}',
        description: 'Shop order',
      );
    } catch (e) {
      session.log('STK push failed: $e', level: LogLevel.error);
      throw ShopException(
        message: 'Could not start the M-Pesa payment. Please try again.',
      );
    }

    if ('${res['ResponseCode']}' != '0') {
      session.log('STK push rejected: $res', level: LogLevel.error);
      throw ShopException(
        message:
            (res['CustomerMessage'] as String?) ??
            'M-Pesa rejected the request.',
      );
    }

    final saved = await MpesaPayment.db.insertRow(
      session,
      MpesaPayment(
        orderId: orderId,
        phoneNumber: phone,
        amount: amount,
        merchantRequestId: res['MerchantRequestID'] as String?,
        checkoutRequestId: res['CheckoutRequestID'] as String?,
      ),
    );
    session.log(
      'STK push accepted for order $orderId: '
      'checkoutRequestId=${saved.checkoutRequestId}, amount=$amount',
    );
    return saved;
  }

  /// Fake payment for development. Succeeds after 6 seconds, unless the phone
  /// number ends in 0000, which simulates the customer cancelling.
  Future<MpesaPayment> _simulatePayment(
    Session session, {
    required int orderId,
    required String phone,
    required int amount,
  }) async {
    final checkoutId = 'SIM-$orderId-${DateTime.now().millisecondsSinceEpoch}';
    final cancel = phone.endsWith('0000');

    final saved = await MpesaPayment.db.insertRow(
      session,
      MpesaPayment(
        orderId: orderId,
        phoneNumber: phone,
        amount: amount,
        merchantRequestId: 'SIM',
        checkoutRequestId: checkoutId,
      ),
    );
    session.log(
      'SIMULATION: payment $checkoutId will '
      '${cancel ? 'be cancelled' : 'succeed'} in 6 seconds.',
    );

    final pod = session.serverpod;
    Timer(const Duration(seconds: 6), () async {
      final simulationSession = await pod.createSession(enableLogging: false);
      try {
        await applyPaymentResult(
          simulationSession,
          checkoutRequestId: checkoutId,
          resultCode: cancel ? 1032 : 0,
          resultDesc: cancel
              ? 'Request cancelled by user'
              : 'The service request is processed successfully.',
          receipt: cancel
              ? null
              : 'SIM${DateTime.now().millisecondsSinceEpoch % 1000000}',
          paidAmount: amount,
          requireAmountMatch: true,
        );
      } catch (e) {
        simulationSession.log('Simulation failed: $e', level: LogLevel.error);
      } finally {
        await simulationSession.close();
      }
    });

    return saved;
  }

  /// Latest payment attempt for one of the signed-in user's orders.
  /// If a real payment is still pending after 15s, asks Daraja directly in
  /// case the callback was lost.
  Future<MpesaPayment?> getPaymentStatus(Session session, int orderId) async {
    final order = await ShopOrder.db.findById(session, orderId);
    if (order == null || order.userId != _userId(session)) return null;

    final payment = await MpesaPayment.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderId),
      orderBy: (t) => t.createdAt.desc(),
    );
    if (payment == null) return null;

    final checkoutId = payment.checkoutRequestId;
    final age = DateTime.now().difference(payment.createdAt);
    if (payment.status == PaymentStatus.pending &&
        checkoutId != null &&
        !checkoutId.startsWith('SIM-') &&
        age > const Duration(seconds: 15)) {
      try {
        final result = await DarajaClient(session).stkQuery(checkoutId);
        final code = int.tryParse('${result?['ResultCode']}');
        if (code != null) {
          var applyPaymentResult2 = applyPaymentResult;
          await applyPaymentResult2(
            session,
            checkoutRequestId: checkoutId,
            resultCode: code,
            resultDesc: result?['ResultDesc'] as String?,
          );
          return MpesaPayment.db.findById(session, payment.id!);
        }
      } catch (e) {
        session.log('STK query failed: $e', level: LogLevel.warning);
      }
    }
    return payment;
  }
}
