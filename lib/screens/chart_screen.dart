// lib/screens/chart_screen.dart
import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Top 100'),
        centerTitle: false, // 애플 뮤직은 타이틀이 왼쪽에 있는 경우가 많음
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('전체 재생', style: TextStyle(color: Color(0xFFFF2D55))),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 20, // 일단 20개만 더미로 표시
        itemBuilder: (context, index) {
          return _buildChartItem(index + 1);
        },
      ),
    );
  }

  Widget _buildChartItem(int rank) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          // 1. 순위
          SizedBox(
            width: 30,
            child: Text(
              '$rank',
              style: TextStyle(
                color: rank <= 3 ? const Color(0xFFFF2D55) : Colors.white, // 1~3위는 붉은색 강조
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          
          // 2. 앨범 커버
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFF1C1C1E),
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/50'), // 더미 이미지
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // 3. 곡 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '인기 차트 노래 제목 $rank',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '아티스트 이름',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ],
            ),
          ),
          
          // 4. 메뉴 버튼
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}