import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Applies the outcome of an STK push to the payment and its order.
/// Safe to call more than once for the same payment (idempotent).
///
/// [requireAmountMatch] should be true for callbacks (which report the paid
/// amount) and false for STK query results (which don't).
Future<void> applyPaymentResult(
  Session session, {
  required String checkoutRequestId,
  required int resultCode,
  String? resultDesc,
  String? receipt,
  num? paidAmount,
  bool requireAmountMatch = false,
}) async {
  await session.db.transaction((tx) async {
    final payment = await MpesaPayment.db.findFirstRow(
      session,
      where: (t) => t.checkoutRequestId.equals(checkoutRequestId),
      lockMode: LockMode.forUpdate,
      transaction: tx,
    );
    if (payment == null) {
      session.log(
        'Result for unknown CheckoutRequestID $checkoutRequestId',
        level: LogLevel.warning,
      );
      return;
    }
    if (payment.status != PaymentStatus.pending) return; // already handled

    final order = await ShopOrder.db.findById(
      session,
      payment.orderId,
      transaction: tx,
    );

    payment.resultCode = resultCode;
    payment.resultDesc = resultDesc;

    if (resultCode == 0) {
      if (requireAmountMatch &&
          (paidAmount == null || paidAmount.round() != payment.amount)) {
        session.log(
          'Amount mismatch for $checkoutRequestId: paid $paidAmount, '
          'expected ${payment.amount}',
          level: LogLevel.error,
        );
        return; // leave pending for manual review
      }
      payment.status = PaymentStatus.success;
      payment.mpesaReceiptNumber = receipt;
      await MpesaPayment.db.updateRow(session, payment, transaction: tx);

      if (order != null && order.status == OrderStatus.pending) {
        order.status = OrderStatus.paid;
        await ShopOrder.db.updateRow(session, order, transaction: tx);
      }
      session.log('Payment $checkoutRequestId succeeded.');
      return;
    }

    // Failed / cancelled (1032 = cancelled by the customer).
    payment.status = resultCode == 1032
        ? PaymentStatus.cancelled
        : PaymentStatus.failed;
    await MpesaPayment.db.updateRow(session, payment, transaction: tx);

    if (order != null && order.status == OrderStatus.pending) {
      order.status = OrderStatus.cancelled;
      await ShopOrder.db.updateRow(session, order, transaction: tx);

      // Give the reserved stock back.
      final orderItems = await OrderItem.db.find(
        session,
        where: (t) => t.orderId.equals(order.id!),
        transaction: tx,
      );
      final quantities = {for (final i in orderItems) i.productId: i.quantity};
      final products = await Product.db.find(
        session,
        where: (t) => t.id.inSet(quantities.keys.toSet()),
        orderBy: (t) => t.id,
        lockMode: LockMode.forUpdate,
        transaction: tx,
      );
      for (final p in products) {
        p.stock += quantities[p.id!] ?? 0;
      }
      await Product.db.update(
        session,
        products,
        columns: (t) => [t.stock],
        transaction: tx,
      );
    }
    session.log('Payment $checkoutRequestId ended: $resultCode $resultDesc');
  });
}
