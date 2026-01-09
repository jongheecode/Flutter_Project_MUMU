// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 나중에 본인의 PC IP 주소로 변경해야 함 (예: http://192.168.0.x:3000)
  static const String baseUrl = 'http://localhost:3000'; // 로컬호스트 주소

  // 1. 로그인 요청
  Future<bool> login(String email, String password) async {
    try {
      // 실제 서버 연결 시 아래 주석 해제
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'), // Chap03 API 참고
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'memberEmail': email,
          'memberPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        return true; // 로그인 성공
      } else {
        return false; // 로그인 실패
      }
      */
      
      // [테스트용] 무조건 성공 처리 (서버 없이 UI 확인용)
      await Future.delayed(const Duration(seconds: 1)); // 통신하는 척 1초 대기
      return true; 
    } catch (e) {
      print('로그인 에러: $e');
      return false;
    }
  }

  // 2. 회원가입 요청
  Future<bool> signUp(String email, String password, String name, String phone) async {
    try {
      // 실제 서버 연결 시 아래 주석 해제
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/user/register'), // Chap03 API 참고
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'memberEmail': email,
          'memberPassword': password,
          'memberName': name,
          'memberPhone': phone,
        }),
      );
      
      return response.statusCode == 200;
      */

      // [테스트용] 무조건 성공 처리
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      print('회원가입 에러: $e');
      return false;
    }
  }
}