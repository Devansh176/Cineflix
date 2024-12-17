import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThrillerMovies extends StatefulWidget {
  const ThrillerMovies({super.key, required this.thrillerMovies});
  final List thrillerMovies;

  @override
  State<ThrillerMovies> createState() => _ThrillerMoviesState();
}

class _ThrillerMoviesState extends State<ThrillerMovies> {
  late Box thrillerBox;
  List cachedThrillerMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget thrillerMovies: ${widget.thrillerMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      thrillerBox = await Hive.openBox('ThrillerMoviesBox');
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
    final cachedData = thrillerBox.get('thrillerMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedThrillerMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed thrillerMovies.");
      setState(() {
        cachedThrillerMovies = widget.thrillerMovies;
      });
      thrillerBox.put('thrillerMovies', widget.thrillerMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedThrillerMovies.length}");

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
            'Thriller Movies',
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
              itemCount: cachedThrillerMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedThrillerMovies[index]['original_name'] ?? cachedThrillerMovies[index]['title'],
                          bannerUrl: cachedThrillerMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedThrillerMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedThrillerMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedThrillerMovies[index]['poster_path'] : '',
                          description: cachedThrillerMovies[index]['overview'] ?? 'No description available',
                          vote: cachedThrillerMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedThrillerMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedThrillerMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedThrillerMovies[index]['original_name'] != null? cachedThrillerMovies[index]['original_name'] : cachedThrillerMovies[index]['title'],
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
