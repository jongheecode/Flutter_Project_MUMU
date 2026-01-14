// lib/screens/community_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'upload_screen.dart';
import 'feed_detail_screen.dart';
import 'music_player_screen.dart';
import '../services/api_service.dart';
import '../models/feed.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Feed> _feeds = [];
  bool _isLoading = true;
  String _selectedCategory = '전체';
  String _sortBy = 'createdAt';

  final List<String> _categories = ['전체', '자작곡', '커버곡', 'MR/비트', '기타'];

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  Future<void> _loadFeeds() async {
    setState(() => _isLoading = true);
    
    List<Feed> feeds;
    if (_selectedCategory == '전체') {
      feeds = await ApiService.fetchFeeds(sortBy: _sortBy);
    } else {
      feeds = await ApiService.fetchFeedsByCategory(_selectedCategory);
      feeds.sort((a, b) {
        if (_sortBy == 'likeCount') {
          return b.likeCount.compareTo(a.likeCount);
        }
        return b.playCount.compareTo(a.playCount);
      });
    }
    
    // 최근 게시물이 위로 오도록 정렬 (boardNumber가 클수록 최신)
    feeds.sort((a, b) => b.boardNumber.compareTo(a.boardNumber));
    
    setState(() {
      _feeds = feeds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              backgroundColor: Colors.black,
              title: const Text(
                '커뮤니티',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    value: _sortBy,
                    underline: const SizedBox(),
                    dropdownColor: const Color(0xFF1C1C1E),
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFF2D55)),
                    items: const [
                      DropdownMenuItem(
                        value: 'createdAt',
                        child: Text('최신순', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'playCount',
                        child: Text('재생순', style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 'likeCount',
                        child: Text('좋아요순', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _sortBy = value;
                          _loadFeeds();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                color: Colors.black,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                            _loadFeeds();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFF2D55)
                                : const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[400],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF2D55)),
              )
            : _feeds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, color: Colors.grey[700], size: 80),
                        const SizedBox(height: 20),
                        Text(
                          '등록된 게시글이 없습니다',
                          style: TextStyle(color: Colors.grey[400], fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '첫 음악을 업로드해보세요!',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadFeeds,
                    color: const Color(0xFFFF2D55),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 80, top: 8),
                      itemCount: _feeds.length,
                      itemBuilder: (context, index) {
                        return _buildFeedItem(_feeds[index]);
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF2D55),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
          if (result == true) {
            _loadFeeds();
          }
        },
      ),
    );
  }

  Widget _buildFeedItem(Feed feed) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetailScreen(feed: feed),
          ),
        );
        if (result == true) {
          _loadFeeds();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 작성자 정보
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF1C1C1E),
                child: Icon(Icons.person, color: Colors.grey, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                feed.writerName,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (feed.writerArtistName.isNotEmpty) ...[
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
                        feed.writerArtistName,
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  feed.category,
                  style: const TextStyle(
                    color: Color(0xFFFF2D55),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (feed.musicPath.isNotEmpty) ...[
                const SizedBox(width: 6),
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
          const SizedBox(height: 10),

          // 2. 앨범 커버 및 재생 버튼
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1C1C1E),
                  image: feed.coverPath.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                            kIsWeb
                                ? 'http://localhost:3000/${feed.coverPath}'
                                : 'http://10.0.2.2:3000/${feed.coverPath}',
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: feed.coverPath.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.music_note,
                          size: 80,
                          color: Color(0xFF333333),
                        ),
                      )
                    : null,
              ),
              // 재생 버튼 오버레이 (음악 파일 있을 때만)
              if (feed.musicPath.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerScreen(feed: feed),
                      ),
                    );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF2D55).withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // 3. 제목 및 설명
          Text(
            feed.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            feed.content,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 12),

          // 4. 좋아요/댓글/조회/재생 수
          Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                '${feed.likeCount}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.comment_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                '${feed.commentCount}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.visibility_outlined, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                '${feed.viewCount}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.play_circle_outline, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                '${feed.playCount}',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
