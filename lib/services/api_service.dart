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
          UserState.setLogin(user['email'], user['name'], artistName: user['artistName']);
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

  // 3. 음악 목록 가져오기 (정렬 옵션 추가)
  static Future<List<Feed>> fetchFeeds({String sortBy = 'playCount'}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/feed/list'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['list'];
          List<Feed> feeds = list.map((item) => Feed.fromJson(item)).toList();
          
          // 클라이언트 측 정렬
          if (sortBy == 'likeCount') {
            feeds.sort((a, b) => b.likeCount.compareTo(a.likeCount));
          } else {
            feeds.sort((a, b) => b.playCount.compareTo(a.playCount));
          }
          
          return feeds;
        }
      }
      return [];
    } catch (e) {
      print('목록 불러오기 실패: $e');
      return [];
    }
  }

  // 4. 카테고리별 필터링
  static Future<List<Feed>> fetchFeedsByCategory(String category) async {
    try {
      final feeds = await fetchFeeds();
      if (category == '전체') return feeds;
      return feeds.where((feed) => feed.category == category).toList();
    } catch (e) {
      print('카테고리 필터링 실패: $e');
      return [];
    }
  }

  // 5. 좋아요 토글 (증가/감소)
  static Future<bool> incrementLike(int boardNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feed/like'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'boardNumber': boardNumber,
          'userEmail': UserState.currentUserEmail ?? 'anonymous',
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('좋아요 에러: $e');
      return false;
    }
  }

  // 6. 재생 수 증가 (음악 재생)
  static Future<bool> incrementPlay(int boardNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feed/play'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'boardNumber': boardNumber}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('재생 수 증가 에러: $e');
      return false;
    }
  }

  // 7. 게시물 조회수 증가
  static Future<bool> incrementView(int boardNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feed/view'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'boardNumber': boardNumber}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('조회수 증가 에러: $e');
      return false;
    }
  }

  // 7. 음악 업로드 (파일 포함)
  static Future<bool> uploadMusic({
    required String title,
    required String category,
    required String content,
    String? musicFilePath,
    String? coverImagePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/feed/upload'),
      );

      // 텍스트 필드 추가
      request.fields['title'] = title;
      request.fields['category'] = category;
      request.fields['content'] = content;
      request.fields['writerEmail'] = UserState.currentUserEmail ?? 'anonymous';

      // 음악 파일 추가 (선택사항)
      if (musicFilePath != null && musicFilePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('musicFile', musicFilePath),
        );
      }

      // 커버 이미지 추가 (선택사항)
      if (coverImagePath != null && coverImagePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('coverImage', coverImagePath),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('업로드 에러: $e');
      return false;
    }
  }

  // 8. 댓글 목록 가져오기
  static Future<List<Map<String, dynamic>>> getComments(int boardNumber) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/feed/comments?boardNumber=$boardNumber'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['comments'] != null) {
          return List<Map<String, dynamic>>.from(data['comments']);
        }
      }
      return [];
    } catch (e) {
      print('댓글 가져오기 에러: $e');
      return [];
    }
  }

  // 9. 댓글 작성
  static Future<bool> addComment(int boardNumber, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/feed/comment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'boardNumber': boardNumber,
          'userEmail': UserState.currentUserEmail ?? 'anonymous',
          'content': content,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('댓글 작성 에러: $e');
      return false;
    }
  }

  // 10. 프로필 업데이트
  static Future<bool> updateUserProfile({
    String? name,
    String? artistName,
    String? phone,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/profile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'memberEmail': UserState.currentUserEmail,
          'memberName': name,
          'artistName': artistName,
          'memberPhone': phone,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('프로필 업데이트 에러: $e');
      return false;
    }
  }
}