import 'package:cached_network_image/cached_network_image.dart';
import 'package:cineflix/description.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HindiComedyMovies extends StatefulWidget {
  const HindiComedyMovies({super.key, required this.hindiComedyMovies});
  final List hindiComedyMovies;

  @override
  State<HindiComedyMovies> createState() => _HindiComedyMoviesState();
}

class _HindiComedyMoviesState extends State<HindiComedyMovies> {
  late Box comedyBox;
  List cachedComedyMovies = [];
  bool isHiveInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeHive();
    print("Widget comedyMovies: ${widget.hindiComedyMovies.length}");
  }

  Future<void> initializeHive() async {
    try {
      print("Opening Hive Box...");
      comedyBox = await Hive.openBox('ComedyMoviesBox');
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
    final cachedData = comedyBox.get('comedyHindiMovies');
    if (cachedData != null && cachedData.isNotEmpty) {
      print("Cached data found: ${cachedData.length}");
      setState(() {
        cachedComedyMovies = List.from(cachedData);
      });
    } else {
      print("No cached data found. Using passed comedyMovies.");
      setState(() {
        cachedComedyMovies = widget.hindiComedyMovies;
      });
      comedyBox.put('comedyHindiMovies', widget.hindiComedyMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHiveInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    print("Rendering movies: ${cachedComedyMovies.length}");

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
            'Comedy Movies',
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
              itemCount: cachedComedyMovies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Description(
                          name: cachedComedyMovies[index]['original_name'] ?? cachedComedyMovies[index]['title'],
                          bannerUrl: cachedComedyMovies[index]['backdrop_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedComedyMovies[index]['backdrop_path'] : '',
                          posterUrl: cachedComedyMovies[index]['poster_path'] != null?'https://image.tmdb.org/t/p/w500'+cachedComedyMovies[index]['poster_path'] : '',
                          description: cachedComedyMovies[index]['overview'] ?? 'No description available',
                          vote: cachedComedyMovies[index]['vote_average']?.toString() ?? 'N/A',
                          launch_on: cachedComedyMovies[index]['release_date'] ?? 'Unknown',
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
                            imageUrl: getValidImageUrl(cachedComedyMovies[index]['poster_path'],),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: height * 0.025,),
                        Text(
                          cachedComedyMovies[index]['original_name'] != null? cachedComedyMovies[index]['original_name'] : cachedComedyMovies[index]['title'],
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
