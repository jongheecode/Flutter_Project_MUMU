// lib/screens/chart_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/feed.dart';
import 'music_player_screen.dart';
import 'package:flutter/foundation.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'createdAt'; // 'playCount', 'likeCount', or 'createdAt'
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                '차트',
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
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFFF2D55),
                indicatorWeight: 3,
                labelColor: const Color(0xFFFF2D55),
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: '커뮤니티 차트'),
                  Tab(text: '글로벌 TOP 100'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCommunityChart(),
            _buildGlobalChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityChart() {
    return FutureBuilder<List<Feed>>(
      future: ApiService.fetchFeeds(sortBy: _sortBy),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF2D55)),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.grey, size: 60),
                const SizedBox(height: 16),
                Text(
                  '에러가 발생했습니다',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_off, color: Colors.grey[700], size: 80),
                const SizedBox(height: 20),
                Text(
                  '등록된 음악이 없습니다',
                  style: TextStyle(color: Colors.grey[400], fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '첫 음악을 업로드해보세요!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          );
        }

        final feeds = snapshot.data!;
        return RefreshIndicator(
          color: const Color(0xFFFF2D55),
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              return _buildChartItem(feeds[index], index + 1);
            },
          ),
        );
      },
    );
  }

  Widget _buildGlobalChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.public, color: Colors.grey[700], size: 80),
          const SizedBox(height: 20),
          Text(
            '글로벌 차트',
            style: TextStyle(color: Colors.grey[400], fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '곧 업데이트 예정입니다',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF2D55), Color(0xFFFF6B6B)],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              'Spotify API 연동 예정',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartItem(Feed feed, int rank) {
    Color rankColor = Colors.white;
    if (rank <= 3) {
      rankColor = const Color(0xFFFFD700);
    } else if (rank <= 10) {
      rankColor = const Color(0xFFC0C0C0);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: rank <= 3 ? const Color(0xFF1C1C1E) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rankColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            Stack(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF2C2C2E),
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
                      ? const Icon(Icons.music_note, color: Colors.white30)
                      : null,
                ),
                if (rank <= 3)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF2D55),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF2D55).withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        title: Text(
          feed.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  feed.category,
                  style: const TextStyle(
                    color: Color(0xFFFF2D55),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feed.writerName,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _sortBy == 'playCount' ? Icons.play_circle : Icons.favorite,
                  color: Colors.grey[600],
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _sortBy == 'playCount'
                      ? _formatNumber(feed.playCount)
                      : _formatNumber(feed.likeCount),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.more_horiz,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicPlayerScreen(feed: feed),
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}