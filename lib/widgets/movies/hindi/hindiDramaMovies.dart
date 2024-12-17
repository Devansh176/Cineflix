import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiDramaMovies extends StatefulWidget {
  const HindiDramaMovies({super.key, required this.hindiDramaMovies});
  final List hindiDramaMovies;

  @override
  State<HindiDramaMovies> createState() => _HindiDramaMoviesState();
}

class _HindiDramaMoviesState extends State<HindiDramaMovies> {
  late Box dramaBox;
  List cachedDramaMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget dramaMovies: ${widget.hindiDramaMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      dramaBox = await Hive.openBox('DramaMoviesBox');
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
    final cachedData = dramaBox.get('dramaHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedDramaMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed adventureMovies.");
      setState(() {
        cachedDramaMovies = widget.hindiDramaMovies;
      });
      dramaBox.put('dramaHindiMovies', widget.hindiDramaMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    print("Rendering movies: ${cachedDramaMovies.length}");

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
            'Drama Movies',
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
              itemCount: cachedDramaMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedDramaMovies[index]['original_name'] ?? cachedDramaMovies[index]['title'],
                          bannerUrl: cachedDramaMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedDramaMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedDramaMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedDramaMovies[index]['poster_path'] : '',
                          description: cachedDramaMovies[index]['overview'] ?? 'No description available',
                          vote: cachedDramaMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedDramaMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedDramaMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedDramaMovies[index]['original_name'] != null? cachedDramaMovies[index]['original_name'] : cachedDramaMovies[index]['title'],
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
