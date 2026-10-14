import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../mpesa/payment_processor.dart';

/// Receives Daraja's STK push result. Always answers 200 so Daraja
/// does not retry; problems are logged.
class DarajaCallbackRoute extends Route {
  DarajaCallbackRoute() : super(methods: {Method.post});

  static const _ack = '{"ResultCode":0,"ResultDesc":"Accepted"}';

  @override
  Future<Result> handleCall(Session session, Request request) async {
    try {
      final raw = await request.readAsString();
      session.log('Daraja callback received.');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final cb =
          (json['Body'] as Map<String, dynamic>)['stkCallback']
              as Map<String, dynamic>;

      final checkoutId = cb['CheckoutRequestID'] as String?;
      final resultCode = (cb['ResultCode'] as num?)?.toInt();

      if (checkoutId != null && resultCode != null) {
        String? receipt;
        num? paidAmount;
        final metadata = cb['CallbackMetadata'] as Map<String, dynamic>?;
        final items = (metadata?['Item'] as List<dynamic>?) ?? const [];
        for (final item in items) {
          final m = item as Map<String, dynamic>;
          if (m['Name'] == 'MpesaReceiptNumber') {
            receipt = m['Value']?.toString();
          }
          if (m['Name'] == 'Amount') paidAmount = m['Value'] as num?;
        }

        await applyPaymentResult(
          session,
          checkoutRequestId: checkoutId,
          resultCode: resultCode,
          resultDesc: cb['ResultDesc'] as String?,
          receipt: receipt,
          paidAmount: paidAmount,
          requireAmountMatch: true,
        );
      }
    } catch (e, st) {
      session.log(
        'Daraja callback error: $e',
        level: LogLevel.error,
        exception: e,
        stackTrace: st,
      );
    }
    return Response.ok(body: Body.fromString(_ack));
  }
}
