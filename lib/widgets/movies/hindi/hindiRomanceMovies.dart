import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiRomanceMovies extends StatefulWidget {
  const HindiRomanceMovies({super.key, required this.hindiRomanceMovies});
  final List hindiRomanceMovies;

  @override
  State<HindiRomanceMovies> createState() => _HindiRomanceMoviesState();
}

class _HindiRomanceMoviesState extends State<HindiRomanceMovies> {
  late Box romanceBox;
  List cachedRomanceMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget romanceMovies: ${widget.hindiRomanceMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      romanceBox = await Hive.openBox('RomanceMoviesBox');
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
    final cachedData = romanceBox.get('romanceHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedRomanceMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed romanceMovies.");
      setState(() {
        cachedRomanceMovies = widget.hindiRomanceMovies;
      });
      romanceBox.put('romanceHindiMovies', widget.hindiRomanceMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedRomanceMovies.length}");

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
            'Romance Movies',
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
              itemCount: cachedRomanceMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedRomanceMovies[index]['original_name'] ?? cachedRomanceMovies[index]['title'],
                          bannerUrl: cachedRomanceMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedRomanceMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedRomanceMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedRomanceMovies[index]['poster_path'] : '',
                          description: cachedRomanceMovies[index]['overview'] ?? 'No description available',
                          vote: cachedRomanceMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedRomanceMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedRomanceMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedRomanceMovies[index]['original_name'] != null? cachedRomanceMovies[index]['original_name'] : cachedRomanceMovies[index]['title'],
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
