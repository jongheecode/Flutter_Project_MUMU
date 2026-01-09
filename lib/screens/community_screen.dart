// lib/screens/community_screen.dart
import 'package:flutter/material.dart';
import 'upload_screen.dart'; // 업로드 화면 import

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Sound Cloud'),
        backgroundColor: Colors.black,
      ),
      // 업로드 버튼 (Floating Action Button)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF2D55),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // 업로드 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80), // FAB에 가려지지 않게 여백
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildFeedItem();
        },
      ),
    );
  }

  Widget _buildFeedItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 작성자 정보
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF1C1C1E),
                child: Icon(Icons.person, color: Colors.grey, size: 20),
              ),
              const SizedBox(width: 8),
              const Text(
                'User Nickname',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Spacer(),
              const Text('10분 전', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),

          // 2. 앨범 커버 및 재생 버튼 (사운드클라우드 스타일)
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1C1C1E),
                  // 실제 이미지가 들어가면 여기에 image: DecorationImage(...) 사용
                ),
                child: const Center(
                  child: Icon(Icons.music_note, size: 80, color: Color(0xFF333333)),
                ),
              ),
              // 재생 버튼 오버레이
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55).withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 35),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. 제목 및 설명
          const Text(
            '새벽에 작업한 비트입니다. 들어주세요!',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '#Hiphop #Beat #Jazz',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          
          const SizedBox(height: 12),

          // 4. 좋아요/댓글 버튼
          Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.white),
              const SizedBox(width: 5),
              const Text('124', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 20),
              const Icon(Icons.chat_bubble_outline, color: Colors.white),
              const SizedBox(width: 5),
              const Text('15', style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}