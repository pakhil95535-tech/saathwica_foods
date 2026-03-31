import 'package:uuid/uuid.dart';

double _sd(dynamic v, [double fb = 0.0]) {
  if (v == null) return fb;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fb;
}

String _ss(dynamic v, [String fb = '']) {
  if (v == null) return fb;
  return v.toString();
}

DateTime _dt(dynamic v) {
  if (v == null) return DateTime.now();
  final s = v.toString();
  try {
    return DateTime.parse(s);
  } catch (_) {
    return DateTime.now();
  }
}

class EarningTransaction {
  final String id;
  final double amount;
  final double percentage;
  final String role;
  final int? fromUserId;
  final String downlineName;
  final String downlinePhone;
  final int? orderId;
  final double orderAmount;
  final double orderTotalAmount;
  final String orderStatus;
  final DateTime createdAt;

  EarningTransaction({
    String? id,
    required this.amount,
    required this.percentage,
    required this.role,
    this.fromUserId,
    required this.downlineName,
    required this.downlinePhone,
    this.orderId,
    this.orderAmount = 0,
    this.orderTotalAmount = 0,
    this.orderStatus = '',
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();

  factory EarningTransaction.fromJson(Map<String, dynamic> json) {
    final ref = (json['referrer'] ?? {}) as Map<String, dynamic>;
    final ord = (json['Order'] ?? {}) as Map<String, dynamic>;
    return EarningTransaction(
      id: _ss(json['id'] ?? json['txn_id'] ?? json['history_id']),
      amount: _sd(json['amount'] ?? json['value'] ?? json['earning']),
      percentage: _sd(json['percentage']),
      role: _ss(json['role']),
      fromUserId: int.tryParse(_ss(json['from_user_id'])),
      downlineName: _ss(ref['name']),
      downlinePhone: _ss(ref['phone']),
      orderId: int.tryParse(_ss(ord['order_id'])),
      orderAmount: _sd(ord['amount']),
      orderTotalAmount: _sd(ord['total_amount']),
      orderStatus: _ss(ord['status']),
      createdAt: _dt(json['timestamp'] ?? json['createdAt'] ?? json['created_at'] ?? json['date']),
    );
  }
}

class EarningsSummary {
  final double total;
  final double pending;
  final double completed;
  final List<EarningTransaction> transactions;

  EarningsSummary({
    required this.total,
    required this.pending,
    required this.completed,
    required this.transactions,
  });

  factory EarningsSummary.fromResponse(dynamic body) {
    final listRaw =
        body is Map<String, dynamic> ? (body['data'] ?? body['items']) : body;
    final List<dynamic> list = (listRaw is List) ? listRaw : <dynamic>[];
    final txns = list
        .whereType<Map<String, dynamic>>()
        .map(EarningTransaction.fromJson)
        .toList();

    double total = 0, pending = 0, completed = 0;
    for (final t in txns) {
      total += t.amount;
      final st = t.orderStatus.toLowerCase();
      if (st.contains('pend')) pending += t.amount;
      if (st.contains('complete') || st.contains('paid')) {
        completed += t.amount;
      }
    }

    if (body is Map<String, dynamic>) {
      total = _sd(body['total'] ?? total);
      pending = _sd(body['pending'] ?? pending);
      completed = _sd(body['completed'] ?? completed);
    }

    return EarningsSummary(
      total: total,
      pending: pending,
      completed: completed,
      transactions: txns,
    );
  }
}
