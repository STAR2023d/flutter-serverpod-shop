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
import 'payment_status.dart' as _in9mlkkw;

abstract class MpesaPayment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = MpesaPaymentTable();

  static const db = MpesaPaymentRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MpesaPayment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static MpesaPaymentInclude include() {
    return MpesaPaymentInclude._();
  }

  static MpesaPaymentIncludeList includeList({
    _is.WhereExpressionBuilder<MpesaPaymentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MpesaPaymentTable>? orderBy,
    _is.OrderByListBuilder<MpesaPaymentTable>? orderByList,
    MpesaPaymentInclude? include,
  }) {
    return MpesaPaymentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MpesaPayment.t),
      orderByList: orderByList?.call(MpesaPayment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class MpesaPaymentUpdateTable extends _is.UpdateTable<MpesaPaymentTable> {
  MpesaPaymentUpdateTable(super.table);

  _is.ColumnValue<int, int> orderId(int value) =>
      _is.ColumnValue(table.orderId, value);

  _is.ColumnValue<String, String> phoneNumber(String value) =>
      _is.ColumnValue(table.phoneNumber, value);

  _is.ColumnValue<int, int> amount(int value) =>
      _is.ColumnValue(table.amount, value);

  _is.ColumnValue<String, String> merchantRequestId(String? value) =>
      _is.ColumnValue(table.merchantRequestId, value);

  _is.ColumnValue<String, String> checkoutRequestId(String? value) =>
      _is.ColumnValue(table.checkoutRequestId, value);

  _is.ColumnValue<_in9mlkkw.PaymentStatus, _in9mlkkw.PaymentStatus> status(
    _in9mlkkw.PaymentStatus value,
  ) => _is.ColumnValue(table.status, value);

  _is.ColumnValue<String, String> mpesaReceiptNumber(String? value) =>
      _is.ColumnValue(table.mpesaReceiptNumber, value);

  _is.ColumnValue<int, int> resultCode(int? value) =>
      _is.ColumnValue(table.resultCode, value);

  _is.ColumnValue<String, String> resultDesc(String? value) =>
      _is.ColumnValue(table.resultDesc, value);

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(table.createdAt, value);
}

class MpesaPaymentTable extends _is.Table<int?> {
  MpesaPaymentTable({super.tableRelation}) : super(tableName: 'mpesa_payment') {
    updateTable = MpesaPaymentUpdateTable(this);
    orderId = _is.ColumnInt('orderId', this);
    phoneNumber = _is.ColumnString('phoneNumber', this);
    amount = _is.ColumnInt('amount', this);
    merchantRequestId = _is.ColumnString('merchantRequestId', this);
    checkoutRequestId = _is.ColumnString('checkoutRequestId', this);
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    mpesaReceiptNumber = _is.ColumnString('mpesaReceiptNumber', this);
    resultCode = _is.ColumnInt('resultCode', this);
    resultDesc = _is.ColumnString('resultDesc', this);
    createdAt = _is.ColumnDateTime('createdAt', this, hasDefault: true);
  }

  late final MpesaPaymentUpdateTable updateTable;

  late final _is.ColumnInt orderId;

  late final _is.ColumnString phoneNumber;

  late final _is.ColumnInt amount;

  late final _is.ColumnString merchantRequestId;

  late final _is.ColumnString checkoutRequestId;

  late final _is.ColumnEnum<_in9mlkkw.PaymentStatus> status;

  late final _is.ColumnString mpesaReceiptNumber;

  late final _is.ColumnInt resultCode;

  late final _is.ColumnString resultDesc;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    orderId,
    phoneNumber,
    amount,
    merchantRequestId,
    checkoutRequestId,
    status,
    mpesaReceiptNumber,
    resultCode,
    resultDesc,
    createdAt,
  ];
}

class MpesaPaymentInclude extends _is.IncludeObject {
  MpesaPaymentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MpesaPayment.t;
}

