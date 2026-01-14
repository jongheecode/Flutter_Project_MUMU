class Feed {
  final int boardNumber;
  final String title;
  final String category;
  final String content;
  final String musicPath;
  final String coverPath;
  final String writerEmail;
  final String writerName;
  final String writerArtistName;
  final int playCount;
  final int likeCount;
  final int viewCount;
  final int commentCount;
  final String createdAt;

  Feed({
    required this.boardNumber,
    required this.title,
    required this.category,
    required this.content,
    required this.musicPath,
    required this.coverPath,
    required this.writerEmail,
    required this.writerName,
    required this.writerArtistName,
    required this.playCount,
    required this.likeCount,
    required this.viewCount,
    required this.commentCount,
    required this.createdAt,
  });

  // 서버에서 받은 JSON을 Feed 객체로 변환하는 공장(Factory)
  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      boardNumber: json['boardNumber'] ?? 0,
      title: json['boardTitle'] ?? '제목 없음',
      category: json['boardCategory'] ?? '기타',
      content: json['boardContent'] ?? '',
      musicPath: json['musicPath'] ?? '',
      coverPath: json['coverPath'] ?? '',
      writerEmail: json['writerEmail'] ?? '익명',
      writerName: json['writerName'] ?? '익명',
      writerArtistName: json['writerArtistName'] ?? '',
      playCount: json['playCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}