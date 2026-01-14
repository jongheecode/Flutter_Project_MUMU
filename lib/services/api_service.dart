import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed.dart';
import '../models/user_state.dart'; // 유저 정보 저장용
import 'package:flutter/foundation.dart';

class ApiService {
  // ★ 중요: 안드로이드 에뮬레이터에서는 localhost 대신 '10.0.2.2'를 씁니다.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // 크롬용
    } else {
      return 'http://10.0.2.2:3000';  // 안드로이드 에뮬레이터용
    }
  }
  
  // 1. 로그인 (Login)
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'memberEmail': email,
          'memberPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // 로그인 성공 시 유저 정보 저장
          final user = data['user'];
          UserState.setLogin(user['email'], user['name']);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('로그인 에러: $e');
      return false;
    }
  }

  // 2. 회원가입 (Register)
  static Future<bool> register(String email, String password, String name, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'memberEmail': email,
          'memberPassword': password,
          'memberName': name,
          'memberPhone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('회원가입 에러: $e');
      return false;
    }
  }

  // 3. 음악 목록 가져오기 (List)
  static Future<List<Feed>> fetchFeeds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/feed/list'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['list'];
          return list.map((item) => Feed.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      print('목록 불러오기 실패: $e');
      return [];
    }
  }
}