class MpesaPaymentIncludeList extends _is.IncludeList {
  MpesaPaymentIncludeList._({
    _is.WhereExpressionBuilder<MpesaPaymentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MpesaPayment.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MpesaPayment.t;
}

class MpesaPaymentRepository {
  const MpesaPaymentRepository._();

  /// Returns a list of [MpesaPayment]s matching the given query parameters.
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
  Future<List<MpesaPayment>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MpesaPaymentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MpesaPaymentTable>? orderBy,
    _is.OrderByListBuilder<MpesaPaymentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MpesaPayment>(
      where: where?.call(MpesaPayment.t),
      orderBy: orderBy?.call(MpesaPayment.t),
      orderByList: orderByList?.call(MpesaPayment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MpesaPayment] matching the given query parameters.
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
  Future<MpesaPayment?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MpesaPaymentTable>? where,
    int? offset,
    _is.OrderByBuilder<MpesaPaymentTable>? orderBy,
    _is.OrderByListBuilder<MpesaPaymentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MpesaPayment>(
      where: where?.call(MpesaPayment.t),
      orderBy: orderBy?.call(MpesaPayment.t),
      orderByList: orderByList?.call(MpesaPayment.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MpesaPayment] by its [id] or null if no such row exists.
  Future<MpesaPayment?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MpesaPayment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MpesaPayment]s in the list and returns the inserted rows.
  ///
  /// The returned [MpesaPayment]s will have their `id` fields set.
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
  Future<List<MpesaPayment>> insert(
    _is.DatabaseSession session,
    List<MpesaPayment> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MpesaPayment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MpesaPayment] and returns the inserted row.
  ///
  /// The returned [MpesaPayment] will have its `id` field set.
  Future<MpesaPayment> insertRow(
    _is.DatabaseSession session,
    MpesaPayment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MpesaPayment>(row, transaction: transaction);
  }

  /// Upserts all [MpesaPayment]s in the list and returns the resulting rows.
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
  /// The returned [MpesaPayment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MpesaPayment>> upsert(
    _is.DatabaseSession session,
    List<MpesaPayment> rows, {
    required _is.ColumnSelections<MpesaPaymentTable> conflictColumns,
    _is.ColumnSelections<MpesaPaymentTable>? updateColumns,
    _is.WhereExpressionBuilder<MpesaPaymentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MpesaPayment>(
      rows,
      conflictColumns: conflictColumns(MpesaPayment.t),
      updateColumns: updateColumns?.call(MpesaPayment.t),
      updateWhere: updateWhere?.call(MpesaPayment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MpesaPayment] and returns the resulting row.
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
  /// The returned [MpesaPayment] will have its `id` field set.
  Future<MpesaPayment?> upsertRow(
    _is.DatabaseSession session,
    MpesaPayment row, {
    required _is.ColumnSelections<MpesaPaymentTable> conflictColumns,
    _is.ColumnSelections<MpesaPaymentTable>? updateColumns,
    _is.WhereExpressionBuilder<MpesaPaymentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MpesaPayment>(
      row,
      conflictColumns: conflictColumns(MpesaPayment.t),
      updateColumns: updateColumns?.call(MpesaPayment.t),
      updateWhere: updateWhere?.call(MpesaPayment.t),
      transaction: transaction,
    );
  }

  /// Updates all [MpesaPayment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MpesaPayment>> update(
    _is.DatabaseSession session,
    List<MpesaPayment> rows, {
    _is.ColumnSelections<MpesaPaymentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MpesaPayment>(
      rows,
      columns: columns?.call(MpesaPayment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MpesaPayment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MpesaPayment> updateRow(
    _is.DatabaseSession session,
    MpesaPayment row, {
    _is.ColumnSelections<MpesaPaymentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MpesaPayment>(
      row,
      columns: columns?.call(MpesaPayment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MpesaPayment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MpesaPayment?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MpesaPaymentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MpesaPayment>(
      id,
      columnValues: columnValues(MpesaPayment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MpesaPayment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MpesaPayment>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MpesaPaymentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MpesaPaymentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MpesaPaymentTable>? orderBy,
    _is.OrderByListBuilder<MpesaPaymentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MpesaPayment>(
      columnValues: columnValues(MpesaPayment.t.updateTable),
      where: where(MpesaPayment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MpesaPayment.t),
      orderByList: orderByList?.call(MpesaPayment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MpesaPayment]s in the list and returns the deleted rows.
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
  Future<List<MpesaPayment>> delete(
    _is.DatabaseSession session,
    List<MpesaPayment> rows, {
    _is.OrderByBuilder<MpesaPaymentTable>? orderBy,
    _is.OrderByListBuilder<MpesaPaymentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MpesaPayment>(
      rows,
      orderBy: orderBy?.call(MpesaPayment.t),
      orderByList: orderByList?.call(MpesaPayment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MpesaPayment].
  Future<MpesaPayment> deleteRow(
    _is.DatabaseSession session,
    MpesaPayment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MpesaPayment>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MpesaPayment>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MpesaPaymentTable> where,
    _is.OrderByBuilder<MpesaPaymentTable>? orderBy,
    _is.OrderByListBuilder<MpesaPaymentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MpesaPayment>(
      where: where(MpesaPayment.t),
      orderBy: orderBy?.call(MpesaPayment.t),
      orderByList: orderByList?.call(MpesaPayment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MpesaPaymentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MpesaPayment>(
      where: where?.call(MpesaPayment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MpesaPayment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MpesaPaymentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MpesaPayment>(
      where: where(MpesaPayment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
