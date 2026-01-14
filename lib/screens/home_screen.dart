// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/feed.dart';
import '../models/user_state.dart';
import 'mypage_screen.dart';
import 'chart_screen.dart';
import 'feed_detail_screen.dart';
import 'upload_screen.dart';
import 'music_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Feed> _recentFeeds = [];
  List<Feed> _topFeeds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  Future<void> _loadFeeds() async {
    final feeds = await ApiService.fetchFeeds(sortBy: 'playCount');
    setState(() {
      _topFeeds = feeds.take(5).toList();
      _recentFeeds = feeds.reversed.take(10).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF2D55)),
            )
          : RefreshIndicator(
              onRefresh: _loadFeeds,
              color: const Color(0xFFFF2D55),
              child: CustomScrollView(
                slivers: [
                  // 앱바
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.black,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          UserState.currentUserName ?? 'Music Lover',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person_outline, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyPageScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  // Featured Banner
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF2D55),
                            Color(0xFFFF6B6B),
                            Color(0xFFFF9472),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF2D55).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(
                              Icons.music_note,
                              size: 150,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '🎵 Music Mood',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '당신의 음악, 당신의 무드',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UploadScreen(),
                                      ),
                                    );
                                    if (result == true) {
                                      _loadFeeds();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      '지금 업로드하기',
                                      style: TextStyle(
                                        color: Color(0xFFFF2D55),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // HOT 트렌딩
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.local_fire_department,
                                color: Color(0xFFFF2D55),
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'HOT 트렌딩',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChartScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              '더보기',
                              style: TextStyle(color: Color(0xFFFF2D55)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Trending List
                  if (_topFeeds.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.music_off, color: Colors.grey[700], size: 60),
                              const SizedBox(height: 12),
                              Text(
                                '아직 음악이 없습니다',
                                style: TextStyle(color: Colors.grey[400], fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final feed = _topFeeds[index];
                          return _buildTrendingItem(feed, index + 1);
                        },
                        childCount: _topFeeds.length,
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // 최근 업로드
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.fiber_new,
                            color: Color(0xFF00D4FF),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '최근 업로드',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  // Recent Horizontal List
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: _recentFeeds.isEmpty
                          ? Center(
                              child: Text(
                                '최근 업로드된 음악이 없습니다',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _recentFeeds.length,
                              itemBuilder: (context, index) {
                                return _buildRecentCard(_recentFeeds[index]);
                              },
                            ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
    );
  }

  Widget _buildTrendingItem(Feed feed, int rank) {
    // Medal colors for top 3
    Color? medalColor;
    if (rank == 1) {
      medalColor = const Color(0xFFFFD700); // Gold
    } else if (rank == 2) {
      medalColor = const Color(0xFFC0C0C0); // Silver
    } else if (rank == 3) {
      medalColor = const Color(0xFFCD7F32); // Bronze
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: medalColor ?? Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: rank <= 3 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
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
                  ? const Icon(Icons.music_note, color: Colors.white30, size: 24)
                  : null,
            ),
          ],
        ),
        title: Text(
          feed.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          feed.writerName,
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFF2D55),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerScreen(feed: feed),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChartScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentCard(Feed feed) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeedDetailScreen(feed: feed),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
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
                    child: Icon(Icons.music_note, color: Colors.white30, size: 40),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            feed.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            feed.writerName,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      ),
    );
  }
}
