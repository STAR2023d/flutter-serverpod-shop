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
import 'package:serverpod/serverpod.dart' as _is;
import 'order_status.dart' as _idpqotwg;

abstract class ShopOrder
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ShopOrder._({
    this.id,
    required this.userId,
    required this.totalAmount,
    _idpqotwg.OrderStatus? status,
    DateTime? createdAt,
  }) : status = status ?? _idpqotwg.OrderStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory ShopOrder({
    int? id,
    required _is.UuidValue userId,
    required double totalAmount,
    _idpqotwg.OrderStatus? status,
    DateTime? createdAt,
  }) = _ShopOrderImpl;

  factory ShopOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopOrder(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      status: jsonSerialization['status'] == null
          ? null
          : _idpqotwg.OrderStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ShopOrderTable();

  static const db = ShopOrderRepository._();

  @override
  int? id;

  _is.UuidValue userId;

  double totalAmount;

  _idpqotwg.OrderStatus status;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShopOrder copyWith({
    int? id,
    _is.UuidValue? userId,
    double? totalAmount,
    _idpqotwg.OrderStatus? status,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopOrder',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'totalAmount': totalAmount,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopOrder',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'totalAmount': totalAmount,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ShopOrderInclude include() {
    return ShopOrderInclude._();
  }

  static ShopOrderIncludeList includeList({
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    ShopOrderInclude? include,
  }) {
    return ShopOrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopOrderImpl extends ShopOrder {
  _ShopOrderImpl({
    int? id,
    required _is.UuidValue userId,
    required double totalAmount,
    _idpqotwg.OrderStatus? status,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         totalAmount: totalAmount,
         status: status,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShopOrder copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    double? totalAmount,
    _idpqotwg.OrderStatus? status,
    DateTime? createdAt,
  }) {
    return ShopOrder(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ShopOrderUpdateTable extends _is.UpdateTable<ShopOrderTable> {
  ShopOrderUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(table.userId, value);

  _is.ColumnValue<double, double> totalAmount(double value) =>
      _is.ColumnValue(table.totalAmount, value);

  _is.ColumnValue<_idpqotwg.OrderStatus, _idpqotwg.OrderStatus> status(
    _idpqotwg.OrderStatus value,
  ) => _is.ColumnValue(table.status, value);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(table.createdAt, value);
}

class ShopOrderTable extends _is.Table<int?> {
  ShopOrderTable({super.tableRelation}) : super(tableName: 'shop_order') {
    updateTable = ShopOrderUpdateTable(this);
    userId = _is.ColumnUuid('userId', this);
    totalAmount = _is.ColumnDouble('totalAmount', this);
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime('createdAt', this, hasDefault: true);
  }

  late final ShopOrderUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnDouble totalAmount;

  late final _is.ColumnEnum<_idpqotwg.OrderStatus> status;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [id, userId, totalAmount, status, createdAt];
}

class ShopOrderInclude extends _is.IncludeObject {
  ShopOrderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ShopOrder.t;
}

class ShopOrderIncludeList extends _is.IncludeList {
  ShopOrderIncludeList._({
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ShopOrder.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ShopOrder.t;
}

class ShopOrderRepository {
  const ShopOrderRepository._();

  /// Returns a list of [ShopOrder]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ShopOrder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ShopOrder>(
      where: where?.call(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ShopOrder] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ShopOrder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ShopOrder>(
      where: where?.call(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ShopOrder] by its [id] or null if no such row exists.
  Future<ShopOrder?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ShopOrder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ShopOrder]s in the list and returns the inserted rows.
  ///
  /// The returned [ShopOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> insert(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ShopOrder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ShopOrder] and returns the inserted row.
  ///
  /// The returned [ShopOrder] will have its `id` field set.
  Future<ShopOrder> insertRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ShopOrder>(row, transaction: transaction);
  }

  /// Upserts all [ShopOrder]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ShopOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> upsert(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    required _is.ColumnSelections<ShopOrderTable> conflictColumns,
    _is.ColumnSelections<ShopOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<ShopOrderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ShopOrder>(
      rows,
      conflictColumns: conflictColumns(ShopOrder.t),
      updateColumns: updateColumns?.call(ShopOrder.t),
      updateWhere: updateWhere?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ShopOrder] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ShopOrder] will have its `id` field set.
  Future<ShopOrder?> upsertRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    required _is.ColumnSelections<ShopOrderTable> conflictColumns,
    _is.ColumnSelections<ShopOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<ShopOrderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ShopOrder>(
      row,
      conflictColumns: conflictColumns(ShopOrder.t),
      updateColumns: updateColumns?.call(ShopOrder.t),
      updateWhere: updateWhere?.call(ShopOrder.t),
      transaction: transaction,
    );
  }

  /// Updates all [ShopOrder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> update(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    _is.ColumnSelections<ShopOrderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ShopOrder>(
      rows,
      columns: columns?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ShopOrder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ShopOrder> updateRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    _is.ColumnSelections<ShopOrderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ShopOrder>(
      row,
      columns: columns?.call(ShopOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ShopOrder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ShopOrder?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ShopOrderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ShopOrder>(
      id,
      columnValues: columnValues(ShopOrder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ShopOrder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ShopOrderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ShopOrderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ShopOrder>(
      columnValues: columnValues(ShopOrder.t.updateTable),
      where: where(ShopOrder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ShopOrder]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> delete(
    _is.DatabaseSession session,
    List<ShopOrder> rows, {
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ShopOrder>(
      rows,
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ShopOrder].
  Future<ShopOrder> deleteRow(
    _is.DatabaseSession session,
    ShopOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ShopOrder>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ShopOrder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShopOrderTable> where,
    _is.OrderByBuilder<ShopOrderTable>? orderBy,
    _is.OrderByListBuilder<ShopOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ShopOrder>(
      where: where(ShopOrder.t),
      orderBy: orderBy?.call(ShopOrder.t),
      orderByList: orderByList?.call(ShopOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ShopOrderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ShopOrder>(
      where: where?.call(ShopOrder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ShopOrder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ShopOrderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ShopOrder>(
      where: where(ShopOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
