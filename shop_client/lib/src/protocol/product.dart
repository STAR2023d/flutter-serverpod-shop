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
import 'package:shop_client/src/protocol/protocol.dart' as _id88xlko;

abstract class Product
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Product._({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.metadata,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory Product({
    int? id,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? imageUrl,
    Map<String, String>? metadata,
    bool? isActive,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      stock: jsonSerialization['stock'] as int,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _id88xlko.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['metadata'],
            ),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String description;

  double price;

  int stock;

  String? imageUrl;

  Map<String, String>? metadata;

  bool isActive;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
    Map<String, String>? metadata,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (metadata != null) 'metadata': metadata?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (metadata != null) 'metadata': metadata?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    int? id,
    required String name,
    required String description,
    required double price,
    required int stock,
    String? imageUrl,
    Map<String, String>? metadata,
    bool? isActive,
  }) : super._(
         id: id,
         name: name,
         description: description,
         price: price,
         stock: stock,
         imageUrl: imageUrl,
         metadata: metadata,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    double? price,
    int? stock,
    Object? imageUrl = _Undefined,
    Object? metadata = _Undefined,
    bool? isActive,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      metadata: metadata is Map<String, String>?
          ? metadata
          : this.metadata?.map((key0, value0) => MapEntry(key0, value0)),
      isActive: isActive ?? this.isActive,
    );
  }
}
