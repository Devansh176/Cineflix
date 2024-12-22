import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiTalkShow extends StatefulWidget {
  const HindiTalkShow({super.key, required this.hindiTalkShow});
  final List hindiTalkShow;

  @override
  State<HindiTalkShow> createState() => _HindiTalkShowState();
}

class _HindiTalkShowState extends State<HindiTalkShow> {
  late Box talkShowBox;
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeHiveOnce();
  }

  Future<void> _initializeHiveOnce() async {
    if (!isHiveInitialized) {
      try {
        if (Hive.isBoxOpen('talkShowBox')) {
          talkShowBox = Hive.box('talkShowBox');
        } else {
          talkShowBox = await Hive.openBox('talkShowBox');
        }
        setState(() {
          isHiveInitialized = true;
        });
      } catch (e) {
        print("Error initializing Hive: $e");
      }
    }
  }

  Future<List> loadMovies() async {
    try {
      if (!isHiveInitialized) {
        await _initializeHiveOnce();
      }

      final cachedData = talkShowBox.get('hindiTalkShow');
      final cachedTimestamp = talkShowBox.get('hindiTalkShowTimestamp');

      if (cachedData != null && cachedData.isNotEmpty && cachedTimestamp != null) {
        final currentTime = DateTime.now();
        final cacheTime = DateTime.parse(cachedTimestamp);
        final difference = currentTime.difference(cacheTime).inDays;

        if (difference <= 3) {
          return List.from(cachedData);
        }
      }

      await talkShowBox.put('hindiTalkShow', widget.hindiTalkShow);
      await talkShowBox.put('hindiTalkShowTimestamp', DateTime.now().toIso8601String());

      return widget.hindiTalkShow;
    } catch (e) {
      return [];
    }
  }

  String getValidImageUrl(String? url) {
    return (url != null && url.isNotEmpty)
        ? 'https://image.tmdb.org/t/p/w500$url'
        : 'https://via.placeholder.com/300';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    return FutureBuilder<List>(
      future: loadMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Failed to load series. Please try again.',
                  style: TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No series available.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final series = snapshot.data!;
        return Container(
          padding: EdgeInsets.only(
            top: padding * 0.8,
            left: padding * 0.8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Talk Show',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 1.22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.39,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: series.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Description(
                              name: series[index]['original_name'] ??
                                  series[index]['title'],
                              bannerUrl: getValidImageUrl(
                                  series[index]['backdrop_path']),
                              posterUrl: getValidImageUrl(
                                  series[index]['poster_path']),
                              description: series[index]['overview'] ??
                                  'No description available',
                              vote: series[index]['vote_average']?.toString() ??
                                  'N/A',
                              launch_on:
                              series[index]['release_date'] ?? 'Unknown',
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: width * 0.4,
                        child: Column(
                          children: [
                            Container(
                              height: height * 0.25,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: getValidImageUrl(
                                    series[index]['poster_path']),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: Text("",),),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.025,
                            ),
                            Text(
                              series[index]['original_name'] ??
                                  series[index]['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize * 0.8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
