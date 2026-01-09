// lib/models/music_model.dart

class Music {
  final String title;
  final String artist;
  final String imageUrl;
  final String rank; // 차트 순위용

  Music({
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.rank = '',
  });
}