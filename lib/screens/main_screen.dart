import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';      // 검색 화면
import 'community_screen.dart'; // 추가됨
import 'mypage_screen.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 나머지 화면들은 일단 텍스트로 대체 (파일 생성 후 교체 가능)
  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),      // 검색 화면 연결
    const CommunityScreen(),  // 커뮤니티 화면 연결
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: '커뮤니티'),
        ],
      ),
    );
  }
}