/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'payment_status.dart' as _in9mlkkw;

abstract class MpesaPayment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MpesaPayment._({
    this.id,
    required this.orderId,
    required this.phoneNumber,
    required this.amount,
    this.merchantRequestId,
    this.checkoutRequestId,
    _in9mlkkw.PaymentStatus? status,
    this.mpesaReceiptNumber,
    this.resultCode,
    this.resultDesc,
    DateTime? createdAt,
  }) : status = status ?? _in9mlkkw.PaymentStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory MpesaPayment({
    int? id,
    required int orderId,
    required String phoneNumber,
    required int amount,
    String? merchantRequestId,
    String? checkoutRequestId,
    _in9mlkkw.PaymentStatus? status,
    String? mpesaReceiptNumber,
    int? resultCode,
    String? resultDesc,
    DateTime? createdAt,
  }) = _MpesaPaymentImpl;

  factory MpesaPayment.fromJson(Map<String, dynamic> jsonSerialization) {
    return MpesaPayment(
      id: jsonSerialization['id'] as int?,
      orderId: jsonSerialization['orderId'] as int,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      amount: jsonSerialization['amount'] as int,
      merchantRequestId: jsonSerialization['merchantRequestId'] as String?,
      checkoutRequestId: jsonSerialization['checkoutRequestId'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _in9mlkkw.PaymentStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      mpesaReceiptNumber: jsonSerialization['mpesaReceiptNumber'] as String?,
      resultCode: jsonSerialization['resultCode'] as int?,
      resultDesc: jsonSerialization['resultDesc'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int orderId;

  String phoneNumber;

  int amount;

  String? merchantRequestId;

  String? checkoutRequestId;

  _in9mlkkw.PaymentStatus status;

  String? mpesaReceiptNumber;

  int? resultCode;

  String? resultDesc;

  DateTime createdAt;

  /// Returns a shallow copy of this [MpesaPayment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MpesaPayment copyWith({
    int? id,
    int? orderId,
    String? phoneNumber,
    int? amount,
    String? merchantRequestId,
    String? checkoutRequestId,
    _in9mlkkw.PaymentStatus? status,
    String? mpesaReceiptNumber,
    int? resultCode,
    String? resultDesc,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MpesaPayment',
      if (id != null) 'id': id,
      'orderId': orderId,
      'phoneNumber': phoneNumber,
      'amount': amount,
      if (merchantRequestId != null) 'merchantRequestId': merchantRequestId,
      if (checkoutRequestId != null) 'checkoutRequestId': checkoutRequestId,
      'status': status.toJson(),
      if (mpesaReceiptNumber != null) 'mpesaReceiptNumber': mpesaReceiptNumber,
      if (resultCode != null) 'resultCode': resultCode,
      if (resultDesc != null) 'resultDesc': resultDesc,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MpesaPayment',
      if (id != null) 'id': id,
      'orderId': orderId,
      'phoneNumber': phoneNumber,
      'amount': amount,
      if (merchantRequestId != null) 'merchantRequestId': merchantRequestId,
      if (checkoutRequestId != null) 'checkoutRequestId': checkoutRequestId,
      'status': status.toJson(),
      if (mpesaReceiptNumber != null) 'mpesaReceiptNumber': mpesaReceiptNumber,
      if (resultCode != null) 'resultCode': resultCode,
      if (resultDesc != null) 'resultDesc': resultDesc,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MpesaPaymentImpl extends MpesaPayment {
  _MpesaPaymentImpl({
    int? id,
    required int orderId,
    required String phoneNumber,
    required int amount,
    String? merchantRequestId,
    String? checkoutRequestId,
    _in9mlkkw.PaymentStatus? status,
    String? mpesaReceiptNumber,
    int? resultCode,
    String? resultDesc,
    DateTime? createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         phoneNumber: phoneNumber,
         amount: amount,
         merchantRequestId: merchantRequestId,
         checkoutRequestId: checkoutRequestId,
         status: status,
         mpesaReceiptNumber: mpesaReceiptNumber,
         resultCode: resultCode,
         resultDesc: resultDesc,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MpesaPayment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MpesaPayment copyWith({
    Object? id = _Undefined,
    int? orderId,
    String? phoneNumber,
    int? amount,
    Object? merchantRequestId = _Undefined,
    Object? checkoutRequestId = _Undefined,
    _in9mlkkw.PaymentStatus? status,
    Object? mpesaReceiptNumber = _Undefined,
    Object? resultCode = _Undefined,
    Object? resultDesc = _Undefined,
    DateTime? createdAt,
  }) {
    return MpesaPayment(
      id: id is int? ? id : this.id,
      orderId: orderId ?? this.orderId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      amount: amount ?? this.amount,
      merchantRequestId: merchantRequestId is String?
          ? merchantRequestId
          : this.merchantRequestId,
      checkoutRequestId: checkoutRequestId is String?
          ? checkoutRequestId
          : this.checkoutRequestId,
      status: status ?? this.status,
      mpesaReceiptNumber: mpesaReceiptNumber is String?
          ? mpesaReceiptNumber
          : this.mpesaReceiptNumber,
      resultCode: resultCode is int? ? resultCode : this.resultCode,
      resultDesc: resultDesc is String? ? resultDesc : this.resultDesc,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
