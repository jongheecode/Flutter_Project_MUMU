// lib/screens/music_player_screen.dart
import 'package:flutter/material.dart';
import '../models/feed.dart';
import '../services/api_service.dart';
import 'package:flutter/foundation.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Feed feed;

  const MusicPlayerScreen({super.key, required this.feed});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool _isLiked = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    ApiService.incrementPlay(widget.feed.boardNumber);
  }

  Future<void> _toggleLike() async {
    await ApiService.incrementLike(widget.feed.boardNumber);
    setState(() => _isLiked = !_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // 앱바
          SliverAppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // 앨범 커버
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
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
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF2D55).withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: widget.feed.coverPath.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.music_note,
                              size: 120,
                              color: Color(0xFF333333),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 40),

                  // 좋아요 + 제목 + 공유
                  Row(
                    children: [
                      // 좋아요 (왼쪽)
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? const Color(0xFFFF2D55) : Colors.white,
                          size: 24,
                        ),
                        onPressed: _toggleLike,
                      ),
                      const SizedBox(width: 8),
                      // 제목
                      Expanded(
                        child: Text(
                          widget.feed.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 공유 (오른쪽)
                      IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.white, size: 24),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 아티스트 & 카테고리
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.feed.writerName,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // 재생 바 (가짜)
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFFFF2D55),
                          inactiveTrackColor: const Color(0xFF1C1C1E),
                          thumbColor: const Color(0xFFFF2D55),
                          overlayColor: const Color(0xFFFF2D55).withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: 0.3,
                          onChanged: (value) {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '1:23',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            Text(
                              '3:45',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 재생 컨트롤
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shuffle, color: Colors.grey),
                        iconSize: 28,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {},
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() => _isPlaying = !_isPlaying);
                        },
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF2D55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: Colors.white),
                        iconSize: 40,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.repeat, color: Colors.grey),
                        iconSize: 28,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
