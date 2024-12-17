import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MusicFilms extends StatefulWidget {
  const MusicFilms({super.key, required this.musicFilms});
  final List musicFilms;

  @override
  State<MusicFilms> createState() => _MusicFilmsState();
}

class _MusicFilmsState extends State<MusicFilms> {
  late Box musicBox;
  List cachedMusicFilms = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget musicFilms: ${widget.musicFilms.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      musicBox = await Hive.openBox('MusicFilmsBox');
      print("Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        loadMovies();
      }
    }
  }

  void loadMovies() {
    final cachedData = musicBox.get('musicFilms');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedMusicFilms = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed musicFilms.");
      setState(() {
        cachedMusicFilms = widget.musicFilms;
      });
      musicBox.put('musicFilms', widget.musicFilms);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedMusicFilms.length}");

    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    final fontSize = width * 0.05;
    final padding = width * 0.05;

    String getValidImageUrl(String? url) {
      return (url != null && url.isNotEmpty)
          ? 'https://image.tmdb.org/t/p/w500$url'
          : 'https://via.placeholder.com/300';
    }

    return Container(
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Music Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.39,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cachedMusicFilms.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedMusicFilms[index]['original_name'] ?? cachedMusicFilms[index]['title'],
                          bannerUrl: cachedMusicFilms[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedMusicFilms[index]['backdrop_path'] : '',
                          posterUrl: cachedMusicFilms[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedMusicFilms[index]['poster_path'] : '',
                          description: cachedMusicFilms[index]['overview'] ?? 'No description available',
                          vote: cachedMusicFilms[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedMusicFilms[index]['release_date'] ?? 'Unknown',
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
                            borderRadius: BorderRadius.circular(50,),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(cachedMusicFilms[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedMusicFilms[index]['original_name'] != null? cachedMusicFilms[index]['original_name'] : cachedMusicFilms[index]['title'],
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
          )
        ],
      ),
    );
  }
}
