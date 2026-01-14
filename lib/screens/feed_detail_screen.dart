// lib/screens/feed_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/feed.dart';
import '../services/api_service.dart';
import 'music_player_screen.dart';

class FeedDetailScreen extends StatefulWidget {
  final Feed feed;

  const FeedDetailScreen({super.key, required this.feed});

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  final _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoadingComments = false;
  bool _isLiked = false;
  late int _likeCount;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.feed.likeCount;
    _commentCount = widget.feed.commentCount;
    _loadComments();
    // 게시물 조회수 증가
    ApiService.incrementView(widget.feed.boardNumber);
  }

  Future<void> _loadComments() async {
    setState(() => _isLoadingComments = true);
    _comments = await ApiService.getComments(widget.feed.boardNumber);
    setState(() => _isLoadingComments = false);
  }

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    final success = await ApiService.addComment(
      widget.feed.boardNumber,
      _commentController.text,
    );

    if (success) {
      _commentController.clear();
      await _loadComments();
      setState(() {
        _commentCount++;
      });
    }
  }

  Future<void> _toggleLike() async {
    await ApiService.incrementLike(widget.feed.boardNumber);
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작성자 정보
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFF1C1C1E),
                    child: Icon(Icons.person, color: Colors.grey, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.feed.writerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.feed.writerArtistName.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.white, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.feed.writerArtistName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF2D55).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.feed.category,
                            style: const TextStyle(
                              color: Color(0xFFFF2D55),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.feed.musicPath.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.amber, width: 1),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.audiotrack, color: Colors.amber, size: 10),
                          SizedBox(width: 3),
                          Text(
                            '음악',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // 커버 이미지 및 재생 버튼
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    image: widget.feed.coverPath.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                              kIsWeb
                                  ? 'http://localhost:3000/${widget.feed.coverPath}'
                                  : 'http://10.0.2.2:3000/${widget.feed.coverPath}',
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: widget.feed.coverPath.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.music_note,
                            size: 100,
                            color: Color(0xFF333333),
                          ),
                        )
                      : null,
                ),
                if (widget.feed.musicPath.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicPlayerScreen(feed: widget.feed),
                        ),
                      );
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2D55).withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
              ],
            ),

            // 좋아요 & 통계
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? const Color(0xFFFF2D55) : Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleLike,
                  ),
                  Text(
                    '$_likeCount',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '$_commentCount',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.visibility_outlined, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.feed.viewCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.play_circle_outline, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.feed.playCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            // 제목 및 내용
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feed.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.feed.content,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: Color(0xFF1C1C1E)),
            const SizedBox(height: 16),

            // 댓글 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    '댓글',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_comments.length}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 댓글 입력
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1C1C1E),
                        hintText: '댓글을 입력하세요...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFFF2D55)),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 댓글 목록
            _isLoadingComments
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Color(0xFFFF2D55)),
                    ),
                  )
                : _comments.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            '첫 댓글을 남겨보세요!',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFF1C1C1E),
                                  child: Icon(Icons.person, color: Colors.grey, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            comment['userName'] ?? 'Anonymous',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (comment['artistName'] != null && comment['artistName'].toString().isNotEmpty) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.star, color: Colors.white, size: 10),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    comment['artistName'].toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          const Spacer(),
                                          Text(
                                            _formatTime(comment['createdAt']),
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        comment['content'] ?? '',
                                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _formatTime(dynamic time) {
    if (time == null) return '';
    try {
      DateTime dateTime = DateTime.parse(time.toString());
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) return '방금 전';
      if (difference.inHours < 1) return '${difference.inMinutes}분 전';
      if (difference.inDays < 1) return '${difference.inHours}시간 전';
      if (difference.inDays < 7) return '${difference.inDays}일 전';
      return '${dateTime.year}.${dateTime.month}.${dateTime.day}';
    } catch (e) {
      return '';
    }
  }
}
