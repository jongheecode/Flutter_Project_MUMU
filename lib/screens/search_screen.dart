// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/feed.dart';
import 'music_player_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Feed> _allFeeds = [];
  List<Feed> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAllFeeds();
  }

  Future<void> _loadAllFeeds() async {
    setState(() => _isLoading = true);
    _allFeeds = await ApiService.fetchFeeds(sortBy: 'playCount');
    setState(() => _isLoading = false);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allFeeds.where((feed) {
        return feed.title.toLowerCase().contains(query.toLowerCase()) ||
               feed.writerName.toLowerCase().contains(query.toLowerCase()) ||
               feed.category.toLowerCase().contains(query.toLowerCase()) ||
               feed.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          '검색',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 검색 바
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                onChanged: _performSearch,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  hintText: '노래, 아티스트, 카테고리 검색...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 검색 결과 또는 인기 검색어
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF2D55)),
                    )
                  : !_isSearching
                      ? _buildPopularSection()
                      : _searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, color: Colors.grey[700], size: 80),
                                  const SizedBox(height: 20),
                                  Text(
                                    '검색 결과가 없습니다',
                                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '다른 키워드로 검색해보세요',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '🔥 인기 음악',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allFeeds.take(10).length,
            itemBuilder: (context, index) {
              final feed = _allFeeds[index];
              return _buildMusicItem(feed, index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return _buildMusicItem(_searchResults[index], null);
      },
    );
  }

  Widget _buildMusicItem(Feed feed, int? rank) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rank != null) ...[
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3 ? const Color(0xFFFFD700) : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
      subtitle: Row(
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
          const SizedBox(width: 6),
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_circle, color: Colors.grey[600], size: 16),
          const SizedBox(width: 4),
          Text(
            '${feed.playCount}',
            style: TextStyle(color: Colors.grey[400], fontSize: 12),
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
