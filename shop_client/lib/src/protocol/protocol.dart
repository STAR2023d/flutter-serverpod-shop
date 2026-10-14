/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:shop_client/src/protocol/order_item_request.dart' as _inqli259;
import 'package:shop_client/src/protocol/product.dart' as _i07w3onn;
import 'package:shop_client/src/protocol/shop_order.dart' as _iovzz6mk;
import 'mpesa_payment.dart' as _iglj7b50;
import 'order_item.dart' as _imuez7sb;
import 'order_item_request.dart' as _iwdre74l;
import 'order_status.dart' as _idpqotwg;
import 'payment_status.dart' as _in9mlkkw;
import 'product.dart' as _i8ctgxfn;
import 'shop_exception.dart' as _i5auwboe;
import 'shop_order.dart' as _iokhesfk;
export 'mpesa_payment.dart';
export 'order_item.dart';
export 'order_item_request.dart';
export 'order_status.dart';
export 'payment_status.dart';
export 'product.dart';
export 'shop_exception.dart';
export 'shop_order.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iglj7b50.MpesaPayment) {
      return _iglj7b50.MpesaPayment.fromJson(data) as T;
    }
    if (t == _imuez7sb.OrderItem) {
      return _imuez7sb.OrderItem.fromJson(data) as T;
    }
    if (t == _iwdre74l.OrderItemRequest) {
      return _iwdre74l.OrderItemRequest.fromJson(data) as T;
    }
    if (t == _idpqotwg.OrderStatus) {
      return _idpqotwg.OrderStatus.fromJson(data) as T;
    }
    if (t == _in9mlkkw.PaymentStatus) {
      return _in9mlkkw.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i8ctgxfn.Product) {
      return _i8ctgxfn.Product.fromJson(data) as T;
    }
    if (t == _i5auwboe.ShopException) {
      return _i5auwboe.ShopException.fromJson(data) as T;
    }
    if (t == _iokhesfk.ShopOrder) {
      return _iokhesfk.ShopOrder.fromJson(data) as T;
    }
    if (t == _isc.getType<_iglj7b50.MpesaPayment?>()) {
      return (data != null ? _iglj7b50.MpesaPayment.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imuez7sb.OrderItem?>()) {
      return (data != null ? _imuez7sb.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwdre74l.OrderItemRequest?>()) {
      return (data != null ? _iwdre74l.OrderItemRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idpqotwg.OrderStatus?>()) {
      return (data != null ? _idpqotwg.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in9mlkkw.PaymentStatus?>()) {
      return (data != null ? _in9mlkkw.PaymentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8ctgxfn.Product?>()) {
      return (data != null ? _i8ctgxfn.Product.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5auwboe.ShopException?>()) {
      return (data != null ? _i5auwboe.ShopException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iokhesfk.ShopOrder?>()) {
      return (data != null ? _iokhesfk.ShopOrder.fromJson(data) : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == List<_i07w3onn.Product>) {
      return (data as List)
              .map((e) => deserialize<_i07w3onn.Product>(e))
              .toList()
          as T;
    }
    if (t == List<_inqli259.OrderItemRequest>) {
      return (data as List)
              .map((e) => deserialize<_inqli259.OrderItemRequest>(e))
              .toList()
          as T;
    }
    if (t == List<_iovzz6mk.ShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_iovzz6mk.ShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iglj7b50.MpesaPayment => 'MpesaPayment',
      _imuez7sb.OrderItem => 'OrderItem',
      _iwdre74l.OrderItemRequest => 'OrderItemRequest',
      _idpqotwg.OrderStatus => 'OrderStatus',
      _in9mlkkw.PaymentStatus => 'PaymentStatus',
      _i8ctgxfn.Product => 'Product',
      _i5auwboe.ShopException => 'ShopException',
      _iokhesfk.ShopOrder => 'ShopOrder',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('shop.', '');
    }

    switch (data) {
      case _iglj7b50.MpesaPayment():
        return 'MpesaPayment';
      case _imuez7sb.OrderItem():
        return 'OrderItem';
      case _iwdre74l.OrderItemRequest():
        return 'OrderItemRequest';
      case _idpqotwg.OrderStatus():
        return 'OrderStatus';
      case _in9mlkkw.PaymentStatus():
        return 'PaymentStatus';
      case _i8ctgxfn.Product():
        return 'Product';
      case _i5auwboe.ShopException():
        return 'ShopException';
      case _iokhesfk.ShopOrder():
        return 'ShopOrder';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'MpesaPayment') {
      return deserialize<_iglj7b50.MpesaPayment>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_imuez7sb.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderItemRequest') {
      return deserialize<_iwdre74l.OrderItemRequest>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_idpqotwg.OrderStatus>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_in9mlkkw.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i8ctgxfn.Product>(data['data']);
    }
    if (dataClassName == 'ShopException') {
      return deserialize<_i5auwboe.ShopException>(data['data']);
    }
    if (dataClassName == 'ShopOrder') {
      return deserialize<_iokhesfk.ShopOrder>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('shop', this);
    _iacc.Protocol().registerHostProtocol('shop', this);
  }

  @override
  String getModuleName() => 'shop';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
