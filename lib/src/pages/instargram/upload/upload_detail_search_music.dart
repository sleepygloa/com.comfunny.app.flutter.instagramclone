import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class UploadDetailSearchMusic extends StatefulWidget {
  const UploadDetailSearchMusic({Key? key}) : super(key: key);

  @override
  State<UploadDetailSearchMusic> createState() => _UploadDetailSearchMusicState();
}

class _UploadDetailSearchMusicState extends State<UploadDetailSearchMusic>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AudioPlayer _audioPlayer;
  int? _currentlyPlayingIndex;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> musicList = [
    {
      'title': 'Happy Life',
      'artist': 'Bensound',
      'duration': '2:30',
      'url': 'https://www.bensound.com/bensound-music/bensound-happyrock.mp3'
    },
    {
      'title': 'Acoustic Breeze',
      'artist': 'Bensound',
      'duration': '2:38',
      'url': 'https://www.bensound.com/bensound-music/bensound-acousticbreeze.mp3'
    },
    {
      'title': 'Creative Minds',
      'artist': 'Bensound',
      'duration': '2:45',
      'url': 'https://www.bensound.com/bensound-music/bensound-creativeminds.mp3'
    },
    {
      'title': 'Jazz Comedy',
      'artist': 'Bensound',
      'duration': '2:00',
      'url': 'https://www.bensound.com/bensound-music/bensound-jazzyfrenchy.mp3'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _playMusic(int index, String url) async {
    if (_currentlyPlayingIndex == index) {
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingIndex = null;
      });
    } else {
      try {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
        setState(() {
          _currentlyPlayingIndex = index;
        });
      } catch (e) {
        print("음악 재생 에러: $e");
      }
    }
  }

  List<Map<String, String>> _filterMusicList() {
    if (_searchQuery.isEmpty) {
      return musicList;
    }
    return musicList
        .where((music) => music['title']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMusicList = _filterMusicList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          // 검색 영역
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "음악 검색",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "취소",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 탭
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "회원님을 위한 추천"),
              Tab(text: "둘러보기"),
            ],
            labelColor: Colors.black,
            indicatorColor: Colors.black,
          ),
          // 탭 뷰
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 첫 번째 탭
                ListView.builder(
                  itemCount: filteredMusicList.length,
                  itemBuilder: (context, index) {
                    final music = filteredMusicList[index];
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage('assets/album_cover.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(music['title'] as String),
                      subtitle: Text('${music['artist']} • ${music['duration']}'),
                      trailing: IconButton(
                        icon: Icon(
                          _currentlyPlayingIndex == index
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_fill,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          _playMusic(index, music['url']!);
                        },
                      ),
                    );
                  },
                ),
                // 두 번째 탭
                Column(
                  children: [
                    // 이벤트 그룹명 + 더보기
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "추천 음악",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // 더보기 버튼 동작
                              print("더보기 클릭됨");
                            },
                            child: const Text(
                              "더보기",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 상위 3개만 표시
                    Expanded(
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          final music = musicList[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('assets/album_cover.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(music['title'] as String),
                            subtitle: Text('${music['artist']} • ${music['duration']}'),
                            trailing: IconButton(
                              icon: Icon(
                                _currentlyPlayingIndex == index
                                    ? Icons.stop_circle_outlined
                                    : Icons.play_circle_fill,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                _playMusic(index, music['url']!);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
