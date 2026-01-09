import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MuMuApp());
}

class MuMuApp extends StatelessWidget {
  const MuMuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Mood',
      debugShowCheckedModeBanner: false, // 디버그 띠 제거

      // 애플 뮤직 스타일 다크 테마 적용
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // 기본 텍스트를 흰색으로 자동 설정
        
        // 1. 배경색: 완전한 리얼 블랙
        scaffoldBackgroundColor: Colors.black,
        
        // 2. 포인트 컬러: 애플 뮤직 스타일의 붉은색 (Red/Pink Accent)
        primaryColor: const Color(0xFFFF2D55),
        
        // 컬러 스킴 정의 (버튼, 로딩바 등에 적용됨)
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF2D55),       // 주요 액션 버튼 색상
          secondary: Color(0xFFFF2D55),     // 보조 포인트 색상
          surface: Color(0xFF1C1C1E),       // 카드나 모달 배경색 (다크 그레이)
          background: Colors.black,         // 전체 배경
          onBackground: Colors.white,       // 배경 위 글자색
        ),

        // 3. 앱바(상단 바) 스타일
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // 앱바 배경 검정
          elevation: 0, // 그림자 제거
          scrolledUnderElevation: 0, // 스크롤 시 색상 변경 방지
          titleTextStyle: TextStyle(
            color: Colors.white, 
            fontSize: 24, // 애플은 타이틀이 크고 굵음
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Color(0xFFFF2D55)), // 아이콘(검색 등) 붉은색
        ),

        // 4. 하단 네비게이션 바 스타일 (Blur 느낌 대신 다크 그레이 사용)
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1C1C1E), // 본문과 구분되는 아주 어두운 회색
          selectedItemColor: Color(0xFFFF2D55), // 선택된 탭: 붉은색
          unselectedItemColor: Colors.grey,     // 선택 안 된 탭: 회색
          type: BottomNavigationBarType.fixed,
        ),
        
        // 5. 텍스트 테마 (기본 흰색 유지)
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),

      home: const LoginScreen(),
    );
  }
}