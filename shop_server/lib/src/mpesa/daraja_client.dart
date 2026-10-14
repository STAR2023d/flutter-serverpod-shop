import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Minimal Daraja (M-Pesa Express) client. Targets the SANDBOX.
class DarajaClient {
  DarajaClient(this.session);

  final Session session;

  static const _base = 'https://sandbox.safaricom.co.ke';

  String _cfg(String key) {
    final value = session.serverpod.getPassword(key)?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('Missing password in passwords.yaml: $key');
    }
    return value;
  }

  /// yyyyMMddHHmmss in Nairobi time (UTC+3).
  String _timestamp() {
    final t = DateTime.now().toUtc().add(const Duration(hours: 3));
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}${two(t.month)}${two(t.day)}'
        '${two(t.hour)}${two(t.minute)}${two(t.second)}';
  }

  Future<String> _accessToken() async {
    final credentials = base64Encode(
      utf8.encode('${_cfg('mpesaConsumerKey')}:${_cfg('mpesaConsumerSecret')}'),
    );
    final res = await http.get(
      Uri.parse('$_base/oauth/v1/generate?grant_type=client_credentials'),
      headers: {'Authorization': 'Basic $credentials'},
    );
    if (res.statusCode != 200) {
      throw StateError(
        'Daraja auth failed (${res.statusCode}) '
        'body="${res.body}" '
        'keyLength=${_cfg('mpesaConsumerKey').length} '
        'secretLength=${_cfg('mpesaConsumerSecret').length}',
      );
    }
    return (jsonDecode(res.body) as Map<String, dynamic>)['access_token']
        as String;
  }

  /// Sends an STK push prompt. Returns Daraja's JSON response.
  Future<Map<String, dynamic>> stkPush({
    required String phone, // 2547XXXXXXXX
    required int amount, // whole KES
    required String accountReference, // max 12 chars
    required String description, // max 13 chars
  }) async {
    final token = await _accessToken();
    final shortcode = _cfg('mpesaShortcode');
    final timestamp = _timestamp();
    final password = base64Encode(
      utf8.encode('$shortcode${_cfg('mpesaPasskey')}$timestamp'),
    );
    final callbackUrl =
        '${_cfg('mpesaCallbackBaseUrl')}/payments/callback/${_cfg('mpesaCallbackToken')}';

    final res = await http.post(
      Uri.parse('$_base/mpesa/stkpush/v1/processrequest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': shortcode,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': 'CustomerPayBillOnline',
        'Amount': amount,
        'PartyA': phone,
        'PartyB': shortcode,
        'PhoneNumber': phone,
        'CallBackURL': callbackUrl,
        'AccountReference': accountReference,
        'TransactionDesc': description,
      }),
    );

    if (res.statusCode != 200) {
      throw StateError('STK push failed (${res.statusCode}): ${res.body}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// Asks Daraja for the result of an STK push. Returns null while the
  /// transaction is still being processed (Daraja answers with an error then).
  Future<Map<String, dynamic>?> stkQuery(String checkoutRequestId) async {
    final token = await _accessToken();
    final shortcode = _cfg('mpesaShortcode');
    final timestamp = _timestamp();
    final password = base64Encode(
      utf8.encode('$shortcode${_cfg('mpesaPasskey')}$timestamp'),
    );

    final res = await http.post(
      Uri.parse('$_base/mpesa/stkpushquery/v1/query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'BusinessShortCode': shortcode,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': checkoutRequestId,
      }),
    );

    if (res.statusCode != 200) {
      session.log('STK query not ready (${res.statusCode}): ${res.body}');
      return null;
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
