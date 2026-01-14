class Feed {
  final int boardNumber;
  final String title;
  final String category;
  final String content;
  final String musicPath;
  final String coverPath;
  final String writerEmail;
  final String writerName;
  final int playCount;
  final int likeCount;
  // (나중에 댓글 수도 필요하면 추가)

  Feed({
    required this.boardNumber,
    required this.title,
    required this.category,
    required this.content,
    required this.musicPath,
    required this.coverPath,
    required this.writerEmail,
    required this.writerName,
    required this.playCount,
    required this.likeCount,
  });

  // 서버에서 받은 JSON을 Feed 객체로 변환하는 공장(Factory)
  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      boardNumber: json['boardNumber'] ?? 0,
      title: json['boardTitle'] ?? '제목 없음', // DB 컬럼명과 맞춰야 함
      category: json['boardCategory'] ?? '기타',
      content: json['boardContent'] ?? '',
      musicPath: json['musicPath'] ?? '',
      coverPath: json['coverPath'] ?? '',
      writerEmail: json['writerEmail'] ?? '익명',
      writerName: json['writerName'] ?? '익명',
      playCount: json['playCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
    );
  }
}