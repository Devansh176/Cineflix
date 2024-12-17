import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiPopularMovies extends StatefulWidget {
  const HindiPopularMovies({super.key, required this.hindiPopular});
  final List hindiPopular;

  @override
  State<HindiPopularMovies> createState() => _HindiPopularMoviesState();
}

class _HindiPopularMoviesState extends State<HindiPopularMovies> {
  late Box popularBox;
  List cachedPopularMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget popularMovies: ${widget.hindiPopular.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      popularBox = await Hive.openBox('PopularMoviesBox');
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
    final cachedData = popularBox.get('popularHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedPopularMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed popularMovies.");
      setState(() {
        cachedPopularMovies = widget.hindiPopular;
      });
      popularBox.put('popularHindiMovies', widget.hindiPopular);
      print("Saving popular movies to Hive: ${widget.hindiPopular.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering popular movies: ${cachedPopularMovies.length}");

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
            'Popular Movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize * 1.22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: height * 0.02,),
          SizedBox(
            height: height * 0.36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cachedPopularMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedPopularMovies[index]['original_name'] != null? cachedPopularMovies[index]['original_name'] : cachedPopularMovies[index]['title'],
                          bannerUrl: cachedPopularMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedPopularMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedPopularMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedPopularMovies[index]['poster_path'] : '',
                          description: cachedPopularMovies[index]['overview'] ?? 'No description available',
                          vote: cachedPopularMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedPopularMovies[index]['release_date'] ?? 'Unknown',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50,),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: getValidImageUrl(cachedPopularMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedPopularMovies[index]['original_name'] != null? cachedPopularMovies[index]['original_name'] : cachedPopularMovies[index]['title'],
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
