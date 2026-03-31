
class Joining {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role;
  final DateTime joinedAt;
  final String referrerName;
  final String referrerId;
  final String referredBy; // The referral code used to join

  Joining({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.joinedAt,
    this.referrerName = '',
    this.referrerId = '',
    this.referredBy = '',
  });

  factory Joining.fromJson(Map<String, dynamic> json) {
    return Joining(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? json['userType'] ?? '').toString(),
      joinedAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      referrerName: (json['referrer_name'] ?? '').toString(),
      referrerId: (json['referrer_id'] ?? '').toString(),
      referredBy: (json['reffered_by'] ?? json['referred_by'] ?? '').toString(),
    );
  }
}

class JoiningsSummary {
  final int total;
  final List<Joining> joinings;

  JoiningsSummary({
    required this.total,
    required this.joinings,
  });

  factory JoiningsSummary.fromResponse(dynamic body) {
    final listRaw =
        body is Map<String, dynamic> ? (body['data'] ?? body['joinings'] ?? []) : body;
    final List<dynamic> list = (listRaw is List) ? listRaw : <dynamic>[];
    
    final joinings = list
        .whereType<Map<String, dynamic>>()
        .map(Joining.fromJson)
        .toList();

    return JoiningsSummary(
      total: joinings.length,
      joinings: joinings,
    );
  }
}
