import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiUpcomingMovies extends StatefulWidget {
  const HindiUpcomingMovies({super.key, required this.hindiUpcomingMovies});
  final List hindiUpcomingMovies;

  @override
  State<HindiUpcomingMovies> createState() => _HindiUpcomingMoviesState();
}

class _HindiUpcomingMoviesState extends State<HindiUpcomingMovies> {
  late Box upcomingBox;
  List cachedUpcomingMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget upcomingMovies: ${widget.hindiUpcomingMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      upcomingBox = await Hive.openBox('UpcomingMoviesBox');
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
    final cachedData = upcomingBox.get('upcomingHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedUpcomingMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed upcomingMovies.");
      setState(() {
        cachedUpcomingMovies = widget.hindiUpcomingMovies;
      });
      upcomingBox.put('upcomingHindiMovies', widget.hindiUpcomingMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    print("Rendering movies: ${cachedUpcomingMovies.length}");

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
            'Upcoming Movies',
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
              itemCount: cachedUpcomingMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedUpcomingMovies[index]['original_name'] ?? cachedUpcomingMovies[index]['title'],
                          bannerUrl: cachedUpcomingMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedUpcomingMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedUpcomingMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedUpcomingMovies[index]['poster_path'] : '',
                          description: cachedUpcomingMovies[index]['overview'] ?? 'No description available',
                          vote: cachedUpcomingMovies[index]['vote_average']?.toString() ?? 'Not Rated Yet',
                          launch_on: cachedUpcomingMovies[index]['first_air_date'] ?? cachedUpcomingMovies[index]['release_date'],
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
                            imageUrl: getValidImageUrl(cachedUpcomingMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedUpcomingMovies[index]['original_name'] != null? cachedUpcomingMovies[index]['original_name'] : cachedUpcomingMovies[index]['title'],
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
