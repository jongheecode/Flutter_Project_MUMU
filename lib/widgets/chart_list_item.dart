import 'package:flutter/material.dart';
import '../models/music_model.dart';

class ChartListItem extends StatelessWidget {
  final Music music;

  const ChartListItem({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      // 1. 앨범 커버 (이미지 없을 때)
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E), // 다크 그레이 배경
          borderRadius: BorderRadius.circular(4), // 애플은 앨범아트 라운드가 작음
          image: music.imageUrl.isNotEmpty 
              ? DecorationImage(
                  image: NetworkImage(music.imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: music.imageUrl.isEmpty
            ? Center(
                child: Text(
                  music.rank,
                  style: const TextStyle(
                    color: Colors.grey, // 순위는 회색으로 은은하게
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            : null,
      ),
      // 2. 곡 제목
      title: Text(
        music.title,
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      // 3. 가수 이름
      subtitle: Text(
        music.artist,
        style: TextStyle(
          color: Colors.grey[400], // 약간 밝은 회색
          fontSize: 14,
        ),
      ),
      // 4. 더보기 아이콘
      trailing: Icon(
        Icons.more_horiz, // 재생 버튼 대신 메뉴 버튼이 더 일반적
        color: Colors.grey[600],
      ),
      onTap: () {
        // 재생 로직
      },
    );
  }
}