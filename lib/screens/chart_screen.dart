// lib/screens/chart_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/feed.dart';
import 'package:flutter/foundation.dart';
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 배경 검정
      appBar: AppBar(
        title: const Text('Top 100'),
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // 전체 재생 기능 (나중에 구현)
            },
            child: const Text('전체 재생', style: TextStyle(color: Color(0xFFFF2D55))),
          )
        ],
      ),
      // ★ 여기가 핵심 변경 부분입니다!
      body: FutureBuilder<List<Feed>>(
        future: ApiService.fetchFeeds(), // 1. 서버에 데이터 요청
        builder: (context, snapshot) {
          // 2. 로딩 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF2D55)));
          }
          // 3. 에러 났을 때
          else if (snapshot.hasError) {
            return Center(child: Text("에러 발생: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          }
          // 4. 데이터가 없을 때
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("등록된 음악이 없습니다.", style: TextStyle(color: Colors.white)));
          }

          // 5. 데이터 도착 성공!
          final feeds = snapshot.data!;

          return ListView.builder(
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              // 리스트 아이템 만드는 함수에 '실제 데이터'와 '순위'를 넘겨줌
              return _buildChartItem(feeds[index], index + 1);
            },
          );
        },
      ),
    );
  }

  // 인자로 Feed 객체와 순위(rank)를 받습니다.
  Widget _buildChartItem(Feed feed, int rank) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      
      // 1. 순위 (1, 2, 3...)
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 15),
          
          // 2. 앨범 커버 이미지
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[800], // 이미지가 없을 때 배경색
              image: feed.coverPath.isNotEmpty
                ? DecorationImage(
               // ★ 웹이면 localhost, 앱이면 10.0.2.2
              image: NetworkImage(
                kIsWeb 
                    ? 'http://localhost:3000/${feed.coverPath}' 
                    : 'http://10.0.2.2:3000/${feed.coverPath}'
        ),
        fit: BoxFit.cover,
      )
    : null,
            ),
            // 이미지가 없으면 음표 아이콘 표시
            child: feed.coverPath.isEmpty 
                ? const Icon(Icons.music_note, color: Colors.white54) 
                : null,
          ),
        ],
      ),
      
      // 3. 곡 제목
      title: Text(
        feed.title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // 제목 길면 ... 처리
      ),
      
      // 4. 가수 이름 (작성자) & 재생 수
      subtitle: Text(
        '${feed.writerEmail} · ${feed.playCount}회 재생',
        style: TextStyle(color: Colors.grey[400], fontSize: 13),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      
      // 5. 우측 플레이 버튼
      trailing: IconButton(
        icon: const Icon(Icons.play_circle_fill, color: Colors.white30),
        onPressed: () {
            // 재생 로직 (나중에 구현)
            print('${feed.title} 재생');
        },
      ),
    );
  }
}