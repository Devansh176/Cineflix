import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class WesternMovies extends StatefulWidget {
  const WesternMovies({super.key, required this.westernMovies});
  final List westernMovies;

  @override
  State<WesternMovies> createState() => _WesternMoviesState();
}

class _WesternMoviesState extends State<WesternMovies> {
  late Box westernBox;
  List cachedWesternBox = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget westernMovies: ${widget.westernMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      westernBox = await Hive.openBox('WesternMoviesBox');
      print("Hive Box Opened Successfully");
    } catch (e) {
      print("Error initializing Hive : $e");
    } finally {
      if (mounted) {
        setState(() {
          isHiveInitialized = true;
        });
        // Load movies after initializing Hive
        loadMovies();
      }
    }
  }

  void loadMovies() {
    final cachedData = westernBox.get('westernMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedWesternBox = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed westernMovies.");
      setState(() {
        cachedWesternBox = widget.westernMovies;
      });
      westernBox.put('westernMovies', widget.westernMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    print("Rendering movies: ${cachedWesternBox.length}");
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
            'Western Movies',
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
              itemCount: cachedWesternBox.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedWesternBox[index]['original_name'] ?? cachedWesternBox[index]['title'],
                          bannerUrl: cachedWesternBox[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedWesternBox[index]['backdrop_path'] : '',
                          posterUrl: cachedWesternBox[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedWesternBox[index]['poster_path'] : '',
                          description: cachedWesternBox[index]['overview'] ?? 'No description available',
                          vote: cachedWesternBox[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedWesternBox[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedWesternBox[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedWesternBox[index]['original_name'] != null? cachedWesternBox[index]['original_name'] : cachedWesternBox[index]['title'],
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
