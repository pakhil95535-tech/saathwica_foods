import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../common/utils/constants.dart';
import '../common/models/earnings.dart';
import '../common/models/joinings.dart';
import 'api_service.dart';

class EarningsService {
  static Map<String, String> _headers() {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      'User-Agent': 'saathwica-app',
    };
    if (ApiService.authToken != null && ApiService.authToken!.isNotEmpty) {
      h['Authorization'] = 'Bearer ${ApiService.authToken}';
    }
    if (AppConfig.productApiKey.isNotEmpty) {
      h['x-api-key'] = AppConfig.productApiKey;
    }
    return h;
  }

  static Future<EarningsSummary> fetchEarnings({
    required int userId,
    required String role,
  }) async {
    final url = Uri.parse('${AppEndpoints.earningHistory}/$userId')
        .replace(queryParameters: {
      'role': role,
    });
    if (kDebugMode) {
      print('DEBUG: Fetch earnings URL: $url');
    }
    final res = await http.get(url, headers: _headers()).timeout(
          const Duration(seconds: 15),
        );
    if (kDebugMode) {
      print('DEBUG: Earnings status: ${res.statusCode}');
      print('DEBUG: Earnings body: ${res.body}');
    }
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return EarningsSummary.fromResponse(body);
    }
    String message = 'Unable to fetch earnings';
    if (body is Map && body['message'] != null) {
      message = body['message'].toString();
    }
    throw Exception(message);
  }

  static Future<JoiningsSummary> fetchJoinings({
    required int userId,
    required String role,
    String? referralCode,
  }) async {
    final url = Uri.parse('${AppEndpoints.myJoinings}/$userId');
    
    if (kDebugMode) {
      print('DEBUG: Fetch joinings for user_id=$userId role=$role');
      print('DEBUG: Fetch joinings URL: $url');
    }
    
    try {
      final res = await http.get(url, headers: _headers()).timeout(
            const Duration(seconds: 15),
          );
      
      if (kDebugMode) {
        print('DEBUG: Joinings status: ${res.statusCode}');
        print('DEBUG: Joinings body: ${res.body}');
      }
      
      final body = res.body.isNotEmpty ? jsonDecode(res.body) : {};
      
      if (res.statusCode >= 200 && res.statusCode < 300) {
        List<Joining> parsed = [];
        if (body is Map<String, dynamic>) {
          final lowerRole = role.toLowerCase();
          List<dynamic> raw = [];
          if (lowerRole == 'admin') {
            raw = (body['supervisors'] ?? body['employees'] ?? []) as List<dynamic>;
          } else if (lowerRole == 'supervisor') {
            raw = (body['employees'] ?? []) as List<dynamic>;
          } else if (lowerRole == 'employee') {
            raw = (body['customers'] ?? []) as List<dynamic>;
          } else {
            raw = (body['data'] ?? body['joinings'] ?? []) as List<dynamic>;
          }
          parsed = raw
              .whereType<Map<String, dynamic>>()
              .map(Joining.fromJson)
              .toList();
        } else if (body is List) {
          parsed = body
              .whereType<Map<String, dynamic>>()
              .map(Joining.fromJson)
              .toList();
        }
        return JoiningsSummary(total: parsed.length, joinings: parsed);
      }
      
      String message = 'Unable to fetch joinings';
      if (body is Map && body['message'] != null) {
        message = body['message'].toString();
      }
      // If 404, it might just mean no joinings found, return empty
      if (res.statusCode == 404) {
        return JoiningsSummary(total: 0, joinings: []);
      }
      throw Exception(message);
    } catch (e) {
      if (kDebugMode) print('DEBUG: Fetch joinings error: $e');
      // Return empty list on error to prevent UI breakage
      return JoiningsSummary(total: 0, joinings: []);
    }
  }
}
