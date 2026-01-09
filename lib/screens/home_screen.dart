import 'package:flutter/material.dart';
import '../widgets/home_banner.dart';
import '../widgets/section_title.dart';
import '../widgets/chart_list_item.dart';
import '../models/music_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 데이터 생성
    final List<Music> chartData = List.generate(
      5,
      (index) => Music(
        rank: '${index + 1}',
        title: '인기 차트 노래 제목 ${index + 1}',
        artist: '가수 이름',
        imageUrl: '', // 실제 이미지 URL이 있으면 여기에 넣음
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('MuMu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // 1. 배너
            const HomeBanner(),
            
            const SizedBox(height: 20),

            // 2. 실시간 차트
            SectionTitle(title: '🔥 실시간 인기 차트', onTap: () {}),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: chartData.length,
              itemBuilder: (context, index) {
                return ChartListItem(music: chartData[index]);
              },
            ),

            const SizedBox(height: 20),

            // 3. 최신 업로드 (가로 스크롤 구현은 여기서 간단히)
            SectionTitle(title: '☁️ 최신 업로드 (New)', onTap: () {}),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 15, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.music_note, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '새로운 곡 ${index + 1}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}