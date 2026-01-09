import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 애플은 둥근 모서리가 조금 더 각짐
        gradient: const LinearGradient(
          // 아주 어두운 회색 -> 검정 그라데이션
          colors: [Color(0xFF2C2C2E), Colors.black], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white10, width: 0.5), // 미세한 테두리
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '지금 듣기 좋은',
                  style: TextStyle(
                    color: Color(0xFFFF2D55), // 애플 레드 포인트
                    fontSize: 13, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '비 오는 날의\n감성 플레이리스트',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2, // 줄간격 조정
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 20,
            child: Icon(
              Icons.play_circle_fill, 
              color: Color(0xFFFF2D55), // 재생 버튼도 붉은색
              size: 45
            ),
          )
        ],
      ),
    );
  }
}