// lib/screens/mypage_screen.dart
import 'package:flutter/material.dart';
import 'login_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // 프로필 사진 영역
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1C1C1E),
                    ),
                    child: const Icon(Icons.person, size: 60, color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '홍길동', // 나중에 DB에서 받아온 memberName 표시
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'test@example.com', // 나중에 DB에서 받아온 memberEmail 표시
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 메뉴 리스트
            _buildMenuTile(context, Icons.history, '최근 들은 음악'),
            _buildMenuTile(context, Icons.favorite, '좋아요 한 곡'),
            _buildMenuTile(context, Icons.cloud_upload, '내가 올린 음악'),
            
            const Divider(color: Colors.grey, thickness: 0.5, height: 40),
            
            _buildMenuTile(context, Icons.logout, '로그아웃', onTap: () {
              // 로그아웃 시 로그인 화면으로 이동
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false, // 모든 이전 화면 스택 제거
              );
            }, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, IconData icon, String title, {VoidCallback? onTap, bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? const Color(0xFFFF2D55) : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? const Color(0xFFFF2D55) : Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap ?? () {},
    );
  }
}